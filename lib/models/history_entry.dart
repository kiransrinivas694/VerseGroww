class HistoryEntry {
  final String verseNumber;
  final String verseText;
  final String mood;
  final String journalEntry;
  final DateTime date;

  const HistoryEntry({
    required this.verseNumber,
    required this.verseText,
    required this.mood,
    required this.journalEntry,
    required this.date,
  });
}
