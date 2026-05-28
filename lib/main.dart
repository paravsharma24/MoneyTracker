import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'services/database_service.dart';
// import 'screens/root_screen.dart';
import 'screens/studio_splash_screen.dart';

void main() async {

  WidgetsFlutterBinding
      .ensureInitialized();

  await DatabaseService.init();

  runApp(
    const MoneyTracker(),
  );
}


class MoneyTracker extends StatelessWidget {
  const MoneyTracker({super.key});

  @override
  Widget build(BuildContext context) {

    final settingsBox =
        Hive.box("settingsBox");

    return ValueListenableBuilder(
      valueListenable:
          settingsBox.listenable(),

      builder:
          (context, box, child) {

        final darkMode =
            box.get(
          "darkMode",
          defaultValue: false,
        );

        return MaterialApp(

          debugShowCheckedModeBanner:
              false,

          themeMode:
              darkMode
                  ? ThemeMode.dark
                  : ThemeMode.light,

          theme: ThemeData(
            useMaterial3: true,

            brightness:
                Brightness.light,

            fontFamily:
                "Poppins",

            colorScheme:
                ColorScheme.fromSeed(
              seedColor:
                  Colors.green,
            ),
          ),

          darkTheme:
              ThemeData(
            useMaterial3: true,

            brightness:
                Brightness.dark,

            fontFamily:
                "Poppins",

            colorScheme:
                ColorScheme.fromSeed(
              seedColor:
                  Colors.green,
              brightness:
                  Brightness.dark,
            ),
          ),

          home:
              const StudioSplashScreen(),
        );
      },
    );
  }
}