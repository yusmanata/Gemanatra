import 'package:get/get.dart';

import '../features/main/main_shell.dart';
import '../features/news_detail/news_detail_screen.dart';
import '../features/splash/splash_screen.dart';

/// Semua path aplikasi; jangan menulis string path langsung di widget.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/home';
  static const newsDetailPattern = '/news/:id';
  static String newsDetail(String id) => '/news/$id';
}

/// Daftar halaman untuk GetMaterialApp.
abstract final class AppPages {
  static const initial = AppRoutes.splash;

  static final routes = [
    GetPage(name: AppRoutes.splash, page: () => const SplashScreen()),
    GetPage(name: AppRoutes.home, page: () => const MainShell()),
    GetPage(
      name: AppRoutes.newsDetailPattern,
      page: () => NewsDetailScreen(newsId: Get.parameters['id'] ?? ''),
    ),
  ];
}
