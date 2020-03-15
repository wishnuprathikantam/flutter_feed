package com.example.flutter_feed

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import androidx.core.content.ContextCompat.getSystemService

class AlarmReceiver : BroadcastReceiver() {

    override fun onReceive(context: Context?, intent: Intent?) {
        //Show Notification
        Log.i("AlarmIntent","true")
        context?.let { ctx ->
            val notificationManager: NotificationManager? = getSystemService(ctx, NotificationManager::class.java)
            notificationManager?.let { notifyManager ->
                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
                    val mChannel = NotificationChannel("FEED_NEWS.REMINDERS", "Check some news!", NotificationManager.IMPORTANCE_LOW)
                    mChannel.description = "You've asked me to remind you, please check news."
                    mChannel.enableVibration(false)
                    mChannel.setShowBadge(true)
                    notifyManager.createNotificationChannel(mChannel)
                } else {
                    val mBuilder = NotificationCompat.Builder(ctx, "FEED_NEWS.REMINDERS")
                            .setSmallIcon(R.mipmap.ic_launcher)
                            .setContentTitle("Check some news!")
                            .setContentText("You've asked me to remind you, please check news.")
                            .setPriority(NotificationCompat.PRIORITY_DEFAULT)
                            .setAutoCancel(true)
                    notifyManager.notify(1, mBuilder.build())
                }
            } ?: Log.i("Alarm Reciever", "Got null with context")

        }

    }

}