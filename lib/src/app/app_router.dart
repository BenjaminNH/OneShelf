import 'package:flutter/material.dart';

import '../core/navigation/app_routes.dart';
import 'app_route_pages.dart';
import '../features/library/presentation/library_home_page.dart';
import '../features/search/search_page.dart';
import '../shared/widgets/frosted_background.dart';

abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final routeName = settings.name ?? '';

    switch (settings.name) {
      case AppRoutes.library:
        return _build(const LibraryHomePage(), settings);
      case AppRoutes.search:
        return _build(const SearchPage(), settings);
      case AppRoutes.settings:
        return _build(const SettingsRoutePage(), settings);
      case AppRoutes.sources:
        return _build(const MediaSourcesRoutePage(), settings);
      default:
        if (routeName.startsWith('/detail/')) {
          final mediaId = routeName.substring('/detail/'.length);
          return _build(DetailRoutePage(mediaId: mediaId), settings);
        }

        if (routeName.startsWith('/player/')) {
          final mediaId = routeName.substring('/player/'.length);
          return _build(PlayerRoutePage(mediaId: mediaId), settings);
        }

        return _build(_RoutePlaceholderPage(routeName: routeName), settings);
    }
  }

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  static MaterialPageRoute<dynamic> _build(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      settings: settings,
      builder: (_) => child,
    );
  }
}

class _RoutePlaceholderPage extends StatelessWidget {
  const _RoutePlaceholderPage({required this.routeName});

  final String routeName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FrostedBackground(
        child: Center(
          child: Text(
            'Route ready for integration:\n$routeName',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
