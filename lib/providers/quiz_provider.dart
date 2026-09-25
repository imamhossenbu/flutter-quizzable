import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/category_model.dart';
import '../models/question_model.dart';
import '../models/history_record.dart';
import '../services/api_service.dart';

enum QuizStatus { initial, loading, inProgress, answered, completed, error }

class QuizAnswerRecord {
  final QuestionModel question;
  final String? selectedAnswer;
  final bool isCorrect;
  final bool isTimeout;

  QuizAnswerRecord({
    required this.question,
    required this.selectedAnswer,
    required this.isCorrect,
    this.isTimeout = false,
  });
}

class QuizProvider with ChangeNotifier {
  // Theme State (Dark / Light)
  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Configuration State
  int _amount = 10;
  String _difficulty = 'any'; // 'any', 'easy', 'medium', 'hard'
  String _type = 'multiple';   // 'multiple', 'boolean', 'any'
  int _selectedDuration = 20;  // 10s, 20s, 30s
  CategoryModel? _selectedCategory;

  // Avatar and User Name
  String _userName = '';
  String _avatar = '🎯'; // 🎯, 🚀, 🦊, ⚡, 🎓, 👑
  String get userName => _userName;
  String get avatar => _avatar;

  // Getters for configuration
  int get amount => _amount;
  String get difficulty => _difficulty;
  String get type => _type;
  int get selectedDuration => _selectedDuration;
  CategoryModel? get selectedCategory => _selectedCategory;

  // Categories & Filtering
  List<CategoryModel> _categories = [];
  bool _isLoadingCategories = false;
  String? _categoryError;
  String _categorySearchQuery = '';

  List<CategoryModel> get categories => _categories;
  bool get isLoadingCategories => _isLoadingCategories;
  String? get categoryError => _categoryError;
  String get categorySearchQuery => _categorySearchQuery;

  List<CategoryModel> get filteredCategories {
    if (_categorySearchQuery.trim().isEmpty) return _categories;
    final query = _categorySearchQuery.toLowerCase().trim();
    return _categories.where((c) {
      return c.name.toLowerCase().contains(query) ||
          c.cleanName.toLowerCase().contains(query);
    }).toList();
  }

  // Quiz Gameplay State
  List<QuestionModel> _questions = [];
  int _currentIndex = 0;
  int _score = 0;
  int _streak = 0;
  int _maxStreak = 0;
  String? _selectedAnswer;
  bool _isAnswerCorrect = false;
  QuizStatus _status = QuizStatus.initial;
  String? _errorMessage;

  // Answer review history
  final List<QuizAnswerRecord> _answerHistory = [];
  List<QuizAnswerRecord> get answerHistory => _answerHistory;

  // Past Game History & Leaderboard
  List<HistoryRecord> _history = [];
  List<HistoryRecord> get history => _history;

  // Bookmarked Questions
  List<QuestionModel> _bookmarkedQuestions = [];
  List<QuestionModel> get bookmarkedQuestions => _bookmarkedQuestions;

  // Timer per question
  int _remainingSeconds = 20;
  Timer? _timer;
  int _totalQuizTimeSeconds = 0;
  Timer? _totalTimeTimer;

  // Getters for gameplay
  List<QuestionModel> get questions => _questions;
  int get currentIndex => _currentIndex;
  int get score => _score;
  int get streak => _streak;
  int get maxStreak => _maxStreak;
  String? get selectedAnswer => _selectedAnswer;
  bool get isAnswerCorrect => _isAnswerCorrect;
  QuizStatus get status => _status;
  String? get errorMessage => _errorMessage;
  int get remainingSeconds => _remainingSeconds;
  int get totalQuizTimeSeconds => _totalQuizTimeSeconds;
  double get timerProgress => _remainingSeconds / _selectedDuration;

  QuestionModel? get currentQuestion =>
      _questions.isNotEmpty && _currentIndex < _questions.length
          ? _questions[_currentIndex]
          : null;

  double get quizProgress =>
      _questions.isEmpty ? 0.0 : (_currentIndex + 1) / _questions.length;

  int get totalQuestions => _questions.length;

  double get accuracyPercentage =>
      totalQuestions == 0 ? 0.0 : (_score / totalQuestions) * 100;

