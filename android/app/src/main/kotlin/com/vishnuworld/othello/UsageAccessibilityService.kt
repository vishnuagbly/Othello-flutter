package com.vishnuworld.othello

import android.accessibilityservice.AccessibilityService
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.view.accessibility.AccessibilityEvent
import androidx.core.content.ContextCompat
import com.vishnuworld.othello.data.EventEntity
import com.vishnuworld.othello.data.ServiceStatusEntity
import com.vishnuworld.othello.data.UsageDatabase
import java.util.concurrent.Executors

class UsageAccessibilityService : AccessibilityService() {

    private val ioExecutor = Executors.newSingleThreadExecutor()
    private var lastPackage: String? = null
    private var receiverRegistered = false

    private val screenReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            val type = when (intent?.action) {
                Intent.ACTION_SCREEN_ON -> "screen_on"
                Intent.ACTION_SCREEN_OFF -> "screen_off"
                Intent.ACTION_USER_PRESENT -> "user_present"
                Intent.ACTION_SHUTDOWN -> "shutdown"
                else -> return
            }
            logEvent(type, null)
        }
    }

    override fun onServiceConnected() {
        super.onServiceConnected()
        setConnected(1)
        if (!receiverRegistered) {
            ContextCompat.registerReceiver(
                this,
                screenReceiver,
                IntentFilter().apply {
                    addAction(Intent.ACTION_SCREEN_ON)
                    addAction(Intent.ACTION_SCREEN_OFF)
                    addAction(Intent.ACTION_USER_PRESENT)
                    addAction(Intent.ACTION_SHUTDOWN)
                },
                ContextCompat.RECEIVER_NOT_EXPORTED,
            )
            receiverRegistered = true
        }
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event?.eventType != AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED) return
        val pkg = event.packageName?.toString() ?: return
        if (pkg == lastPackage) return
        lastPackage = pkg
        logEvent("foreground", pkg)
    }

    override fun onInterrupt() {}

    override fun onUnbind(intent: Intent?): Boolean {
        teardown()
        return super.onUnbind(intent)
    }

    override fun onDestroy() {
        teardown()
        super.onDestroy()
    }

    private fun teardown() {
        if (receiverRegistered) {
            try {
                unregisterReceiver(screenReceiver)
            } catch (_: IllegalArgumentException) {
            }
            receiverRegistered = false
        }
        setConnected(0)
    }

    private fun logEvent(type: String, pkg: String?) {
        val ts = System.currentTimeMillis()
        val appContext = applicationContext
        ioExecutor.execute {
            UsageDatabase.get(appContext).usageDao()
                .insertEvent(EventEntity(ts = ts, type = type, packageName = pkg))
        }
    }

    private fun setConnected(value: Int) {
        val ts = System.currentTimeMillis()
        val appContext = applicationContext
        ioExecutor.execute {
            UsageDatabase.get(appContext).usageDao()
                .setStatus(ServiceStatusEntity(connected = value, updatedAt = ts))
        }
    }
}
