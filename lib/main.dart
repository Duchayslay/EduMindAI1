import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';

// ĐỒNG BỘ IMPORT: Sử dụng đúng định danh package hệ thống cho kalender và web_demo
import 'package:kalender/kalender.dart';
import 'package:web_demo/providers.dart';

import 'package:smart_learning_application/const.dart'
    show defaultUserId, geminiApiKeyIfConfigured;
import 'package:smart_learning_application/provider/timer_provider.dart';
import 'package:smart_learning_application/screens/calendar.dart';
import 'package:smart_learning_application/screens/settings.dart';
import 'package:smart_learning_application/splash_screen.dart';
import 'learning_style_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'state/notebook_context_state.dart';

void main() {
  if (geminiApiKeyIfConfigured.isNotEmpty) {
    Gemini.init(apiKey: geminiApiKeyIfConfigured);
  }

  // Khởi tạo các ValueNotifier cấu hình cho Lịch bằng class chuẩn của package web_demo
  final themeMode = ValueNotifier(ThemeMode.system);
  final textDirection = ValueNotifier(TextDirection.ltr);
  final locale = ValueNotifier(const Locale('en', 'GB'));
  final eventsController = DefaultEventsController();

  final appSettings = AppSettings(
    themeMode: themeMode,
    textDirection: textDirection,
    locale: locale,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => NotebookContextState()..userId = defaultUserId,
        ),
        ChangeNotifierProvider(
          create: (_) => PomodoroTimer(),
        ),
      ],
      // Bọc tiếp 2 Provider của Lịch bằng Type đồng bộ chuẩn package:web_demo
      child: AppSettingsProvider(
        settings: appSettings,
        child: EventsControllerProvider(
          eventsController: eventsController,
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PMDEduMind',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/learning-style': (context) => QuizScreen(),
        '/settings': (context) => SettingsScreen(),
        '/calendar': (context) =>
            const MyCalendar(), // Đã đổi thành const để tối ưu hiệu năng
      },
    );
  }
}