  QuizProvider() {
    loadSavedConfig();
    fetchCategories();
  }

  // --- Theme Toggle ---

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _saveConfig();
    notifyListeners();
  }

  // --- Configuration Methods ---

  void setAmount(int value) {
    _amount = value.clamp(1, 50);
    _saveConfig();
    notifyListeners();
  }

  void setDifficulty(String value) {
    _difficulty = value;
    _saveConfig();
    notifyListeners();
  }

  void setType(String value) {
    _type = value;
    _saveConfig();
    notifyListeners();
  }

  void setDuration(int seconds) {
    _selectedDuration = seconds;
    _saveConfig();
    notifyListeners();
  }

  void setSelectedCategory(CategoryModel category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setUserName(String name) {
    _userName = name.trim();
    _saveConfig();
    notifyListeners();
  }

  void setAvatar(String avatarEmoji) {
    _avatar = avatarEmoji;
    _saveConfig();
    notifyListeners();
  }

  void searchCategories(String query) {
    _categorySearchQuery = query;
    notifyListeners();
  }

  // --- Bookmark Management ---

  bool isBookmarked(QuestionModel question) {
    return _bookmarkedQuestions.any((q) => q.question == question.question);
  }

  void toggleBookmark(QuestionModel question) {
    final exists = isBookmarked(question);
    if (exists) {
      _bookmarkedQuestions.removeWhere((q) => q.question == question.question);
    } else {
      _bookmarkedQuestions.add(question);
    }
    _saveBookmarks();
    notifyListeners();
  }

  Future<void> _saveBookmarks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _bookmarkedQuestions.map((q) => q.toJson()).toList();
      await prefs.setString('quiz_bookmarks', json.encode(list));
    } catch (_) {}
  }

  // --- History Management ---

  void recordGameCompletion() {
    final now = DateTime.now();
    final dateStr = '${now.day}/${now.month}/${now.year} ${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
    
    final record = HistoryRecord(
      category: _selectedCategory?.cleanName ?? 'General Trivia',
      score: _score,
      total: totalQuestions,
      accuracy: accuracyPercentage.round(),
      streak: _maxStreak,
      date: dateStr,
    );

    _history.insert(0, record);
    if (_history.length > 20) {
      _history = _history.sublist(0, 20); // Keep last 20 games
    }
    _saveHistory();
    notifyListeners();
  }

  Future<void> _saveHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final list = _history.map((h) => h.toJson()).toList();
      await prefs.setString('quiz_history', json.encode(list));
    } catch (_) {}
  }

  void clearHistory() async {
    _history.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('quiz_history');
    notifyListeners();
  }

  // --- SharedPreferences Persistence ---

  Future<void> _saveConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('quiz_dark_mode', _isDarkMode);
      await prefs.setInt('quiz_amount', _amount);
      await prefs.setString('quiz_difficulty', _difficulty);
      await prefs.setString('quiz_type', _type);
      await prefs.setInt('quiz_duration', _selectedDuration);
      await prefs.setString('user_name', _userName);
      await prefs.setString('user_avatar', _avatar);
    } catch (_) {}
  }

  Future<void> loadSavedConfig() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isDarkMode = prefs.getBool('quiz_dark_mode') ?? false;
      _amount = prefs.getInt('quiz_amount') ?? 10;
      _difficulty = prefs.getString('quiz_difficulty') ?? 'any';
      _type = prefs.getString('quiz_type') ?? 'multiple';
      _selectedDuration = prefs.getInt('quiz_duration') ?? 20;
      _userName = prefs.getString('user_name') ?? '';
      _avatar = prefs.getString('user_avatar') ?? '🎯';

      // Load History
      final historyStr = prefs.getString('quiz_history');
      if (historyStr != null) {
        final List<dynamic> decoded = json.decode(historyStr);
        _history = decoded.map((e) => HistoryRecord.fromJson(e as Map<String, dynamic>)).toList();
      }

      // Load Bookmarks
      final bookmarkStr = prefs.getString('quiz_bookmarks');
      if (bookmarkStr != null) {
        final List<dynamic> decoded = json.decode(bookmarkStr);
        _bookmarkedQuestions = decoded.map((e) => QuestionModel.fromJson(e as Map<String, dynamic>)).toList();
      }

      notifyListeners();
    } catch (_) {}
  }

  // --- Category Fetching & Caching ---

  Future<void> fetchCategories({bool force = false}) async {
    if (_categories.isNotEmpty && !force) return;

    _isLoadingCategories = true;
    _categoryError = null;
    notifyListeners();

    try {
      _categories = await ApiService.getCategories(forceRefresh: force);
      _isLoadingCategories = false;
      notifyListeners();
    } catch (e) {
      _isLoadingCategories = false;
      _categoryError = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  // --- Quiz Lifecycle ---

  Future<void> startQuiz() async {
    _status = QuizStatus.loading;
    _errorMessage = null;
    _questions = [];
    _answerHistory.clear();
    _currentIndex = 0;
    _score = 0;
    _streak = 0;
    _maxStreak = 0;
    _selectedAnswer = null;
    _totalQuizTimeSeconds = 0;
    _stopTimer();
    _stopTotalTimer();
    notifyListeners();

    try {
      _questions = await ApiService.getQuestions(
        amount: _amount,
        categoryId: _selectedCategory?.id,
        difficulty: _difficulty,
        type: _type,
      );

      _status = QuizStatus.inProgress;
      _startTotalTimer();
      _startQuestionTimer();
      notifyListeners();
    } catch (e) {
      _status = QuizStatus.error;
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
    }
  }

  void _startTotalTimer() {
    _totalTimeTimer?.cancel();
    _totalTimeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _totalQuizTimeSeconds++;
      notifyListeners();
    });
  }

  void _stopTotalTimer() {
    _totalTimeTimer?.cancel();
    _totalTimeTimer = null;
  }

  void _startQuestionTimer() {
    _stopTimer();
    _remainingSeconds = _selectedDuration;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _handleTimeout();
      }
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _handleTimeout() {
    _stopTimer();
    _selectedAnswer = null;
    _isAnswerCorrect = false;
    _streak = 0;

    if (currentQuestion != null) {
      _answerHistory.add(
        QuizAnswerRecord(
          question: currentQuestion!,
          selectedAnswer: null,
          isCorrect: false,
          isTimeout: true,
        ),
      );
    }

    _status = QuizStatus.answered;
    notifyListeners();

    // Auto advance after 2 seconds on timeout
    Future.delayed(const Duration(seconds: 2), () {
      if (_status == QuizStatus.answered) {
        nextQuestion();
      }
    });
  }

  /// Select answer by user
  void selectAnswer(String answer) {
    if (_status != QuizStatus.inProgress || currentQuestion == null) return;

    _stopTimer();
    _selectedAnswer = answer;
    _isAnswerCorrect = (answer == currentQuestion!.correctAnswer);

    if (_isAnswerCorrect) {
      _score++;
      _streak++;
      if (_streak > _maxStreak) {
        _maxStreak = _streak;
      }
    } else {
      _streak = 0;
    }

    _answerHistory.add(
      QuizAnswerRecord(
        question: currentQuestion!,
        selectedAnswer: answer,
        isCorrect: _isAnswerCorrect,
      ),
    );

    _status = QuizStatus.answered;
    notifyListeners();
  }

  /// Move to next question or complete quiz
  void nextQuestion() {
    _stopTimer();
    if (_currentIndex < _questions.length - 1) {
      _currentIndex++;
      _selectedAnswer = null;
      _isAnswerCorrect = false;
      _status = QuizStatus.inProgress;
      _startQuestionTimer();
      notifyListeners();
    } else {
      // Completed!
      _stopTotalTimer();
      recordGameCompletion();
      _status = QuizStatus.completed;
      notifyListeners();
    }
  }

  /// Reset quiz for replay while keeping the user's chosen config intact
  void resetQuiz() {
    _stopTimer();
    _stopTotalTimer();
    _currentIndex = 0;
    _score = 0;
    _streak = 0;
    _selectedAnswer = null;
    _isAnswerCorrect = false;
    _status = QuizStatus.initial;
    _totalQuizTimeSeconds = 0;
    _errorMessage = null;
    _answerHistory.clear();
    notifyListeners();
  }

  @override
  void dispose() {
    _stopTimer();
    _stopTotalTimer();
    super.dispose();
  }
}
