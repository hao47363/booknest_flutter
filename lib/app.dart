import 'package:flutter/material.dart';

import 'core/state/app_scope.dart';
import 'core/state/app_state.dart';
import 'routes/app_router.dart';
import 'shared/theme/app_theme.dart';

class PocApp extends StatelessWidget {
  const PocApp({
    required this.appState,
    super.key,
  });

  final AppState appState;

  @override
  Widget build(BuildContext context) {
    return AppScope(
      appState: appState,
      child: MaterialApp.router(
        title: 'BookNest',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: createRouter(appState),
      ),
    );
  }
}
