import 'package:flutter/material.dart';
import 'package:voalis_teste/data/models/circle_model.dart';
import 'package:voalis_teste/core/constants/colors.dart';
import 'avatar_cluster.dart';

class CircleWidget extends StatelessWidget {
  final CircleModel circle;
  final int index;
  final double scale;
  final VoidCallback onTap;

  const CircleWidget({
    super.key,
    required this.circle,
    required this.index,
    required this.scale,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: circle.radius * 2,
        height: circle.radius * 2,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color.fromARGB(255, 188, 213, 234), width: 2)),
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.topCenter,
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: 8,
                child: Text(
                  circle.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              AvatarCluster(circle: circle, circleIndex: index, scale: scale),
            ],
          ),
        ),
      ),
    );
  }
}
