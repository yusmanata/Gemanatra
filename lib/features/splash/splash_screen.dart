import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/router.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/dimens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        context.go(AppRoutes.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final dimens = Dimens.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Semantics(
          label: 'Logo Gemanatra. Memuat aplikasi.',
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(dimens.borderRadiusLarge),
              child: Image.asset(
                'assets/images/logo.jpg',
                width: dimens.emptyStateContainerSize,
                height: dimens.emptyStateContainerSize,
                fit: BoxFit.cover,
                semanticLabel: 'Logo Gemanatra',
                errorBuilder: (_, _, _) => Icon(
                  Icons.volume_up_rounded,
                  color: AppColors.primaryDark,
                  size: dimens.emptyStateContainerSize,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
