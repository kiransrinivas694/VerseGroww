import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), verseName: "Loading...", verseText: "Please open the app to load today's verse", verseReference: "", lastUpdated: nil)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let userDefaults = UserDefaults(suiteName: "group.com.vrmg.versegroww")
        let verseName = userDefaults?.string(forKey: "verse_name") ?? "Loading..."
        let verseText = userDefaults?.string(forKey: "verse_text") ?? "Please open the app to load today's verse"
        let verseReference = userDefaults?.string(forKey: "verse_reference") ?? ""
        let lastUpdatedStr = userDefaults?.string(forKey: "last_updated")
        
        let dateFormatter = ISO8601DateFormatter()
        let lastUpdated = lastUpdatedStr.flatMap { dateFormatter.date(from: $0) }
        
        let entry = SimpleEntry(
            date: Date(),
            verseName: verseName,
            verseText: verseText,
            verseReference: verseReference,
            lastUpdated: lastUpdated
        )
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { entry in
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let verseName: String
    let verseText: String
    let verseReference: String
    let lastUpdated: Date?
}

struct VerseWidgetEntryView : View {
    var entry: Provider.Entry
    @Environment(\.widgetFamily) var family
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(entry.verseName)
                .font(.system(size: 16, weight: .bold))
                .lineLimit(1)
            
            Text(entry.verseText)
                .font(.system(size: 14))
                .lineLimit(family == .systemSmall ? 3 : 6)
                .padding(.vertical, 2)
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 2) {
                if !entry.verseReference.isEmpty {
                    Text(entry.verseReference)
                        .font(.system(size: 12))
                        .italic()
                        .lineLimit(1)
                }
                
                if let lastUpdated = entry.lastUpdated {
                    Text("Updated: \(lastUpdated, formatter: dateFormatter)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding()
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d, yyyy"
        return formatter
    }
}

@main
struct VerseWidget: Widget {
    let kind: String = "VerseWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            VerseWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Daily Verse")
        .description("Shows today's verse from VerseGroww")
        .supportedFamilies([.systemSmall, .systemMedium])
    }
} 