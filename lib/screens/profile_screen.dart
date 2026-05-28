import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:moneytracker/widgets/animated_background.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'setup_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? imagePath;

  Future<void> pickImage() async {
    PermissionStatus status;

    status = await Permission.photos.request();

    if (!status.isGranted) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gallery permission denied")),
      );

      return;
    }

    final picker = ImagePicker();

    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      return;
    }

    await Hive.box("userBox").put("profileImage", image.path);

    setState(() {
      imagePath = image.path;
    });
  }

  late String userName;

  @override
  void initState() {
    super.initState();

    final userBox = Hive.box("userBox");

    userName = userBox.get("name", defaultValue: "User");

    imagePath = userBox.get("profileImage");
  }

  void deleteAccount() {
    showDialog(
      context: context,

      barrierColor: Colors.black.withValues(alpha: 0.2),

      builder: (context) {
        return BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),

          child: AlertDialog(
            backgroundColor: Colors.white.withValues(alpha: 0.75),

            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),

            title: const Row(
              children: [
                Icon(Icons.warning_rounded, color: Colors.red),

                SizedBox(width: 10),

                Text("Delete Account"),
              ],
            ),

            content: const Text(
              "This action permanently deletes all your account data and transaction history.",
            ),

            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },

                child: const Text("Cancel"),
              ),

              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),

                onPressed: () async {
                  await Hive.box("userBox").clear();

                  await Hive.box("transactionBox").clear();

                  await Hive.box("settingsBox").clear();

                  if (!mounted) return;

                  Navigator.pushAndRemoveUntil(
                    context,

                    MaterialPageRoute(builder: (_) => const SetupScreen()),

                    (route) => false,
                  );
                },

                child: const Text("Confirm"),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              GestureDetector(
                onTap: pickImage,

                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 60,

                      backgroundColor: Colors.green,

                      backgroundImage:
                          imagePath != null && File(imagePath!).existsSync()
                          ? FileImage(File(imagePath!))
                          : null,

                      child: imagePath == null || !File(imagePath!).existsSync()
                          ? const Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white,
                            )
                          : null,
                    ),

                    if (imagePath == null || !File(imagePath!).existsSync())
                      const Padding(
                        padding: EdgeInsets.only(top: 8),

                        child: Text(
                          "Add Image",

                          style: TextStyle(
                            fontSize: 14,

                            color: Colors.grey,

                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(height: 15),

              Text(
                userName,

                style: const TextStyle(
                  fontFamily: "Poppins",

                  fontSize: 28,

                  fontWeight: FontWeight.bold,
                ),
              ),

              const Text("Money Tracker User"),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Settings",

                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: SwitchListTile(
                  title: const Text("Dark Mode"),

                  secondary: const Icon(Icons.dark_mode),

                  value: Hive.box(
                    "settingsBox",
                  ).get("darkMode", defaultValue: false),

                  onChanged: (value) async {
                    await Hive.box("settingsBox").put("darkMode", value);

                    setState(() {});
                  },
                ),
              ),

              const SizedBox(height: 30),

              Align(
                alignment: Alignment.centerLeft,

                child: Text(
                  "Account Details",

                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 10),

              Card(
                child: Padding(
                  padding: const EdgeInsets.all(15),

                  child: Column(
                    children: [
                      Row(
                        children: [
                          const Text("Created: "),

                          Text(
                            Hive.box("userBox")
                                .get(
                                  "createdDate",
                                  defaultValue: DateTime.now(),
                                )
                                .toString()
                                .split(" ")[0],
                          ),
                        ],
                      ),

                      const SizedBox(height: 15),

                      Row(children: [const Text("Name: "), Text(userName)]),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,

                    padding: const EdgeInsets.all(15),
                  ),

                  onPressed: deleteAccount,

                  icon: const Icon(Icons.delete),

                  label: const Text("Delete Account"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
