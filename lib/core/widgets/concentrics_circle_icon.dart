import 'package:flutter/material.dart';

class ConcentricCirclesIcon extends StatelessWidget {
  const ConcentricCirclesIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Icon(Icons.circle_outlined, size: 28, color: Colors.white),
        Icon(Icons.circle, size: 14, color: Colors.white),
      ],
    );
  }
}
