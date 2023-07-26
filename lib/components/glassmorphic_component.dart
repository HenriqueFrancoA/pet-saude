import 'package:flutter/material.dart';
import 'package:glassmorphism/glassmorphism.dart';

class CustomGlassmorphicContainer extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;
  final Widget child;

  const CustomGlassmorphicContainer({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 15,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return GlassmorphicContainer(
      width: width,
      height: height,
      borderRadius: borderRadius,
      blur: 20,
      border: 2,
      linearGradient: LinearGradient(
        colors: [
          const Color(0xFFffffff).withOpacity(0.1),
          const Color(0xFFFFFFFF).withOpacity(0.1),
        ],
      ),
      borderGradient: LinearGradient(
        colors: [
          const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
          const Color.fromARGB(255, 255, 255, 255).withOpacity(0.2),
        ],
      ),
      child: child,
    );
  }
}
