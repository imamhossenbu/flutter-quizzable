import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/quiz_provider.dart';
import '../widgets/config_illustration.dart';
import 'quiz_screen.dart';

class QuizConfigScreen extends StatelessWidget {
  final CategoryModel category;

  const QuizConfigScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final isDark = provider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : const Color(0xFF2C3E50), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Illustration
              const Center(
                child: ConfigIllustration(size: 130),
              ),
              const SizedBox(height: 10),

              // Title "Quizzical"
              Text(
                'Quizzical',
                style: GoogleFonts.nunito(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                  color: isDark ? Colors.white : const Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 2),

              // "Configuration"
              Text(
                'Configuration',
                style: GoogleFonts.nunito(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF718096),
                ),
              ),
              const SizedBox(height: 6),

              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E3A37) : const Color(0xFFE0F2F1),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF005953).withOpacity(0.5), width: 1),
                ),
                child: Text(
                  category.name,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.nunito(
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                    color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF005953),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // 1. Number of Questions
              _buildSectionCard(
                context: context,
                title: 'Number of Questions',
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Select: 1–50 questions',
                          style: GoogleFonts.nunito(
                            fontSize: 13,
                            color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF718096),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0091EA).withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${provider.amount}',
                            style: GoogleFonts.nunito(
                              fontSize: 16,
                              fontWeight: FontWeight.w900,
                              color: const Color(0xFF0091EA),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: const Color(0xFF0091EA),
                        inactiveTrackColor: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        thumbColor: const Color(0xFF0091EA),
                        overlayColor: const Color(0xFF0091EA).withOpacity(0.15),
                        trackHeight: 4,
                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                      ),
                      child: Slider(
                        value: provider.amount.toDouble(),
                        min: 1,
                        max: 50,
                        divisions: 49,
                        onChanged: (val) => provider.setAmount(val.round()),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [5, 10, 15, 20, 25].map((preset) {
                        final isSelected = (provider.amount == preset);
                        return GestureDetector(
                          onTap: () => provider.setAmount(preset),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF0091EA)
                                  : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9)),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '$preset',
                              style: GoogleFonts.nunito(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: isSelected
                                    ? Colors.white
                                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B)),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 2. Question Timer Preference (Feature 6: 10s, 20s, 30s)
              _buildSectionCard(
                context: context,
                title: 'Question Timer',
                child: Row(
                  children: [
                    _buildTimerChip(
                      label: 'Speed Run',
                      seconds: 10,
                      icon: '⚡',
                      provider: provider,
                      context: context,
                    ),
                    const SizedBox(width: 8),
                    _buildTimerChip(
                      label: 'Standard',
                      seconds: 20,
                      icon: '⏱️',
                      provider: provider,
                      context: context,
                    ),
                    const SizedBox(width: 8),
                    _buildTimerChip(
                      label: 'Relaxed',
                      seconds: 30,
                      icon: '🧘',
                      provider: provider,
                      context: context,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 3. Difficulty Level
              _buildSectionCard(
                context: context,
                title: 'Difficulty Level',
                child: Row(
                  children: [
                    _buildDifficultyChip(
                      label: 'Any',
                      value: 'any',
                      icon: '🌟',
                      color: const Color(0xFF5C6BC0),
                      provider: provider,
                      context: context,
                    ),
                    const SizedBox(width: 8),
                    _buildDifficultyChip(
                      label: 'Easy',
                      value: 'easy',
                      icon: '🟢',
                      color: const Color(0xFF43A047),
                      provider: provider,
                      context: context,
                    ),
                    const SizedBox(width: 8),
                    _buildDifficultyChip(
                      label: 'Medium',
                      value: 'medium',
                      icon: '🟡',
                      color: const Color(0xFFFB8C00),
                      provider: provider,
                      context: context,
                    ),
                    const SizedBox(width: 8),
                    _buildDifficultyChip(
                      label: 'Hard',
                      value: 'hard',
                      icon: '🔴',
                      color: const Color(0xFFE53935),
                      provider: provider,
                      context: context,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // 4. Question Type
              _buildSectionCard(
                context: context,
                title: 'Question Type',
                child: Row(
                  children: [
                    _buildTypeCard(
                      label: 'Multiple Choice',
                      value: 'multiple',
                      icon: Icons.list_alt_rounded,
                      provider: provider,
                      context: context,
                    ),
                    const SizedBox(width: 10),
                    _buildTypeCard(
                      label: 'True / False',
                      value: 'boolean',
                      icon: Icons.check_circle_outline_rounded,
                      provider: provider,
                      context: context,
                    ),
                    const SizedBox(width: 10),
                    _buildTypeCard(
                      label: 'Any',
                      value: 'any',
                      icon: Icons.shuffle_rounded,
                      provider: provider,
                      context: context,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // "START" CTA Button
              SizedBox(
                width: double.infinity,
                height: 54,
                child: OutlinedButton(
                  onPressed: () => _handleStartQuiz(context, provider),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF005953), width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18),
                    ),
                    backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'START QUIZ',
                        style: GoogleFonts.nunito(
                          fontSize: 17,
                          fontWeight: FontWeight.w900,
                          color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF005953),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.play_arrow_rounded, color: isDark ? const Color(0xFF80CBC4) : const Color(0xFF005953), size: 24),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({required BuildContext context, required String title, required Widget child}) {
    final isDark = Provider.of<QuizProvider>(context).isDarkMode;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.nunito(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: isDark ? Colors.white : const Color(0xFF2D3748),
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _buildTimerChip({
    required BuildContext context,
    required String label,
    required int seconds,
    required String icon,
    required QuizProvider provider,
  }) {
    final isSelected = (provider.selectedDuration == seconds);
    final isDark = provider.isDarkMode;
    const activeColor = Color(0xFF0091EA);

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setDuration(seconds),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withOpacity(0.12)
                : (isDark ? const Color(0xFF0F172A) : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? activeColor : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                '${seconds}s',
                style: GoogleFonts.nunito(
                  fontSize: 13,
                  fontWeight: FontWeight.w900,
                  color: isSelected ? activeColor : (isDark ? Colors.white : const Color(0xFF1E293B)),
                ),
              ),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyChip({
    required BuildContext context,
    required String label,
    required String value,
    required String icon,
    required Color color,
    required QuizProvider provider,
  }) {
    final isSelected = (provider.difficulty.toLowerCase() == value.toLowerCase());
    final isDark = provider.isDarkMode;

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setDifficulty(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? color.withOpacity(0.12)
                : (isDark ? const Color(0xFF0F172A) : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? color : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Text(icon, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.nunito(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? color : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF4A5568)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeCard({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required QuizProvider provider,
  }) {
    final isSelected = (provider.type.toLowerCase() == value.toLowerCase());
    final isDark = provider.isDarkMode;
    const activeColor = Color(0xFF005953);

    return Expanded(
      child: GestureDetector(
        onTap: () => provider.setType(value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            color: isSelected
                ? activeColor.withOpacity(0.12)
                : (isDark ? const Color(0xFF0F172A) : Colors.white),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? activeColor : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 22,
                color: isSelected ? activeColor : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF718096)),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: isSelected ? activeColor : (isDark ? Colors.white70 : const Color(0xFF4A5568)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleStartQuiz(BuildContext context, QuizProvider provider) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: provider.isDarkMode ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircularProgressIndicator(color: Color(0xFF005953)),
              const SizedBox(height: 16),
              Text(
                'Fetching Trivia Questions...',
                style: GoogleFonts.nunito(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: provider.isDarkMode ? Colors.white : const Color(0xFF2C3E50),
                ),
              ),
            ],
          ),
        ),
      ),
    );

    await provider.startQuiz();

    if (context.mounted) {
      Navigator.pop(context);
    }

    if (!context.mounted) return;

    if (provider.status == QuizStatus.inProgress) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const QuizScreen()),
      );
    } else if (provider.status == QuizStatus.error) {
      _showErrorDialog(context, provider);
    }
  }

  void _showErrorDialog(BuildContext context, QuizProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Colors.orange),
            const SizedBox(width: 8),
            Text('Notice', style: GoogleFonts.nunito(fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          provider.errorMessage ?? 'Could not fetch questions. Please check your settings.',
          style: GoogleFonts.nunito(fontSize: 14),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF005953),
              foregroundColor: Colors.white,
            ),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
