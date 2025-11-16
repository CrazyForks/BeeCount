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
        // 专用截图应用包名 (不包含 com.android.systemui,太宽泛)
        private val SCREENSHOT_PACKAGE_NAMES = listOf(
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
        LoggerPlugin.info(TAG, "无障碍服务已连接并启动")
    }

    override fun onAccessibilityEvent(event: AccessibilityEvent?) {
        if (event == null) return
        if (onScreenshotDetected == null) return // 未启用截图监听

        try {
            val packageName = event.packageName?.toString() ?: return
            val className = event.className?.toString() ?: ""

            // 精确匹配截图应用包名,或类名包含 screenshot/capture
            val isScreenshotPackage = SCREENSHOT_PACKAGE_NAMES.any { packageName == it }
            val isScreenshotClass = className.contains("screenshot", ignoreCase = true) ||
                                   className.contains("capture", ignoreCase = true)

            if (isScreenshotPackage || isScreenshotClass) {
                val currentTime = System.currentTimeMillis()
                // 防止重复触发（3秒内只响应一次,避免截图动画/编辑界面重复触发）
                if (currentTime - lastScreenshotTime < 3000) {
                    return
                }
                lastScreenshotTime = currentTime

                Log.d(TAG, "🔔 检测到截图: package=$packageName, class=$className")
                LoggerPlugin.info(TAG, "检测到截图事件: package=$packageName")
                handleScreenshotDetected()
            }
        } catch (e: Exception) {
            Log.e(TAG, "❌ 处理事件失败", e)
            LoggerPlugin.error(TAG, "处理无障碍事件失败: ${e.message}")
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

    @androidx.annotation.RequiresApi(Build.VERSION_CODES.R)
    private fun takeScreenshotWithApi() {
        Log.d(TAG, "📸 使用 takeScreenshot API 直接获取屏幕")

        // 延迟200ms等待截图动画完成
        handler.postDelayed({
            takeScreenshot(
                android.view.Display.DEFAULT_DISPLAY,
                applicationContext.mainExecutor,
                object : TakeScreenshotCallback {
                    override fun onSuccess(screenshotResult: ScreenshotResult) {
                        try {
                            val bitmap = Bitmap.wrapHardwareBuffer(
                                screenshotResult.hardwareBuffer,
                                screenshotResult.colorSpace
                            )

                            if (bitmap != null) {
                                // 保存到临时文件
                                val tempFile = File(applicationContext.cacheDir, "screenshot_${System.currentTimeMillis()}.png")
                                FileOutputStream(tempFile).use { out ->
                                    bitmap.compress(Bitmap.CompressFormat.PNG, 100, out)
                                }

                                Log.d(TAG, "✅ 截图保存成功: ${tempFile.absolutePath}")
                                LoggerPlugin.info(TAG, "使用API截图成功，保存到临时文件")
                                onScreenshotDetected?.invoke(tempFile.absolutePath)

                                bitmap.recycle()
                            } else {
                                Log.e(TAG, "❌ 无法创建 Bitmap,降级到文件等待")
                                LoggerPlugin.warning(TAG, "无法创建Bitmap，降级到文件等待模式")
                                waitForScreenshotFile()
                            }

                            screenshotResult.hardwareBuffer.close()
                        } catch (e: Exception) {
                            Log.e(TAG, "❌ 处理截图失败: $e,降级到文件等待")
                            waitForScreenshotFile()
                        }
                    }

                    override fun onFailure(errorCode: Int) {
                        Log.w(TAG, "⚠️ takeScreenshot 失败 (errorCode=$errorCode),降级到文件等待")
                        LoggerPlugin.warning(TAG, "takeScreenshot API失败(errorCode=$errorCode)，降级到文件等待")
                        waitForScreenshotFile()
                    }
                }
            )
        }, 200)
    }

    private fun waitForScreenshotFile() {
        // 延迟等待文件写入（通常截图后1-2秒文件才可用）
        pendingScreenshotCheck = Runnable {
            // 查找最新的截图文件
            val screenshotFile = findLatestScreenshot()
            if (screenshotFile != null) {
                Log.d(TAG, "✅ 找到最新截图: ${screenshotFile.absolutePath}")
                LoggerPlugin.info(TAG, "找到最新截图文件: ${screenshotFile.name}")
                onScreenshotDetected?.invoke(screenshotFile.absolutePath)
            } else {
                // 不通知,避免Flutter端弹出"截图文件不可用"
                Log.w(TAG, "⚠️ 未找到截图文件,跳过")
                LoggerPlugin.warning(TAG, "未找到最新截图文件")
            }
            pendingScreenshotCheck = null
        }
        // 等待1.5秒让文件写入
        handler.postDelayed(pendingScreenshotCheck!!, 1500)
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
