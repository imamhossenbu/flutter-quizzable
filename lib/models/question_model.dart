class QuestionModel {
  final String type;
  final String difficulty;
  final String category;
  final String question;
  final String correctAnswer;
  final List<String> incorrectAnswers;
  final List<String> allAnswers;

  QuestionModel({
    required this.type,
    required this.difficulty,
    required this.category,
    required this.question,
    required this.correctAnswer,
    required this.incorrectAnswers,
    required this.allAnswers,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String? ?? 'multiple';
    final difficulty = json['difficulty'] as String? ?? 'easy';
    final category = decodeHtml(json['category'] as String? ?? '');
    final question = decodeHtml(json['question'] as String? ?? '');
    final correctAnswer = decodeHtml(json['correct_answer'] as String? ?? '');
    
    final rawIncorrect = (json['incorrect_answers'] as List<dynamic>?)
            ?.map((e) => decodeHtml(e.toString()))
            .toList() ??
        [];

    final List<String> answers = [...rawIncorrect, correctAnswer];
    if (type == 'boolean') {
      // Keep True, False in standard order or shuffled
      answers.sort((a, b) => b.compareTo(a)); // True, False
    } else {
      answers.shuffle();
    }

    return QuestionModel(
      type: type,
      difficulty: difficulty,
      category: category,
      question: question,
      correctAnswer: correctAnswer,
      incorrectAnswers: rawIncorrect,
      allAnswers: answers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'difficulty': difficulty,
      'category': category,
      'question': question,
      'correct_answer': correctAnswer,
      'incorrect_answers': incorrectAnswers,
    };
  }

  static String decodeHtml(String input) {
    return input
        .replaceAll('&quot;', '"')
        .replaceAll('&#039;', "'")
        .replaceAll('&rsquo;', "'")
        .replaceAll('&lsquo;', "'")
        .replaceAll('&rdquo;', '"')
        .replaceAll('&ldquo;', '"')
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&ntilde;', 'ñ')
        .replaceAll('&eacute;', 'é')
        .replaceAll('&uuml;', 'ü')
        .replaceAll('&oacute;', 'ó')
        .replaceAll('&deg;', '°')
        .replaceAll('&shy;', '')
        .replaceAll('&hellip;', '…')
        .replaceAll('&prime;', '′')
        .replaceAll('&minus;', '−')
        .replaceAll('&#038;', '&')
        .replaceAll('&lrm;', '')
        .replaceAll('&rlm;', '');
  }
}
