import 'package:flutter/material.dart';

import '../core/navigation/app_routes.dart';
import 'app_router.dart';
import 'theme/app_theme.dart';

class OneShelfApp extends StatelessWidget {
  const OneShelfApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OneShelf',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.dark,
      theme: AppTheme.dark(),
      navigatorKey: AppRouter.navigatorKey,
      initialRoute: AppRoutes.library,
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
