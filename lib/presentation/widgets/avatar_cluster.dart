import 'dart:math';
import 'package:flutter/material.dart';
import 'package:voalis_teste/data/models/circle_model.dart';

class AvatarCluster extends StatelessWidget {
  final CircleModel circle;
  final int circleIndex;
  final double scale;

  const AvatarCluster({
    super.key,
    required this.circle,
    required this.circleIndex,
    required this.scale,
  });

  @override
  Widget build(BuildContext context) {
    double baseAvatarSize = 40;
    double avatarSize = baseAvatarSize * scale.clamp(0.5, 1.0);
    double radius = circle.radius - avatarSize;
    int count = circle.avatarCount;

    List<Widget> avatars = [];
    double startAngle = pi / 6;
    double endAngle = pi - pi / 6;
    double step = (endAngle - startAngle) / (count - 1);

    for (int i = 0; i < count; i++) {
      double angle = startAngle + i * step;
      double dx = radius * cos(angle);
      double dy = radius * sin(angle);

      avatars.add(Positioned(
        left: circle.radius + dx - avatarSize / 2,
        top: circle.radius + dy - avatarSize / 2,
        child: Container(
          width: avatarSize,
          height: avatarSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(
                'https://i.pravatar.cc/150?img=${circleIndex * 10 + i}',
              ),
            ),
          ),
        ),
      ));
    }

    return Stack(children: avatars);
  }
}
