package com.example.beecount

import android.app.PendingIntent
import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.Intent
import android.content.SharedPreferences
import android.net.Uri
import android.widget.RemoteViews
import org.json.JSONObject

class BeeCountWidgetSmallProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // 更新所有小组件实例
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onEnabled(context: Context) {
        // 第一个小组件被创建时调用
    }

    override fun onDisabled(context: Context) {
        // 最后一个小组件被删除时调用
    }

    companion object {
        fun updateAppWidget(
            context: Context,
            appWidgetManager: AppWidgetManager,
            appWidgetId: Int
        ) {
            // 创建RemoteViews
            val views = RemoteViews(context.packageName, R.layout.beecount_widget_small)

            // 读取共享数据
            val widgetData = loadWidgetData(context)

            // 更新UI
            views.setTextViewText(R.id.ledger_name, widgetData.ledgerName)
            views.setTextViewText(R.id.balance_text, widgetData.balanceText)
            views.setTextViewText(R.id.today_expense_text, widgetData.todayExpenseText)
            views.setTextViewText(R.id.balance_label, widgetData.balanceLabel)
            views.setTextViewText(R.id.today_label, "${widgetData.todayLabel}:")

            // 应用主题色
            views.setInt(R.id.widget_background, "setBackgroundColor", android.graphics.Color.parseColor(widgetData.backgroundColor))
            views.setTextColor(R.id.ledger_name, android.graphics.Color.parseColor(widgetData.textColor))
            views.setTextColor(R.id.balance_text, android.graphics.Color.parseColor(widgetData.primaryColor))
            views.setTextColor(R.id.balance_label, android.graphics.Color.parseColor(widgetData.textColor))
            views.setTextColor(R.id.today_label, android.graphics.Color.parseColor(widgetData.textColor))

            // 设置图标
            views.setImageViewResource(R.id.ledger_icon, getIconResource(widgetData.ledgerIcon))
            views.setInt(R.id.ledger_icon, "setColorFilter", android.graphics.Color.parseColor(widgetData.primaryColor))

            // 整个小组件点击打开应用
            val openAppIntent = Intent(context, MainActivity::class.java).apply {
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val openAppPendingIntent = PendingIntent.getActivity(
                context, 1, openAppIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.ledger_name, openAppPendingIntent)

            // 更新小组件
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

        private fun loadWidgetData(context: Context): WidgetData {
            try {
                val prefs: SharedPreferences = context.getSharedPreferences(
                    "FlutterSharedPreferences", Context.MODE_PRIVATE
                )
                val jsonData = prefs.getString("flutter.widget_data", null)

                if (jsonData != null) {
                    val json = JSONObject(jsonData)
                    return WidgetData(
                        ledgerName = json.optString("ledgerName", "蜜蜂记账"),
                        balanceText = json.optString("balanceText", "¥0.00"),
                        todayExpenseText = json.optString("todayExpenseText", "¥0.00"),
                        balanceLabel = json.optString("balanceLabel", "余额"),
                        todayLabel = json.optString("todayLabel", "今日支出"),
                        primaryColor = json.optString("primaryColor", "#2E7D32"),
                        backgroundColor = json.optString("backgroundColor", "#FFFFFF"),
                        textColor = json.optString("textColor", "#333333"),
                        ledgerIcon = json.optString("ledgerIcon", "account_balance_wallet")
                    )
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

            // 默认数据
            return WidgetData(
                ledgerName = "蜜蜂记账",
                balanceText = "¥0.00",
                todayExpenseText = "¥0.00"
            )
        }

        private fun getIconResource(iconName: String): Int {
            return when (iconName) {
                "work" -> android.R.drawable.ic_menu_manage
                "trending_up" -> android.R.drawable.ic_menu_sort_by_size
                "home" -> android.R.drawable.ic_menu_preferences
                "flight" -> android.R.drawable.ic_menu_send
                "school" -> android.R.drawable.ic_menu_info_details
                "shopping_cart" -> android.R.drawable.ic_menu_add
                else -> android.R.drawable.ic_menu_agenda
            }
        }
    }

    data class WidgetData(
        val ledgerName: String,
        val balanceText: String,
        val todayExpenseText: String,
        val balanceLabel: String = "余额",
        val todayLabel: String = "今日支出",
        val primaryColor: String = "#2E7D32",
        val backgroundColor: String = "#FFFFFF",
        val textColor: String = "#333333",
        val ledgerIcon: String = "account_balance_wallet"
    )
}