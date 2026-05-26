import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kalender/kalender.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:web_demo/l10n/app_localizations.dart';
import 'package:smart_learning_application/web_demo/lib/locales.dart';
import 'package:smart_learning_application/web_demo/lib/providers.dart';
import 'package:smart_learning_application/web_demo/lib/widgets/calendar/calendar.dart';
import 'package:smart_learning_application/web_demo/lib/utils.dart';
import 'package:smart_learning_application/web_demo/lib/theme.dart';
import 'package:smart_learning_application/web_demo/lib/widgets/toolbar/locale_dropdown.dart';
import 'package:smart_learning_application/web_demo/lib/widgets/toolbar/text_direction_button.dart';
import 'package:smart_learning_application/web_demo/lib/widgets/toolbar/theme_button.dart';
import 'package:smart_learning_application/web_demo/lib/widgets/toolbar/view_type_picker.dart';
import 'package:smart_learning_application/web_demo/lib/widgets/toolbar/warning_button.dart';

// Định tuyến phần múi giờ (Timezone) chạy nội bộ
import 'package:smart_learning_application/web_demo/lib/timezone/stub.dart'
    if (dart.library.html) 'package:smart_learning_application/web_demo/lib/timezone/browser.dart'
    if (dart.library.io) 'package:smart_learning_application/web_demo/lib/timezone/standalone.dart';

class MyCalendar extends StatefulWidget {
  const MyCalendar({super.key});

  @override
  State<MyCalendar> createState() => MyCalendarState();
}

class MyCalendarState extends State<MyCalendar> {
  final _themeMode = ValueNotifier(ThemeMode.system);
  final _textDirection = ValueNotifier(TextDirection.ltr);
  late final _locale = ValueNotifier(_resolveLocale(
    WidgetsBinding.instance.platformDispatcher.locale,
    supportedLocales,
  ));
  final _eventsController = DefaultEventsController();
  late final _appSettings = AppSettings(
      themeMode: _themeMode, textDirection: _textDirection, locale: _locale);

  @override
  void initState() {
    super.initState();
    _eventsController.addEvents(generateEvents(context));
  }

  @override
  void dispose() {
    _themeMode.dispose();
    _textDirection.dispose();
    _locale.dispose();
    _eventsController.dispose();
    super.dispose();
  }

  static ThemeData _buildTheme(Brightness brightness) =>
      buildAppTheme(brightness);

  Locale _resolveLocale(Locale? locale, Iterable<Locale> supportedLocales) {
    if (locale == null) return const Locale('en', 'GB');
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return supportedLocale;
      }
    }
    return const Locale('en', 'GB');
  }

  @override
  Widget build(BuildContext context) {
    return AppSettingsProvider(
      settings: _appSettings,
      child: EventsControllerProvider(
        eventsController: _eventsController,
        child: ListenableBuilder(
          listenable: Listenable.merge([_themeMode, _locale, _textDirection]),
          builder: (context, __) {
            // SỬA TẠI ĐÂY: Dùng Builder để sinh ra một BuildContext MỚI (nằm dưới Provider)
            return Builder(
              builder: (innerContext) {
                return Theme(
                  data: _buildTheme(_themeMode.value == ThemeMode.dark
                      ? Brightness.dark
                      : Brightness.light),
                  child: Localizations(
                    locale: _locale.value,
                    delegates: const [
                      AppLocalizations.delegate,
                      GlobalMaterialLocalizations.delegate,
                      GlobalWidgetsLocalizations.delegate,
                      GlobalCupertinoLocalizations.delegate,
                    ],
                    child: Directionality(
                      textDirection: _textDirection.value,
                      // SỬA TẠI ĐÂY: Thay vì gọi const, ta gọi hàm khởi tạo để truyền innerContext chuẩn vào trong nếu cần
                      child: isTouch
                          ? const MobileHomePage()
                          : const DesktopHomePage(),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
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
