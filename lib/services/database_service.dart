import 'package:hive_ce_flutter/hive_flutter.dart';

class DatabaseService {

  static Future<void> init() async {

    await Hive.initFlutter();

    await Hive.openBox(
      "userBox",
    );

    await Hive.openBox(
      "transactionBox",
    );

    await Hive.openBox(
      "settingsBox",
    );
  }
}