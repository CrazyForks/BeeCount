package com.example.beecount

import android.accessibilityservice.AccessibilityService
import android.accessibilityservice.AccessibilityServiceInfo
import android.content.Intent
import android.graphics.Bitmap
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.util.Log
import android.view.accessibility.AccessibilityEvent
import java.io.File
import java.io.FileOutputStream

/**
 * 无障碍服务 - 监听截图动作
 *
 * 工作原理：
 * 1. 监听 TYPE_WINDOW_STATE_CHANGED 事件
 * 2. 检测是否是截图相关窗口（系统截图工具、截图编辑器等）
 * 3. 使用 takeScreenshot() API 立即捕获屏幕（Android 9+）
 */
class ScreenshotAccessibilityService : AccessibilityService() {
    companion object {
        private const val TAG = "ScreenshotAccessibility"
        private val SCREENSHOT_PACKAGE_NAMES = listOf(
            "com.android.systemui", // 系统截图
            "com.miui.screenshot", // 小米截图
            "com.huawei.screenshot", // 华为截图
            "com.samsung.screenshot", // 三星截图
            "com.oppo.screenshot", // OPPO截图
            "com.vivo.screenshot", // vivo截图
        )

        var onScreenshotDetected: ((String) -> Unit)? = null
        var instance: ScreenshotAccessibilityService? = null
    }

    private val handler = Handler(Looper.getMainLooper())
    private var lastScreenshotTime = 0L
    private var pendingScreenshotCheck: Runnable? = null

    override fun onServiceConnected() {
        super.onServiceConnected()
        instance = this

        val info = AccessibilityServiceInfo().apply {
            eventTypes = AccessibilityEvent.TYPE_WINDOW_STATE_CHANGED or
                        AccessibilityEvent.TYPE_WINDOW_CONTENT_CHANGED
            feedbackType = AccessibilityServiceInfo.FEEDBACK_GENERIC
            flags = AccessibilityServiceInfo.FLAG_INCLUDE_NOT_IMPORTANT_VIEWS or
                   AccessibilityServiceInfo.FLAG_REPORT_VIEW_IDS
            notificationTimeout = 100
        }
        serviceInfo = info

        Log.d(TAG, "✅ 截图监听服务已启动")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return

        try {
            // 检测是否是截图相关事件
            val packageName = event.packageName?.toString() ?: return
            val className = event.className?.toString() ?: ""

            // 检查是否是截图相关窗口
            val isScreenshotEvent = SCREENSHOT_PACKAGE_NAMES.any { packageName.contains(it) } ||
                                   className.contains("screenshot", ignoreCase = true) ||
                                   className.contains("capture", ignoreCase = true)

            if (isScreenshotEvent) {
                val currentTime = System.currentTimeMillis()
                // 防止重复触发（500ms内只响应一次）
                if (currentTime - lastScreenshotTime < 500) {
                    return
                }
                lastScreenshotTime = currentTime

                Log.d(TAG, "🔔 检测到截图事件: package=$packageName, class=$className")
                handleScreenshotDetected()
            }
        } catch (e: Exception) {
            Log.e(TAG, "处理事件失败", e)
        }
    }

    private fun handleScreenshotDetected() {
        Log.d(TAG, "📸 检测到截图动作")

        // 取消之前的待处理任务
        pendingScreenshotCheck?.let {
            handler.removeCallbacks(it)
            Log.d(TAG, "⚠️ 取消之前的截图检查任务（防止重复）")
        }

        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            // Android 11+ 使用 takeScreenshot API
            takeScreenshotWithApi()
        } else {
            // Android 10 及以下，等待文件写入
            waitForScreenshotFile()
        }
    }

    private fun takeScreenshotWithApi() {
        // Android 11+ 的 takeScreenshot API 需要特殊权限，暂时使用等待文件方案
        Log.d(TAG, "使用文件等待方案（Android ${Build.VERSION.SDK_INT}）")
        waitForScreenshotFile()
    }

    private fun waitForScreenshotFile() {
        // 延迟等待文件写入（通常截图后1-2秒文件才可用）
        pendingScreenshotCheck = Runnable {
            // 查找最新的截图文件
            val screenshotFile = findLatestScreenshot()
            if (screenshotFile != null) {
                Log.d(TAG, "✅ 找到最新截图: ${screenshotFile.absolutePath}")
                onScreenshotDetected?.invoke(screenshotFile.absolutePath)
            } else {
                Log.w(TAG, "⚠️ 未找到截图文件")
            }
            pendingScreenshotCheck = null
        }
        handler.postDelayed(pendingScreenshotCheck!!, 500) // 等待500ms（作为快速备用方案）
    }

    private fun findLatestScreenshot(): File? {
        try {
            val screenshotDirs = listOf(
                File(android.os.Environment.getExternalStorageDirectory(), "Pictures/Screenshots"),
                File(android.os.Environment.getExternalStorageDirectory(), "DCIM/Screenshots"),
            )

            var latestFile: File? = null
            var latestTime = 0L

            screenshotDirs.forEach { dir ->
                if (dir.exists() && dir.isDirectory) {
                    dir.listFiles()?.forEach { file ->
                        if (file.isFile && file.name.contains("screenshot", ignoreCase = true)) {
                            if (file.lastModified() > latestTime) {
                                latestTime = file.lastModified()
                                latestFile = file
                            }
                        }
                    }
                }
            }

            // 只返回5秒内的截图
            if (latestFile != null && System.currentTimeMillis() - latestTime < 5000) {
                return latestFile
            }
        } catch (e: Exception) {
            Log.e(TAG, "查找截图文件失败", e)
        }

        return null
    }

    override fun onInterrupt() {
        Log.d(TAG, "服务被中断")
    }

    override fun onDestroy() {
        super.onDestroy()
        instance = null
        Log.d(TAG, "✅ 截图监听服务已停止")
    }
}
