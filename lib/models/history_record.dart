class HistoryRecord {
  final String category;
  final int score;
  final int total;
  final int accuracy;
  final int streak;
  final String date;

  HistoryRecord({
    required this.category,
    required this.score,
    required this.total,
    required this.accuracy,
    required this.streak,
    required this.date,
  });

  factory HistoryRecord.fromJson(Map<String, dynamic> json) {
    return HistoryRecord(
      category: json['category'] as String? ?? 'General Knowledge',
      score: json['score'] as int? ?? 0,
      total: json['total'] as int? ?? 10,
      accuracy: json['accuracy'] as int? ?? 0,
      streak: json['streak'] as int? ?? 0,
      date: json['date'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'category': category,
      'score': score,
      'total': total,
      'accuracy': accuracy,
      'streak': streak,
      'date': date,
    };
  }
}
