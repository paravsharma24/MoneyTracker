import 'package:flutter/material.dart';

class AnimatedBackground extends StatefulWidget {
  final Widget child;

  const AnimatedBackground({
    super.key,
    required this.child,
  });

  @override
  State<AnimatedBackground> createState() =>
      _AnimatedBackgroundState();
}

class _AnimatedBackgroundState
    extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {

  late AnimationController controller;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 10,
      ),
    )..repeat(
        reverse: true,
      );
  }

  @override
  void dispose() {
    controller.dispose();

    super.dispose();
  }

  Widget buildBall({

    required Color color,
    required double size,
    required double top,
    required double left,

  }) {

    return AnimatedBuilder(

      animation: controller,

      builder: (_, child) {

        return Positioned(

          top:
              top +
              (controller.value * 40),

          left:
              left +
              (controller.value * 20),

          child:
              Container(

            width: size,

            height: size,

            decoration:
                BoxDecoration(

              shape:
                  BoxShape.circle,

              color:
                  color.withValues(
                alpha: 0.25,
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(
      BuildContext context) {

    return Stack(

      children: [

        buildBall(
          color:
              Colors.green,
          size: 200,
          top: -50,
          left: -80,
        ),

        buildBall(
          color:
              Colors.lightGreen,
          size: 150,
          top: 200,
          left: 250,
        ),

        buildBall(
          color:
              Colors.teal,
          size: 180,
          top: 450,
          left: -60,
        ),

        buildBall(
          color:
              Colors.greenAccent,
          size: 120,
          top: 550,
          left: 280,
        ),

        buildBall(
          color:
              Colors.lime,
          size: 140,
          top: 100,
          left: 120,
        ),

        widget.child,
      ],
    );
  }
}