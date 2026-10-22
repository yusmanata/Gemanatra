import 'package:go_router/go_router.dart';

import '../features/favorites/favorites_screen.dart';
import '../features/home/home_screen.dart';
import '../features/main/main_shell.dart';
import '../features/news_detail/news_detail_screen.dart';
import '../features/settings/settings_screen.dart';
import '../features/splash/splash_screen.dart';

/// Semua path aplikasi; jangan menulis string path langsung di widget.
abstract final class AppRoutes {
  static const splash = '/splash';
  static const home = '/';
  static const favorites = '/favorites';
  static const settings = '/settings';
  static const _newsDetailPattern = '/news/:id';
  static String newsDetail(String id) => '/news/$id';
}

GoRouter createRouter() => GoRouter(
  initialLocation: AppRoutes.splash,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    // Tiga tab; state tiap tab dipertahankan saat berpindah.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.favorites,
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.settings,
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes._newsDetailPattern,
      builder: (context, state) =>
          NewsDetailScreen(newsId: state.pathParameters['id'] ?? ''),
    ),
  ],
);
