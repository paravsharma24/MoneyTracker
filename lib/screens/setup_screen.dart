import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'main_screen_manager.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();

  late AnimationController animationController;

  late Animation<double> fadeAnimation;

  String? errorText;

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(animationController);

    animationController.forward();
  }

  bool isValidName(String name) {
    final regex = RegExp(r'^[a-zA-Z ]+$');

    return regex.hasMatch(name);
  }

  void saveUser() {
    String name = nameController.text.trim();

    if (name.isEmpty) {
      setState(() {
        errorText = "Enter your name please";
      });

      return;
    }

    if (!isValidName(name)) {
      setState(() {
        errorText = "Invalid name";
      });

      return;
    }

    final userBox = Hive.box("userBox");

    userBox.put("name", name);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const ScreenManager()),
    );
  }

  @override
  void dispose() {
    animationController.dispose();

    nameController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8FFF1),

      appBar: AppBar(
        backgroundColor: Colors.lightGreen,

        title: const Text("Welcome"),
      ),

      body: Center(
        child: FadeTransition(
          opacity: fadeAnimation,

          child: Padding(
            padding: const EdgeInsets.all(25),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,

              children: [
                const Icon(
                  Icons.account_balance_wallet,
                  size: 80,
                  color: Colors.green,
                ),

                const SizedBox(height: 20),

                const Text(
                  "Welcome To Money Tracker",
                  textAlign: TextAlign.center,

                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 15),

                TextField(
                  controller: nameController,

                  decoration: InputDecoration(
                    hintText: "Enter your name",

                    errorText: errorText,

                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),

                    filled: true,

                    fillColor: Colors.white,
                  ),
                ),

                const SizedBox(height: 25),

                ElevatedButton(
                  onPressed: saveUser,

                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,

                    minimumSize: const Size(double.infinity, 55),
                  ),

                  child: const Text("Continue"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
