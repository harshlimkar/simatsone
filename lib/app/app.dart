// SIMATS ONE – Root App Widget

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router/app_router.dart';
import 'theme/simats_theme.dart';
import '../app/config/app_config.dart';

class SimatsOneApp extends ConsumerWidget {
  const SimatsOneApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: SimatsTheme.light,
      routerConfig: router,
    );
  }
}
