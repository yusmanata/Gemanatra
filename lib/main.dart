import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'app/router.dart';
import 'core/app_scope.dart';
import 'core/theme/app_theme.dart';
import 'features/news/news_controller.dart';
import 'features/settings/settings_controller.dart';

void main() => runApp(const GemanatraApp());

class GemanatraApp extends StatefulWidget {
  const GemanatraApp({super.key});

  @override
  State<GemanatraApp> createState() => _GemanatraAppState();
}

class _GemanatraAppState extends State<GemanatraApp> {
  final _news = NewsController();
  final _settings = SettingsController();
  late final GoRouter _router = createRouter();

  @override
  void dispose() {
    _router.dispose();
    _settings.dispose();
    _news.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      news: _news,
      settings: _settings,
      child: MaterialApp.router(
        title: 'Gemanatra',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: _router,
      ),
    );
  }
}
