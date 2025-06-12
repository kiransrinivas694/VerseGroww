class Verse {
  final String id;
  final String name;
  final String text;
  final String reference;
  final String mood;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Verse({
    required this.id,
    required this.name,
    required this.text,
    required this.reference,
    required this.mood,
    this.createdAt,
    this.updatedAt,
  });

  factory Verse.fromJson(Map<String, dynamic> json) {
    return Verse(
      id: json['id'],
      name: json['name'],
      text: json['text'],
      reference: json['reference'],
      mood: json['mood'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'text': text,
      'reference': reference,
      'mood': mood,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
