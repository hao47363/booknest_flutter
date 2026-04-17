import 'package:flutter/material.dart';

import 'app.dart';
import 'core/state/app_state.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final AppState appState = AppState();
  await appState.init();
  runApp(PocApp(appState: appState));
}
