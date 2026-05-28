import 'package:flutter/material.dart';

import 'root_screen.dart';

class StudioSplashScreen extends StatefulWidget {
  const StudioSplashScreen({super.key});

  @override
  State<StudioSplashScreen> createState() => _StudioSplashScreenState();
}

class _StudioSplashScreenState extends State<StudioSplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,

      duration: const Duration(seconds: 4),
    );

    fadeAnimation = Tween<double>(
      begin: 0,

      end: 1,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

    controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (!mounted) {
        return;
      }

      Navigator.pushReplacement(
        context,

        MaterialPageRoute(builder: (_) => const RootScreen()),
      );
    });
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightGreenAccent,

      body: Stack(
        children: [
          Center(
            child: FadeTransition(
              opacity: fadeAnimation,

              child: Column(
                mainAxisSize: MainAxisSize.min,

                children: [
                  const Text(
                    "TheBOX Studios",

                    style: TextStyle(
                      color: Colors.white,

                      fontSize: 34,

                      fontFamily: "Poppins",

                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "by PSOrigins",

                    style: TextStyle(
                      color: const Color.fromARGB(255, 0, 0, 0),

                      fontSize: 16,

                      fontFamily: "Poppins",
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            bottom: 35,
            left: 0,
            right: 0,

            child: FadeTransition(
              opacity: fadeAnimation,

              child: Text(
                "-Think out of The BOX-",

                textAlign: TextAlign.center,

                style: TextStyle(
                  color: const Color.fromARGB(255, 0, 0, 0).withValues(alpha: 0.45),

                  fontSize: 14,

                  fontStyle: FontStyle.italic,

                  letterSpacing: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
