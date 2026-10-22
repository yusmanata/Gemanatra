import 'package:flutter/widgets.dart';

import '../features/news/news_controller.dart';
import '../features/settings/settings_controller.dart';

class AppScope extends InheritedWidget {
  const AppScope({
    super.key,
    required this.news,
    required this.settings,
    required super.child,
  });

  final NewsController news;
  final SettingsController settings;

  static AppScope of(BuildContext context) {
    final scope = context.getInheritedWidgetOfExactType<AppScope>();
    assert(scope != null, 'AppScope tidak ditemukan di atas context ini.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
