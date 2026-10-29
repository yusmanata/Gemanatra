import 'package:flutter/material.dart';
import 'package:get/get.dart';

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

  @override
  void dispose() {
    _settings.dispose();
    _news.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScope(
      news: _news,
      settings: _settings,
      child: GetMaterialApp(
        title: 'Gemanatra',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppPages.initial,
        getPages: AppPages.routes,
      ),
    );
  }
}
