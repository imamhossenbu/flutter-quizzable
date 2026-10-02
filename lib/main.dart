import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'providers/quiz_provider.dart';
import 'screens/welcome_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const QuizzicalApp());
}

class QuizzicalApp extends StatelessWidget {
  const QuizzicalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuizProvider(),
      child: Consumer<QuizProvider>(
        builder: (context, provider, child) {
          return MaterialApp(
            title: 'Quizzical',
            debugShowCheckedModeBanner: false,
            themeMode: provider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.light,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF005953),
                primary: const Color(0xFF005953),
                brightness: Brightness.light,
              ),
              textTheme: GoogleFonts.nunitoTextTheme(),
              scaffoldBackgroundColor: Colors.white,
              cardColor: Colors.white,
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF005953),
                primary: const Color(0xFF26A69A),
                brightness: Brightness.dark,
                surface: const Color(0xFF1E293B),
              ),
              scaffoldBackgroundColor: const Color(0xFF0F172A),
              cardColor: const Color(0xFF1E293B),
              textTheme: GoogleFonts.nunitoTextTheme(
                ThemeData(brightness: Brightness.dark).textTheme,
              ),
            ),
            builder: (context, appChild) {
              final mediaQuery = MediaQuery.of(context);
              final isWideScreen = mediaQuery.size.width > 480;

              Widget content = appChild ?? const SizedBox.shrink();

              if (isWideScreen) {
                content = Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 480),
                    child: Container(
                      decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.25),
                            blurRadius: 24,
                            spreadRadius: 2,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRect(
                        child: MediaQuery(
                          data: mediaQuery.copyWith(
                            size: Size(480, mediaQuery.size.height),
                          ),
                          child: content,
                        ),
                      ),
                    ),
                  ),
                );
              }

              return Container(
                color: provider.isDarkMode
                    ? const Color(0xFF0B1120)
                    : const Color(0xFFE2E8F0),
                child: content,
              );
            },
            home: const WelcomeScreen(),
          );
        },
      ),
    );
  }
}
