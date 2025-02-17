import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/log_api.dart';
import 'locator.dart';
import 'providers/dim.dart';
import 'providers/settings_provider.dart';
import 'enums/dye.dart';
import 'providers/animation.dart';
import 'view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final LogApi api = await LogApi.init();
  final Dim dim = Dim();
  final AnimationLogic animationLogic = await AnimationLogic().init(dim);

  locator.registerSingleton<LogApi>(api);
  var a = DateTime.now().toString().substring(0, 19);
  print(DateTime.tryParse(a));
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => SettingsProvider(prefs, dim)),
      ChangeNotifierProvider(create: (_) => dim),
      ChangeNotifierProvider(create: (_) => animationLogic),
      // other providers initialization
    ],
    child: const LifeLogApp(),
  ));
}

class LifeLogApp extends StatelessWidget {
  const LifeLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'LifeLog',
        theme: ThemeData(
          fontFamily: "RobotoMono",
          colorScheme: const ColorScheme.dark(
            primary: allColor,
          ),
        ),
        home: const LifeLogView());
  }
}
