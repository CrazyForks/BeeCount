import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> WidgetEntry {
        WidgetEntry(date: Date(), widgetData: WidgetData.placeholder)
    }

    func getSnapshot(in context: Context, completion: @escaping (WidgetEntry) -> ()) {
        let entry = WidgetEntry(date: Date(), widgetData: loadWidgetData())
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        let currentDate = Date()
        let entry = WidgetEntry(date: currentDate, widgetData: loadWidgetData())

        // 每15分钟更新一次
        let nextUpdateDate = Calendar.current.date(byAdding: .minute, value: 15, to: currentDate)!
        let timeline = Timeline(entries: [entry], policy: .after(nextUpdateDate))
        completion(timeline)
    }
}

struct WidgetEntry: TimelineEntry {
    let date: Date
    let widgetData: WidgetData
}

struct BeeCountWidgetEntryView : View {
    var entry: Provider.Entry

    var body: some View {
        VStack(spacing: 8) {
            // 账本名称
            Text(entry.widgetData.ledgerName)
                .font(.caption)
                .fontWeight(.medium)
                .foregroundColor(.primary)

            // 余额显示
            VStack(spacing: 4) {
                Text("余额")
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Text(entry.widgetData.balanceText)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.primary)
            }

            // 今日支出
            HStack {
                Text("今日支出：")
                    .font(.caption2)
                    .foregroundColor(.secondary)

                Text(entry.widgetData.todayExpenseText)
                    .font(.caption2)
                    .foregroundColor(.red)
            }

            Spacer()

            // 快速记账提示
            Text("点击打开应用")
                .font(.caption2)
                .foregroundColor(.secondary)
        }
        .padding()
        .background(Color(.systemBackground))
        .containerBackground(.fill.tertiary, for: .widget)
    }
}

struct BeeCountWidget: Widget {
    let kind: String = "BeeCountWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            BeeCountWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("蜜蜂记账")
        .description("查看账本余额和今日支出")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}

struct WidgetData {
    let ledgerName: String
    let balanceText: String
    let todayExpenseText: String

    static let placeholder = WidgetData(
        ledgerName: "蜜蜂记账",
        balanceText: "¥0.00",
        todayExpenseText: "¥0.00"
    )
}

func loadWidgetData() -> WidgetData {
    let sharedDefaults = UserDefaults(suiteName: "group.com.example.beecount")

    guard let jsonData = sharedDefaults?.string(forKey: "widget_data"),
          let data = jsonData.data(using: .utf8),
          let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
        return WidgetData.placeholder
    }

    return WidgetData(
        ledgerName: json["ledgerName"] as? String ?? "蜜蜂记账",
        balanceText: json["balanceText"] as? String ?? "¥0.00",
        todayExpenseText: json["todayExpenseText"] as? String ?? "¥0.00"
    )
}

#Preview(as: .systemSmall) {
    BeeCountWidget()
} timeline: {
    WidgetEntry(date: .now, widgetData: WidgetData.placeholder)
}