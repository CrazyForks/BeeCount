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

class BeeCountWidgetLargeProvider : AppWidgetProvider() {

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
            val views = RemoteViews(context.packageName, R.layout.beecount_widget_large)

            // 读取共享数据
            val widgetData = loadWidgetData(context)

            // 更新UI
            views.setTextViewText(R.id.ledger_name, widgetData.ledgerName)
            views.setTextViewText(R.id.balance_text, widgetData.balanceText)
            views.setTextViewText(R.id.today_expense_text, widgetData.todayExpenseText)
            views.setTextViewText(R.id.month_expense_text, widgetData.monthExpenseText)

            // 设置点击事件
            val addTransactionIntent = Intent(context, MainActivity::class.java).apply {
                action = "add_transaction"
                data = Uri.parse("beecount://add_transaction")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val addTransactionPendingIntent = PendingIntent.getActivity(
                context, 0, addTransactionIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.add_transaction_btn, addTransactionPendingIntent)

            // 查看报表按钮
            val viewReportsIntent = Intent(context, MainActivity::class.java).apply {
                action = "view_reports"
                data = Uri.parse("beecount://view_reports")
                flags = Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP
            }
            val viewReportsPendingIntent = PendingIntent.getActivity(
                context, 2, viewReportsIntent,
                PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
            )
            views.setOnClickPendingIntent(R.id.view_reports_btn, viewReportsPendingIntent)

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
                        monthExpenseText = json.optString("monthExpenseText", "¥0.00")
                    )
                }
            } catch (e: Exception) {
                e.printStackTrace()
            }

            // 默认数据
            return WidgetData(
                ledgerName = "蜜蜂记账",
                balanceText = "¥0.00",
                todayExpenseText = "¥0.00",
                monthExpenseText = "¥0.00"
            )
        }
    }

    data class WidgetData(
        val ledgerName: String,
        val balanceText: String,
        val todayExpenseText: String,
        val monthExpenseText: String
    )
}