package com.example.flutter_feed

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.util.Log
import com.google.gson.Gson
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.GlobalScope
import kotlinx.coroutines.launch
import okhttp3.OkHttpClient
import okhttp3.Request
import org.w3c.dom.Document
import org.w3c.dom.Element
import org.w3c.dom.Node
import org.w3c.dom.NodeList
import java.io.ByteArrayInputStream
import java.util.*
import javax.xml.parsers.DocumentBuilderFactory

class ChargingIntent : BroadcastReceiver() {


    override fun onReceive(context: Context?, intent: Intent?) {
        Log.i("Power Plugged", "True")
        GlobalScope.launch(Dispatchers.IO) {
            intent?.let { powerIntent ->
                if (powerIntent.action == Intent.ACTION_POWER_CONNECTED) {
                    context?.let { ctx ->
                        val sharedPref = ctx.getSharedPreferences(Constants.storageKey, Context.MODE_PRIVATE)
                        sharedPref.getBoolean(Constants.backgroundFetchKey, true).let { optionEnabled ->
                            if (optionEnabled) {
                                getAndPersist {
                                    val editor = sharedPref.edit()
                                    val serializedData = Gson().toJson(it)
                                    editor.putString(Constants.dataKey, serializedData)
                                    editor.putString(Constants.timeStamp, Date().toString())
                                    editor.apply()
                                }

                            }
                        }
                    }

                }
            }
        }
    }
}

private fun getAndPersist(block: (List<NewsItem>) -> Unit) {
    val data = loadData()
    data?.let {
        val didWrite = block(it)
        Log.i("Persisted", didWrite.toString())

    }
}

private fun loadData(): List<NewsItem>? {
    val client = OkHttpClient()
    val request = Request.Builder()
            .url("https://news.yahoo.com/rss/entertainment")
            .build()
    val data = client.newCall(request).execute().body

    return data?.let { responseBody ->
        val body = responseBody.string()
        parseXML(body)
    }

}

private fun parseXML(xml: String): List<NewsItem> {

    fun getAllNodes(nodeList: NodeList): List<Node> {
        val listOfNodes = mutableListOf<Node>()
        for (i in 0 until nodeList.length) {
            val node = nodeList.item(i)
            listOfNodes.add(node)
        }
        return listOfNodes.toList()
    }

    val inputStream = ByteArrayInputStream(xml.toByteArray(Charsets.UTF_8))

    val xmlDoc: Document = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(inputStream)
    xmlDoc.documentElement.normalize()
    val itemList = xmlDoc.getElementsByTagName("item")
    return getAllNodes(itemList).map { itemNode ->
        val element = itemNode as Element
        val title = element.getElementsByTagName("title").item(0).textContent
        val preview = (element.getElementsByTagName("media:content").item(0).attributes.getNamedItem("url")).textContent
        val source = element.getElementsByTagName("source").item(0).textContent
        val date = element.getElementsByTagName("pubDate").item(0).textContent
        val link = element.getElementsByTagName("link").item(0).textContent

        Log.i("Xml Parser", "Parsed $title")
        NewsItem(title, preview, date, link, source)


    }

}


