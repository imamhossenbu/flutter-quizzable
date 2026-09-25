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
    final provider = Provider.of<QuizProvider>(context, listen: false);
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
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                const Spacer(flex: 1),

                // Celebration Badge
                Container(
                  width: 95,
                  height: 95,
                  decoration: BoxDecoration(
                    color: isPassed
                        ? (isDark ? const Color(0xFF1B4332) : const Color(0xFFE8F5E9))
                        : (isDark ? const Color(0xFF4A1521) : const Color(0xFFFFEBEE)),
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: (isPassed ? const Color(0xFF4CAF50) : const Color(0xFFF44336))
                            .withOpacity(0.2),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      isMaster ? '🏆' : (isPassed ? '🎉' : '💪'),
                      style: const TextStyle(fontSize: 44),
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // Heading & Personalized Name
                Text(
                  isMaster
                      ? 'Outstanding, ${provider.userName}!'
                      : (isPassed ? 'Well Done, ${provider.userName}!' : 'Good Effort, ${provider.userName}!'),
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    color: isDark ? Colors.white : const Color(0xFF2C3E50),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Quiz Completed • ${provider.selectedCategory?.cleanName ?? "Trivia"}',
                  style: GoogleFonts.nunito(
                    fontSize: 14,
                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF718096),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),

                // Score Card with Stats
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 18),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(24),
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
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF005953),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Quick Stats Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildStatItem('Accuracy', '$accuracy%', isDark),
                          Container(width: 1, height: 36, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          _buildStatItem('Total Time', timeFormatted, isDark),
                          Container(width: 1, height: 36, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                          _buildStatItem('Best Streak', '${provider.maxStreak} 🔥', isDark),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

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

                const Spacer(flex: 2),

                // "Play Again" Button
                SizedBox(
                  width: double.infinity,
                  height: 54,
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
                            fontSize: 18,
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
                const SizedBox(height: 12),

                // "Choose Another Category" Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
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
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white70 : const Color(0xFF4A5568),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
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
