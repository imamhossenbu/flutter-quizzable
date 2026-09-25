import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'category_selection_screen.dart';
import 'quiz_screen.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final isDark = provider.isDarkMode;
    final score = provider.score;
    final total = provider.totalQuestions;
    final accuracy = provider.accuracyPercentage.round();
    final timeSeconds = provider.totalQuizTimeSeconds;
    final minutes = timeSeconds ~/ 60;
    final seconds = timeSeconds % 60;
    final timeFormatted = '${minutes}m ${seconds}s';

    final isMaster = accuracy >= 80;
    final isPassed = accuracy >= 50;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _returnHome(context, provider);
        }
      },
      child: Scaffold(
        backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : const Color(0xFF2C3E50), size: 20),
            tooltip: 'Back to Categories',
            onPressed: () => _returnHome(context, provider),
          ),
          title: Text(
            'Quiz Results',
            style: GoogleFonts.nunito(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isDark ? Colors.white : const Color(0xFF2C3E50),
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                size: 22,
              ),
              tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
              onPressed: () => provider.toggleDarkMode(),
              color: isDark ? const Color(0xFFFFD54F) : const Color(0xFF2C3E50),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
            child: Column(
              children: [
                const SizedBox(height: 6),

                // Celebration Badge
                Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: isPassed
                        ? (isDark ? const Color(0xFF1B4332) : const Color(0xFFE8F5E9))
                        : (isDark ? const Color(0xFF4A1521) : const Color(0xFFFFEBEE)),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isPassed ? const Color(0xFF4CAF50) : const Color(0xFFF44336))
                            .withOpacity(0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isMaster ? '🏆' : (isPassed ? '🎉' : '💪'),
                      style: const TextStyle(fontSize: 40),
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Heading & Personalized Name
                Text(
                  isMaster
                      ? 'Outstanding, ${provider.userName}!'
                      : (isPassed ? 'Well Done, ${provider.userName}!' : 'Good Effort, ${provider.userName}!'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quiz Completed • ${provider.selectedCategory?.cleanName ?? "Trivia"}',
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF718096),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),

                // Score Card with Stats
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFEDF2F7),
                      width: 1.5,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'You scored $score/$total!',
                        style: GoogleFonts.nunito(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF005953),
                        ),
                      ),
                      const SizedBox(height: 14),

                      // Quick Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Accuracy', '$accuracy%', isDark),
                          Container(width: 1, height: 34, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          _buildStatItem('Total Time', timeFormatted, isDark),
                          Container(width: 1, height: 34, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          _buildStatItem('Best Streak', '${provider.maxStreak} 🔥', isDark),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Performance Feedback Banner (> 50% vs < 50%)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: isPassed
                        ? (isDark ? const Color(0xFF064E3B).withOpacity(0.4) : const Color(0xFFE8F5E9))
                        : (isDark ? const Color(0xFF7F1D1D).withOpacity(0.35) : const Color(0xFFFFEBEE)),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: isPassed
                          ? (isDark ? const Color(0xFF059669) : const Color(0xFF4CAF50))
                          : (isDark ? const Color(0xFFDC2626) : const Color(0xFFEF5350)),
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isPassed
                              ? (isDark ? const Color(0xFF065F46) : const Color(0xFFC8E6C9))
                              : (isDark ? const Color(0xFF991B1B) : const Color(0xFFFFCDD2)),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isPassed ? Icons.check_circle_rounded : Icons.info_outline_rounded,
                          color: isPassed
                              ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF1B5E20))
                              : (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB71C1C)),
                          size: 22,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              isPassed ? 'Congratulations! You Passed! 🎉' : 'Keep Trying! Need Practice 💪',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.w900,
                                color: isPassed
                                    ? (isDark ? const Color(0xFF6EE7B7) : const Color(0xFF1B5E20))
                                    : (isDark ? const Color(0xFFFCA5A5) : const Color(0xFFB71C1C)),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isPassed
                                  ? 'Awesome job! You scored $accuracy% (above 50%). You demonstrated strong knowledge in this category!'
                                  : 'You scored $accuracy% (below 50%). Don\'t be discouraged! Review the correct answers below and try again to improve your score!',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: isPassed
                                    ? (isDark ? const Color(0xFFA7F3D0) : const Color(0xFF2E7D32))
                                    : (isDark ? const Color(0xFFFECACA) : const Color(0xFFC62828)),
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Actions Row: Review Answers + Share Result
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () => _showReviewAnswers(context, provider),
                      icon: Icon(Icons.playlist_add_check_rounded, color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF005953)),
                      label: Text(
                        'Review Answers',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF005953),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    TextButton.icon(
                      onPressed: () => _shareResult(context, provider, score, total, accuracy),
                      icon: const Icon(Icons.share_rounded, color: Color(0xFF0091EA)),
                      label: Text(
                        'Share Score',
                        style: GoogleFonts.nunito(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF0091EA),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // "Play Again" Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: () => _handlePlayAgain(context, provider),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF005953),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Play Again',
                          style: GoogleFonts.nunito(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.refresh_rounded, size: 20),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 10),

                // "Choose Another Category" Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: OutlinedButton(
                    onPressed: () => _returnHome(context, provider),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E0)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Choose Category',
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : const Color(0xFF4A5568),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, bool isDark) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.nunito(
            fontSize: 17,
            fontWeight: FontWeight.w900,
            color: isDark ? Colors.white : const Color(0xFF2D3748),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: GoogleFonts.nunito(
            fontSize: 12,
            color: const Color(0xFF718096),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  void _shareResult(BuildContext context, QuizProvider provider, int score, int total, int accuracy) {
    final shareText = '🎯 Quizzical Trivia Challenge!\n'
        'Player: ${provider.userName} ${provider.avatar}\n'
        'Category: ${provider.selectedCategory?.cleanName ?? "Trivia"}\n'
        'Score: $score/$total ($accuracy%)\n'
        'Best Streak: ${provider.maxStreak} 🔥\n'
        'Can you beat my score?';

    Clipboard.setData(ClipboardData(text: shareText));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Score Card copied to clipboard! Ready to share 🚀',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF005953),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showReviewAnswers(BuildContext context, QuizProvider provider) {
    final isDark = provider.isDarkMode;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFCBD5E0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Answer Review',
                    style: GoogleFonts.nunito(
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF2C3E50),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close, color: isDark ? Colors.white : Colors.black),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(),
                  itemCount: provider.answerHistory.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final item = provider.answerHistory[index];
                    final isCorrect = item.isCorrect;
                    final isTimeout = item.isTimeout;

                    return Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: isCorrect
                            ? (isDark ? const Color(0xFF1B4332) : const Color(0xFFE8F5E9))
                            : (isTimeout
                                ? (isDark ? const Color(0xFF3E2723) : const Color(0xFFFFF3E0))
                                : (isDark ? const Color(0xFF4A1521) : const Color(0xFFFFEBEE))),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isCorrect
                              ? const Color(0xFFA5D6A7)
                              : (isTimeout ? const Color(0xFFFFCC80) : const Color(0xFFFFCDD2)),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${index + 1}. ',
                                style: GoogleFonts.nunito(
                                  fontWeight: FontWeight.w900,
                                  color: isDark ? Colors.white : Colors.black,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  item.question.question,
                                  style: GoogleFonts.nunito(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 14,
                                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                                  ),
                                ),
                              ),
                              Icon(
                                isCorrect
                                    ? Icons.check_circle
                                    : (isTimeout ? Icons.timer_off : Icons.cancel),
                                size: 20,
                                color: isCorrect
                                    ? const Color(0xFF2E7D32)
                                    : (isTimeout ? const Color(0xFFEF6C00) : const Color(0xFFC62828)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (!isCorrect && !isTimeout)
                            Text(
                              'Your answer: ${item.selectedAnswer ?? "None"}',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: isDark ? const Color(0xFFFF8A80) : const Color(0xFFC62828),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          if (isTimeout)
                            Text(
                              'Timed out',
                              style: GoogleFonts.nunito(
                                fontSize: 13,
                                color: isDark ? const Color(0xFFFFB74D) : const Color(0xFFEF6C00),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          Text(
                            'Correct answer: ${item.question.correctAnswer}',
                            style: GoogleFonts.nunito(
                              fontSize: 13,
                              color: isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32),
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handlePlayAgain(BuildContext context, QuizProvider provider) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator(color: Color(0xFF005953))),
    );

    await provider.startQuiz();

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (!context.mounted) return;

    if (provider.status == QuizStatus.inProgress) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const QuizScreen()),
      );
    } else {
      _returnHome(context, provider);
    }
  }

  void _returnHome(BuildContext context, QuizProvider provider) {
    provider.resetQuiz();
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const CategorySelectionScreen()),
      (route) => route.isFirst,
    );
  }
}
