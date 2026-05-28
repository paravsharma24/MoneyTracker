import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'setup_screen.dart';
import 'main_screen_manager.dart';

class RootScreen extends StatelessWidget {
  const RootScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final userBox = Hive.box("userBox");

    bool userExists =
        userBox.containsKey("name");

    if (userExists) {
      return const ScreenManager();
    }

    return const SetupScreen();
  }
}