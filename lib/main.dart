import 'package:flutter/material.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:provider/provider.dart';
import 'package:smart_learning_application/const.dart'
    show defaultUserId, geminiApiKeyIfConfigured;
import 'package:smart_learning_application/provider/timer_provider.dart';
import 'package:smart_learning_application/screens/settings.dart';
import 'package:smart_learning_application/splash_screen.dart';
import 'learning_style_page.dart';
import 'login_page.dart';
import 'signup_page.dart';
import 'state/notebook_context_state.dart';

import 'package:kalender/kalender.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/kalender.dart';
import 'package:smart_learning_application/widgets/calendar/calendar.dart';
import 'package:kalender/web_demo/l10n/app_localizations.dart';
import 'package:web_demo/locales.dart';
import 'package:web_demo/providers.dart';
import 'package:web_demo/widgets/calendar/calendar.dart';
import 'package:web_demo/utils.dart';
import 'package:web_demo/theme.dart';
import 'package:web_demo/widgets/toolbar/locale_dropdown.dart';
import 'package:web_demo/widgets/toolbar/text_direction_button.dart';
import 'package:web_demo/widgets/toolbar/theme_button.dart';
import 'package:web_demo/widgets/toolbar/view_type_picker.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_demo/widgets/toolbar/warning_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(body: MyCalendar()),
    );
  }
}

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => _MyCalendarState();
}

class _MyCalendarState extends State<MyCalendar> {
  final eventsController = DefaultEventsController();
  final calendarController = CalendarController();

  @override
  Widget build(BuildContext context) {
    return CalendarView(
      eventsController: eventsController,
      calendarController: calendarController,
      viewConfiguration: MultiDayViewConfiguration.singleDay(),
      callbacks: CalendarCallbacks(
        onEventCreated: (event) => eventsController.addEvent(event),
      ),
      header: CalendarHeader(),
      body: CalendarBody(),
    );
  }
}

void main() {
  if (geminiApiKeyIfConfigured.isNotEmpty) {
    Gemini.init(apiKey: geminiApiKeyIfConfigured);
  }
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
      child: const MyApp(),
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
      home: SplashScreen(),
      debugShowCheckedModeBanner: false, // Set LoginPage as the initial page
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/learning-style': (context) =>
            QuizScreen(), // Ensure this points to your signup page
        '/settings': (context) => SettingsScreen(),
        '/homes': (context) => const MobileHomePage(), const DesktopHomePage(),
      },
    );
  }
}

class MobileHomePage extends StatelessWidget {
  const MobileHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.appTitle,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
        actions: const [
          WarningButton(),
          SizedBox(width: 4),
          ThemeButton(),
          SizedBox(width: 4),
          TextDirectionButton(),
          SizedBox(width: 4),
          SizedBox(width: 4),
          LocaleDropdown(),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
              height: 1,
              color:
                  Theme.of(context).colorScheme.outlineVariant.withAlpha(80)),
        ),
      ),
      body: const Calendar(),
    );
  }
}

class DesktopHomePage extends StatefulWidget {
  const DesktopHomePage({super.key});
  @override
  State<DesktopHomePage> createState() => _DesktopHomePageState();
}

class _DesktopHomePageState extends State<DesktopHomePage> {
  /// The type of the calendar view.
  ViewType _type = ViewType.single;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.l10n.appTitle,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(fontWeight: FontWeight.w600),
        ),
        actionsPadding: const EdgeInsets.symmetric(horizontal: 12),
        actions: [
          const ThemeButton(),
          const SizedBox(width: 4),
          const TextDirectionButton(),
          const SizedBox(width: 8),
          const LocaleDropdown(),
          const SizedBox(width: 8),
          ViewTypePicker(
              type: _type, onChanged: (value) => setState(() => _type = value)),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Divider(
              height: 1,
              color:
                  Theme.of(context).colorScheme.outlineVariant.withAlpha(80)),
        ),
      ),
      body: _type == ViewType.single
          ? const Calendar()
          : const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Flexible(flex: 3, child: Calendar(initialShowConfig: false)),
                Flexible(flex: 3, child: Calendar(initialShowConfig: false)),
              ],
            ),
    );
  }
}
