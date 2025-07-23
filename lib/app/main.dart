import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';

import '../streams/general_stream.dart';
import 'app_module.dart';
import 'core/themes/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();
  await initializeDateFormatting('en-us');
  await _requestPermissions();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(ModularApp(module: AppModule(), child: const MyApp()));
}

Future<void> _requestPermissions() async {
  await [
    Permission.storage,
  ].request();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _locale = '';
  @override
  void initState() {
    _locale = Platform.localeName;

    if (_locale != 'en_US' && _locale != 'pt_BR') {
      _locale = 'en_US';
    }
    GeneralStream.languageStream.add(Locale(_locale));
    super.initState();
  }

  @override
  void dispose() {
    GeneralStream.languageStream.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Locale>(
        stream: GeneralStream.languageStream.stream,
        builder: (context, snapshot) {
          return MaterialApp.router(
            theme: ThemeData(
              scaffoldBackgroundColor: AppColors.backgroundColor,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: Colors.white,
                selectionColor: AppColors.mainColor,
                selectionHandleColor: AppColors.mainColor,
              ),
            ),
            title: "ManualGuru",
            routerConfig: Modular.routerConfig,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: const [
              Locale('en'), // English
              Locale('pt'), // Portuguese
            ],
            locale: snapshot.data,
          );
        });
  }
}
