package com.example.beecount

import android.content.Context
import android.database.ContentObserver
import android.database.Cursor
import android.net.Uri
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.MediaStore
import android.util.Log

/**
 * 截图监听器
 * 监听 MediaStore 的 Screenshots 目录变化,检测新截图
 */
class ScreenshotObserver(
    private val context: Context,
    private val onScreenshotDetected: (String) -> Unit
) : ContentObserver(Handler(Looper.getMainLooper())) {

    companion object {
        private const val TAG = "ScreenshotObserver"

        // 截图关键词
        private val SCREENSHOT_KEYWORDS = listOf(
            "screenshot",
            "截屏",
            "截图",
            "screen_shot",
            "screen shot"
        )
    }

    private var lastCheckTime = System.currentTimeMillis()
    private val processedPaths = mutableSetOf<String>()

    override fun onChange(selfChange: Boolean, uri: Uri?) {
        super.onChange(selfChange, uri)

        val startTime = System.currentTimeMillis()
        try {
            Log.d(TAG, "⏱️ [性能] onChange触发: uri=$uri, 时间=${startTime}")
            LoggerPlugin.info(TAG, "ContentObserver检测到媒体库变化: uri=$uri")

            // 直接处理变化的URI，避免查询所有图片
            if (uri != null) {
                checkImageUri(uri)
            } else {
                // 兜底方案：如果没有URI，使用旧的查询方式
                checkForNewScreenshot()
            }

            val elapsed = System.currentTimeMillis() - startTime
            Log.d(TAG, "⏱️ [性能] onChange处理完成, 耗时=${elapsed}ms")
            LoggerPlugin.debug(TAG, "ContentObserver处理完成, 耗时=${elapsed}ms")
        } catch (e: Exception) {
            Log.e(TAG, "处理媒体库变化失败", e)
            LoggerPlugin.error(TAG, "处理媒体库变化失败: ${e.message}")
        }
    }

    /**
     * 直接检查特定URI的图片（新优化方法）
     */
    private fun checkImageUri(uri: Uri) {
        val queryStartTime = System.currentTimeMillis()
        try {
            val projection = arrayOf(
                MediaStore.Images.Media._ID,
                MediaStore.Images.Media.DATA,
                MediaStore.Images.Media.DATE_ADDED,
                MediaStore.Images.Media.DISPLAY_NAME
            )

            Log.d(TAG, "⏱️ [性能] 开始查询单个URI: $uri")
            val cursor: Cursor? = context.contentResolver.query(
                uri,
                projection,
                null,
                null,
                null
            )
            val queryElapsed = System.currentTimeMillis() - queryStartTime
            Log.d(TAG, "⏱️ [性能] URI查询完成, 耗时=${queryElapsed}ms")

            val processStartTime = System.currentTimeMillis()
            cursor?.use {
                if (it.moveToFirst()) {
                    val dataIndex = it.getColumnIndex(MediaStore.Images.Media.DATA)
                    val nameIndex = it.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME)

                    if (dataIndex >= 0 && nameIndex >= 0) {
                        val imagePath = it.getString(dataIndex) ?: return
                        val imageName = it.getString(nameIndex) ?: ""

                        // 检查是否是截图
                        if (isScreenshot(imagePath, imageName) && !processedPaths.contains(imagePath)) {
                            Log.d(TAG, "✅ 检测到新截图: $imagePath")
                            Log.d(TAG, "文件名: $imageName")
                            LoggerPlugin.info(TAG, "检测到新截图: $imageName")

                            processedPaths.add(imagePath)

                            val callbackStartTime = System.currentTimeMillis()
                            onScreenshotDetected(imagePath)
                            val callbackElapsed = System.currentTimeMillis() - callbackStartTime
                            Log.d(TAG, "⏱️ [性能] 回调执行完成, 耗时=${callbackElapsed}ms")
                            LoggerPlugin.debug(TAG, "截图回调执行完成, 耗时=${callbackElapsed}ms")

                            // 限制缓存大小
                            if (processedPaths.size > 100) {
                                val toRemove = processedPaths.take(50)
                                processedPaths.removeAll(toRemove.toSet())
                            }
                        }
                    }
                }
                val processElapsed = System.currentTimeMillis() - processStartTime
                Log.d(TAG, "⏱️ [性能] 处理完成, 耗时=${processElapsed}ms")
            }
        } catch (e: Exception) {
            Log.e(TAG, "检查URI失败: $uri", e)
        }
    }

    /**
     * 检查是否有新截图（兜底方案）
     */
    private fun checkForNewScreenshot() {
        val currentTime = System.currentTimeMillis()
        val queryStartTime = System.currentTimeMillis()

        try {
            val uri = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                MediaStore.Images.Media.getContentUri(MediaStore.VOLUME_EXTERNAL)
            } else {
                MediaStore.Images.Media.EXTERNAL_CONTENT_URI
            }

            val projection = arrayOf(
                MediaStore.Images.Media._ID,
                MediaStore.Images.Media.DATA,
                MediaStore.Images.Media.DATE_ADDED,
                MediaStore.Images.Media.DISPLAY_NAME
            )

            // 查询最近 3 秒内添加的图片（缩短时间窗口）
            val selection = "${MediaStore.Images.Media.DATE_ADDED} > ?"
            val selectionArgs = arrayOf(((lastCheckTime / 1000) - 3).toString())
            val sortOrder = "${MediaStore.Images.Media.DATE_ADDED} DESC"

            Log.d(TAG, "⏱️ [性能] 开始查询MediaStore（兜底）")
            val cursor: Cursor? = context.contentResolver.query(
                uri,
                projection,
                selection,
                selectionArgs,
                sortOrder
            )
            val queryElapsed = System.currentTimeMillis() - queryStartTime
            Log.d(TAG, "⏱️ [性能] MediaStore查询完成, 耗时=${queryElapsed}ms")

            val processStartTime = System.currentTimeMillis()
            cursor?.use {
                var foundCount = 0
                while (it.moveToNext()) {
                    foundCount++
                    val dataIndex = it.getColumnIndex(MediaStore.Images.Media.DATA)
                    val nameIndex = it.getColumnIndex(MediaStore.Images.Media.DISPLAY_NAME)
                    val dateIndex = it.getColumnIndex(MediaStore.Images.Media.DATE_ADDED)

                    if (dataIndex >= 0 && nameIndex >= 0 && dateIndex >= 0) {
                        val imagePath = it.getString(dataIndex) ?: continue
                        val imageName = it.getString(nameIndex) ?: ""
                        val dateAdded = it.getLong(dateIndex)

                        // 检查是否是截图
                        if (isScreenshot(imagePath, imageName) && !processedPaths.contains(imagePath)) {
                            Log.d(TAG, "✅ 检测到新截图: $imagePath")
                            Log.d(TAG, "文件名: $imageName, 添加时间: $dateAdded")
                            LoggerPlugin.info(TAG, "检测到新截图(兜底): $imageName")

                            processedPaths.add(imagePath)

                            val callbackStartTime = System.currentTimeMillis()
                            onScreenshotDetected(imagePath)
                            val callbackElapsed = System.currentTimeMillis() - callbackStartTime
                            Log.d(TAG, "⏱️ [性能] 回调执行完成, 耗时=${callbackElapsed}ms")
                            LoggerPlugin.debug(TAG, "截图回调执行完成(兜底), 耗时=${callbackElapsed}ms")

                            // 限制缓存大小
                            if (processedPaths.size > 100) {
                                val toRemove = processedPaths.take(50)
                                processedPaths.removeAll(toRemove.toSet())
                            }
                        }
                    }
                }
                val processElapsed = System.currentTimeMillis() - processStartTime
                Log.d(TAG, "⏱️ [性能] 处理${foundCount}条记录, 耗时=${processElapsed}ms")
            }

            lastCheckTime = currentTime
        } catch (e: Exception) {
            Log.e(TAG, "检查新截图失败", e)
        }
    }

    /**
     * 判断是否是截图
     */
    private fun isScreenshot(path: String, name: String): Boolean {
        val lowerPath = path.lowercase()
        val lowerName = name.lowercase()

        // 过滤掉临时文件 (.pending- 前缀是小米系统写入中的临时文件)
        if (lowerName.startsWith(".pending-") || lowerPath.contains("/.pending-")) {
            Log.d(TAG, "⏭️ 跳过临时文件: $name")
            return false
        }

        return SCREENSHOT_KEYWORDS.any { keyword ->
            lowerPath.contains(keyword) || lowerName.contains(keyword)
        }
    }

    /**
     * 清理已处理的路径缓存
     */
    fun clear() {
        processedPaths.clear()
    }
}
