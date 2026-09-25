import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../providers/quiz_provider.dart';
import '../widgets/history_bottom_sheet.dart';
import '../widgets/bookmarks_bottom_sheet.dart';
import 'quiz_config_screen.dart';

class CategorySelectionScreen extends StatefulWidget {
  const CategorySelectionScreen({super.key});

  @override
  State<CategorySelectionScreen> createState() => _CategorySelectionScreenState();
}

class _CategorySelectionScreenState extends State<CategorySelectionScreen> {
  final TextEditingController _searchController = TextEditingController();

  static const List<List<Color>> _cardGradients = [
    [Color(0xFFFFF9C4), Color(0xFFFFEE58)], // Warm Yellow
    [Color(0xFFFFCDD2), Color(0xFFFF8A80)], // Coral Rose
    [Color(0xFFE0F7FA), Color(0xFF80DEEA)], // Cyan
    [Color(0xFFE8F5E9), Color(0xFFA5D6A7)], // Mint
    [Color(0xFFF3E5F5), Color(0xFFCE93D8)], // Lavender
    [Color(0xFFFFF3E0), Color(0xFFFFCC80)], // Sunset Orange
    [Color(0xFFE3F2FD), Color(0xFF90CAF9)], // Sky Blue
    [Color(0xFFFCE4EC), Color(0xFFF48FB1)], // Bubblegum
    [Color(0xFFE0F2F1), Color(0xFF80CBC4)], // Teal
    [Color(0xFFEDE7F6), Color(0xFFB39DDB)], // Violet
    [Color(0xFFFBE9E7), Color(0xFFFFAB91)], // Peach
    [Color(0xFFECEFF1), Color(0xFFCFD8DC)], // Slate
  ];

  static const List<IconData> _categoryIcons = [
    Icons.lightbulb_outline,
    Icons.auto_stories_outlined,
    Icons.movie_filter_outlined,
    Icons.music_note_outlined,
    Icons.theater_comedy,
    Icons.tv_outlined,
    Icons.sports_esports_outlined,
    Icons.casino_outlined,
    Icons.eco_outlined,
    Icons.computer_outlined,
    Icons.functions_outlined,
    Icons.menu_book_outlined,
    Icons.sports_soccer_outlined,
    Icons.public_outlined,
    Icons.history_edu_outlined,
    Icons.gavel_outlined,
    Icons.palette_outlined,
    Icons.stars_outlined,
    Icons.pets_outlined,
    Icons.directions_car_outlined,
    Icons.psychology_outlined,
    Icons.devices_outlined,
    Icons.animation_outlined,
    Icons.smart_toy_outlined,
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<QuizProvider>(context);
    final isDark = provider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: isDark ? Colors.white : const Color(0xFF2C3E50), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Categories',
          style: GoogleFonts.nunito(
            color: isDark ? Colors.white : const Color(0xFF2C3E50),
            fontWeight: FontWeight.w900,
            fontSize: 22,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_outline_rounded, size: 22),
            tooltip: 'Saved Questions',
            onPressed: () => BookmarksBottomSheet.show(context),
            color: isDark ? Colors.white70 : const Color(0xFF2C3E50),
          ),
          IconButton(
            icon: const Icon(Icons.emoji_events_outlined, size: 22),
            tooltip: 'Score History',
            onPressed: () => HistoryBottomSheet.show(context),
            color: isDark ? Colors.white70 : const Color(0xFF2C3E50),
          ),
          IconButton(
            icon: Icon(
              isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
              size: 20,
            ),
            tooltip: isDark ? 'Light Mode' : 'Dark Mode',
            onPressed: () => provider.toggleDarkMode(),
            color: isDark ? const Color(0xFFFFD54F) : const Color(0xFF2C3E50),
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingCategories) {
            return _buildLoadingSkeleton();
          }

          if (provider.categoryError != null) {
            return _buildErrorBanner(context, provider);
          }

          final categories = provider.filteredCategories;

          return Column(
            children: [
              // Search Bar Filter
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 6, 18, 12),
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF1E293B) : Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(
                      color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => provider.searchCategories(val),
                    style: GoogleFonts.nunito(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: isDark ? Colors.white : Colors.black87,
                    ),
                    decoration: InputDecoration(
                      hintText: 'Search 24+ categories...',
                      hintStyle: GoogleFonts.nunito(
                        color: isDark ? const Color(0xFF64748B) : const Color(0xFFA0AEC0),
                      ),
                      prefixIcon: Icon(Icons.search, color: isDark ? Colors.white70 : const Color(0xFF718096), size: 20),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear, size: 18, color: Color(0xFF718096)),
                              onPressed: () {
                                _searchController.clear();
                                provider.searchCategories('');
                              },
                            )
                          : null,
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ),

              // Categories Grid
              Expanded(
                child: categories.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.search_off, size: 54, color: Color(0xFFA0AEC0)),
                            const SizedBox(height: 12),
                            Text(
                              'No matching categories found',
                              style: GoogleFonts.nunito(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isDark ? Colors.white70 : const Color(0xFF4A5568),
                              ),
                            ),
                          ],
                        ),
                      )
                    : RefreshIndicator(
                        onRefresh: () => provider.fetchCategories(force: true),
                        child: GridView.builder(
                          physics: const BouncingScrollPhysics(),
                          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                          itemCount: categories.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                            childAspectRatio: 1.15,
                          ),
                          itemBuilder: (context, index) {
                            final cat = categories[index];
                            final gradient = _cardGradients[index % _cardGradients.length];
                            final cardIcon = _categoryIcons[index % _categoryIcons.length];

                            return _buildCategoryCard(context, cat, gradient, cardIcon, provider, isDark);
                          },
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(
    BuildContext context,
    CategoryModel category,
    List<Color> gradient,
    IconData icon,
    QuizProvider provider,
    bool isDark,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : Colors.transparent,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            provider.setSelectedCategory(category);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => QuizConfigScreen(category: category),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: gradient,
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(14),
                        boxShadow: [
                          BoxShadow(
                            color: gradient.last.withOpacity(0.4),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Icon(
                        icon,
                        color: const Color(0xFF2C3E50),
                        size: 22,
                      ),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      size: 13,
                      color: isDark ? const Color(0xFF64748B) : const Color(0xFFCBD5E0),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.groupName != category.cleanName
                          ? category.groupName.toUpperCase()
                          : 'TRIVIA',
                      style: GoogleFonts.nunito(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF718096),
                        letterSpacing: 0.6,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Text(
                      category.cleanName,
                      style: GoogleFonts.nunito(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: isDark ? Colors.white : const Color(0xFF2D3748),
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingSkeleton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GridView.builder(
        itemCount: 8,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 1.15,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEEEEE),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 10,
                      color: const Color(0xFFEEEEEE),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      width: 100,
                      height: 14,
                      color: const Color(0xFFEEEEEE),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildErrorBanner(BuildContext context, QuizProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFFCDD2)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.wifi_off_rounded, size: 48, color: Colors.redAccent),
              const SizedBox(height: 12),
              Text(
                'Failed to load categories',
                style: GoogleFonts.nunito(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2C3E50),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                provider.categoryError ?? 'Check your internet connection and try again.',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(fontSize: 13, color: const Color(0xFF757575)),
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => provider.fetchCategories(force: true),
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF005953),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
