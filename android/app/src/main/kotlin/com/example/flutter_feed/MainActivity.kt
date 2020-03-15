package com.example.flutter_feed

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant
import java.util.*

class MainActivity : FlutterActivity() {

    private val sharedPreferences by lazy {
        context.getSharedPreferences(Constants.storageKey, Context.MODE_PRIVATE)
    }
    private val channel = "feed_news"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        GeneratedPluginRegistrant.registerWith(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, channel).setMethodCallHandler { call, result ->
            when (call.method) {
                "reminderHour" -> {
                    val data = getConfigInt(Constants.reminderHour)
                    result.success(data)
                }
                "reminderMin" -> {
                    val data = getConfigInt(Constants.reminderMin)
                    result.success(data)
                }
                "backgroundFetch" -> {
                    val data = getConfigBool(Constants.backgroundFetchKey)
                    result.success(data)
                }
                "offlineData" -> {
                    val data = getLoadedData()
                    result.success(data)
                }
                "saveSettings" -> {
                    val arguments = call.arguments<Map<String, String>>()
                    saveData(arguments)
                    result.success(true)
                }
                "scheduleReminder" -> {
                    scheduleReminder()
                    result.success(true)
                }
                else -> result.notImplemented()
            }

        }
    }

    private fun scheduleReminder() {

        val hour = getConfigInt(Constants.reminderHour)
        val min = getConfigInt(Constants.reminderMin)

        val calender = Calendar.getInstance()
        calender.set(Calendar.HOUR_OF_DAY, hour)
        calender.set(Calendar.MINUTE, min)
        calender.set(Calendar.SECOND, 0)

        val intent = Intent(this, AlarmReceiver::class.java)
        val pendingIntent = PendingIntent.getBroadcast(context, 0, intent, 0)

        val alarmManager = getSystemService(Context.ALARM_SERVICE) as AlarmManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.KITKAT) {
            alarmManager.setInexactRepeating(AlarmManager.RTC_WAKEUP, calender.timeInMillis,AlarmManager.INTERVAL_DAY, pendingIntent)
        }

    }


    private fun saveData(map: Map<String, Any>) {
        val editor = sharedPreferences.edit()
        map.map {
            Log.i("Settings", it.key)
            when (val value = it.value) {
                is String -> editor.putString(it.key, value)
                is Boolean -> editor.putBoolean(it.key, value)
                is Int -> editor.putInt(it.key, value)
                else -> null
            }
        }
        editor.apply()
    }


    private fun getConfigInt(key: String): Int {
        return sharedPreferences.getInt(key, 0)
    }

    private fun getConfigBool(key: String): Boolean {
        return sharedPreferences.getBoolean(key, false)
    }

    private fun getLoadedData(): String? {
        return sharedPreferences.getString(Constants.dataKey, "")
    }

}
