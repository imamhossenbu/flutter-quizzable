import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/quiz_provider.dart';
import '../widgets/welcome_illustration.dart';
import '../widgets/history_bottom_sheet.dart';
import '../widgets/bookmarks_bottom_sheet.dart';
import 'category_selection_screen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  late TextEditingController _nameController;
  final List<String> _avatars = ['🎯', '🚀', '🦊', '⚡', '🎓', '👑'];

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<QuizProvider>(context, listen: false);
    _nameController = TextEditingController(text: provider.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _onGetStarted(QuizProvider provider) {
    final enteredName = _nameController.text.trim();
    if (enteredName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please enter your name to personalize your quiz!',
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFFE53935),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    provider.setUserName(enteredName);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const CategorySelectionScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final quizProvider = Provider.of<QuizProvider>(context);
    final isDark = quizProvider.isDarkMode;

    if (_nameController.text.isEmpty && quizProvider.userName.isNotEmpty) {
      _nameController.text = quizProvider.userName;
    }

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          // Bookmark / Saved questions button
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded, size: 24),
            tooltip: 'Saved Questions',
            onPressed: () => BookmarksBottomSheet.show(context),
            color: isDark ? Colors.white70 : const Color(0xFF2C3E50),
          ),
          // History / Leaderboard button
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined, size: 24),
            tooltip: 'Score History',
            onPressed: () => HistoryBottomSheet.show(context),
            color: isDark ? Colors.white70 : const Color(0xFF2C3E50),
          ),
          // Dark Mode Toggle
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 22,
            ),
            tooltip: isDark ? 'Switch to Light Mode' : 'Switch to Dark Mode',
            onPressed: () => quizProvider.toggleDarkMode(),
            color: isDark ? const Color(0xFFFFD54F) : const Color(0xFF2C3E50),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  MediaQuery.of(context).padding.bottom -
                  kToolbarHeight -
                  24,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  // Mascot Illustration
                  const Center(
                    child: WelcomeIllustration(size: 230),
                  ),
                  const SizedBox(height: 10),

                  // Title "Quizzical"
                  Text(
                    'Quizzical',
                    style: GoogleFonts.nunito(
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      color: isDark ? Colors.white : const Color(0xFF2C3E50),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Test your knowledge & challenge yourself',
                    style: GoogleFonts.nunito(
                      fontSize: 14,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF718096),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Avatar Picker Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _avatars.map((emoji) {
                      final isSelected = (quizProvider.avatar == emoji);
                      return GestureDetector(
                        onTap: () => quizProvider.setAvatar(emoji),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (isDark ? const Color(0xFF1E3A37) : const Color(0xFFE0F2F1))
                                : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF7FAFC)),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF26A69A)
                                  : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
                              width: isSelected ? 2.5 : 1,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                      color: const Color(0xFF005953).withOpacity(0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                    ),
                                  ]
                                : [],
                          ),
                          child: Text(
                            emoji,
                            style: const TextStyle(fontSize: 22),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 18),

                  // Name Input Field
                  Container(
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.04),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    child: TextField(
                      controller: _nameController,
                      onChanged: (val) => quizProvider.setUserName(val),
                      style: GoogleFonts.nunito(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                      ),
                      decoration: InputDecoration(
                        icon: Text(
                          quizProvider.avatar,
                          style: const TextStyle(fontSize: 24),
                        ),
                        hintText: 'Enter your name...',
                        hintStyle: GoogleFonts.nunito(
                          fontSize: 15,
                          color: const Color(0xFFA0AEC0),
                          fontWeight: FontWeight.w600,
                        ),
                        border: InputBorder.none,
                        suffixIcon: _nameController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, size: 18, color: Color(0xFF718096)),
                                onPressed: () {
                                  _nameController.clear();
                                  quizProvider.setUserName('');
                                  setState(() {});
                                },
                              )
                            : null,
                      ),
                    ),
                  ),

                  const Spacer(),
                  const SizedBox(height: 20),

                  // "GET STARTED" Button
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () => _onGetStarted(quizProvider),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF005953),
                        foregroundColor: Colors.white,
                        elevation: 2,
                        shadowColor: const Color(0xFF005953).withOpacity(0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'GET STARTED',
                            style: GoogleFonts.nunito(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.arrow_forward_rounded, size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
