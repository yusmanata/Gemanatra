import 'package:flutter/widgets.dart';

import '../features/news/news_controller.dart';
import '../features/settings/settings_controller.dart';

/// Menyediakan controller lintas layar: `AppScope.of(context).news`.
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

  // Controller tidak pernah diganti; widget mendengarkan perubahannya lewat ListenableBuilder.
  @override
  bool updateShouldNotify(AppScope oldWidget) => false;
}
