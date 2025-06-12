class HistoryEntry {
  final String id;
  final String verseNumber;
  final String verseText;
  final String reference;
  final String mood;
  final String journalEntry;
  final DateTime date;

  HistoryEntry({
    required this.id,
    required this.verseNumber,
    required this.verseText,
    required this.reference,
    required this.mood,
    required this.journalEntry,
    required this.date,
  });

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    final verse = json['verses'] as Map<String, dynamic>;
    return HistoryEntry(
      id: json['id'] as String,
      verseNumber: verse['name'] as String,
      verseText: verse['text'] as String,
      reference: verse['reference'] as String,
      mood: json['mood'] as String,
      journalEntry: json['journal_entry'] as String? ?? '',
      date: DateTime.parse(json['viewed_at'] as String),
    );
  }

  HistoryEntry copyWith({
    String? id,
    String? verseNumber,
    String? verseText,
    String? reference,
    String? mood,
    String? journalEntry,
    DateTime? date,
  }) {
    return HistoryEntry(
      id: id ?? this.id,
      verseNumber: verseNumber ?? this.verseNumber,
      verseText: verseText ?? this.verseText,
      reference: reference ?? this.reference,
      mood: mood ?? this.mood,
      journalEntry: journalEntry ?? this.journalEntry,
      date: date ?? this.date,
    );
  }
}
