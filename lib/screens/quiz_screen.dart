import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import 'results_screen.dart';

class QuizScreen extends StatelessWidget {
  const QuizScreen({super.key});

  static const List<String> _optionLabels = ['A', 'B', 'C', 'D'];

  @override
  Widget build(BuildContext context) {
    return Consumer<QuizProvider>(
      builder: (context, provider, child) {
        if (provider.status == QuizStatus.completed) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const ResultsScreen()),
            );
          });
        }

        final currentQuestion = provider.currentQuestion;
        if (currentQuestion == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final currentNum = provider.currentIndex + 1;
        final totalNum = provider.totalQuestions;
        final isDark = provider.isDarkMode;
        final isSaved = provider.isBookmarked(currentQuestion);

        return PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) {
            if (!didPop) {
              _showExitConfirmation(context, provider);
            }
          },
          child: Scaffold(
            backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF6F8FA),
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : const Color(0xFF2C3E50), size: 20),
                tooltip: 'Quit Quiz',
                onPressed: () => _showExitConfirmation(context, provider),
              ),
              title: Text(
                '${provider.selectedCategory?.cleanName ?? "Quiz"} ($currentNum/$totalNum)',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF2C3E50),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              centerTitle: true,
              actions: [
                IconButton(
                  icon: Icon(
                    isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                    size: 20,
                  ),
                  tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                  onPressed: () => provider.toggleDarkMode(),
                  color: isDark ? const Color(0xFFFFD54F) : const Color(0xFF2C3E50),
                ),
                TextButton.icon(
                  onPressed: () => _showExitConfirmation(context, provider),
                  icon: Icon(Icons.exit_to_app, color: isDark ? Colors.white70 : const Color(0xFF2C3E50), size: 20),
                  label: Text(
                    'EXIT',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: isDark ? Colors.white70 : const Color(0xFF2C3E50),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              bottom: PreferredSize(
                preferredSize: const Size.fromHeight(6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: provider.quizProgress,
                      backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF005953)),
                      minHeight: 6,
                    ),
                  ),
                ),
              ),
            ),
            body: SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Header: Timer + Streak + Score
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Timer Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: provider.remainingSeconds <= 5
                                      ? const Color(0xFFFFEBEE)
                                      : (isDark ? const Color(0xFF1E293B) : Colors.white),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: provider.remainingSeconds <= 5
                                        ? const Color(0xFFE53935)
                                        : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.timer_outlined,
                                      size: 16,
                                      color: provider.remainingSeconds <= 5
                                          ? const Color(0xFFE53935)
                                          : (isDark ? Colors.white70 : const Color(0xFF718096)),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${provider.remainingSeconds}s',
                                      style: GoogleFonts.nunito(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w800,
                                        color: provider.remainingSeconds <= 5
                                            ? const Color(0xFFE53935)
                                            : (isDark ? Colors.white : const Color(0xFF718096)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Streak Badge (🔥)
                              if (provider.streak >= 2)
                                AnimatedContainer(
                                  duration: const Duration(milliseconds: 300),
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF3E0),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: const Color(0xFFFFB74D)),
                                  ),
                                  child: Row(
                                    children: [
                                      const Text('🔥', style: TextStyle(fontSize: 14)),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${provider.streak} streak!',
                                        style: GoogleFonts.nunito(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xFFE65100),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                              // Current Score Pill
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                decoration: BoxDecoration(
                                  color: isDark ? const Color(0xFF1E3A37) : const Color(0xFFE0F2F1),
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  'Score: ${provider.score}',
                                  style: GoogleFonts.nunito(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF005953),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),

                          // Compact Adaptive Question Card with Bookmark action
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                            decoration: BoxDecoration(
                              color: isDark ? const Color(0xFF1E293B) : Colors.white,
                              borderRadius: BorderRadius.circular(22),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.04),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Text(
                                        currentQuestion.category.toUpperCase(),
                                        style: GoogleFonts.nunito(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                                          letterSpacing: 0.5,
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Spacer(),
                                    // Bookmark Toggle Icon
                                    IconButton(
                                      icon: Icon(
                                        isSaved ? Icons.bookmark : Icons.bookmark_border,
                                        size: 20,
                                        color: isSaved ? const Color(0xFF0091EA) : const Color(0xFF94A3B8),
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints: const BoxConstraints(),
                                      tooltip: isSaved ? 'Bookmarked' : 'Bookmark Question',
                                      onPressed: () {
                                        provider.toggleBookmark(currentQuestion);
                                        ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              isSaved ? 'Question removed from bookmarks' : 'Question bookmarked! 🔖',
                                              style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                                            ),
                                            duration: const Duration(seconds: 1),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  currentQuestion.question,
                                  style: GoogleFonts.nunito(
                                    fontSize: 17,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF1E293B),
                                    height: 1.35,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Answers List
                          ...List.generate(currentQuestion.allAnswers.length, (index) {
                            final answer = currentQuestion.allAnswers[index];
                            final optionPrefix = index < _optionLabels.length ? _optionLabels[index] : '${index + 1}';
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: _buildAnswerCard(
                                context,
                                answer,
                                optionPrefix,
                                currentQuestion.correctAnswer,
                                provider,
                                isDark,
                              ),
                            );
                          }),
                          const SizedBox(height: 8),
                        ],
                      ),
                    ),
                  ),

                  // Bottom Sticky "Next" Button
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, -3),
                        ),
                      ],
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: ElevatedButton(
                        onPressed: provider.status == QuizStatus.answered
                            ? () => provider.nextQuestion()
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF005953),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFB0BEC5),
                          disabledForegroundColor: Colors.white70,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(27),
                          ),
                        ),
                        child: Text(
                          currentNum == totalNum ? 'View Results 🎉' : 'Next',
                          style: GoogleFonts.nunito(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnswerCard(
    BuildContext context,
    String answer,
    String prefix,
    String correctAnswer,
    QuizProvider provider,
    bool isDark,
  ) {
    final isAnswered = (provider.status == QuizStatus.answered);
    final isSelected = (provider.selectedAnswer == answer);
    final isCorrect = (answer == correctAnswer);

    Color cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    Color borderColor = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
    Color prefixBg = isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9);
    Color prefixColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);

    Widget trailingIcon = Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFFCBD5E0), width: 1.5),
      ),
    );

    if (isAnswered) {
      if (isCorrect) {
        cardBg = isDark ? const Color(0xFF1B4332) : const Color(0xFFA7D7C5);
        borderColor = const Color(0xFF005953);
        prefixBg = const Color(0xFF005953);
        prefixColor = Colors.white;
        trailingIcon = const Icon(
          Icons.check_circle,
          color: Color(0xFF005953),
          size: 24,
        );
      } else if (isSelected && !isCorrect) {
        cardBg = isDark ? const Color(0xFF4A1521) : const Color(0xFFFFCDD2);
        borderColor = const Color(0xFFD32F2F);
        prefixBg = const Color(0xFFD32F2F);
        prefixColor = Colors.white;
        trailingIcon = const Icon(
          Icons.cancel,
          color: Color(0xFFD32F2F),
          size: 24,
        );
      }
    } else if (isSelected) {
      cardBg = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);
      borderColor = const Color(0xFF94A3B8);
    }

    return Material(
      color: cardBg,
      borderRadius: BorderRadius.circular(18),
      elevation: 0.5,
      shadowColor: Colors.black.withOpacity(0.04),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: isAnswered ? null : () => provider.selectAnswer(answer),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: borderColor,
              width: 1.5,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: prefixBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  prefix,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w900,
                    color: prefixColor,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  answer,
                  style: GoogleFonts.nunito(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : const Color(0xFF2D3748),
                    height: 1.25,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              trailingIcon,
            ],
          ),
        ),
      ),
    );
  }

  void _showExitConfirmation(BuildContext context, QuizProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          'Exit Quiz?',
          style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Your progress will be lost. Are you sure you want to exit?',
          style: GoogleFonts.nunito(fontSize: 14),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              provider.resetQuiz();
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
            ),
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }
}
