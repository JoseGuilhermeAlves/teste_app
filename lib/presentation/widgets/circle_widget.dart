import 'package:flutter/material.dart';
import 'package:voalis_teste/data/models/circle_model.dart';
import 'package:voalis_teste/core/constants/colors.dart';
import 'avatar_cluster.dart';

class CircleWidget extends StatelessWidget {
  final CircleModel circle;
  final int index;
  final double scale;
  final bool isFocused;
  final VoidCallback onTap;

  const CircleWidget({
    super.key,
    required this.circle,
    required this.index,
    required this.scale,
    required this.onTap,
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isFocused ? onTap : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: circle.radius * 2,
        height: circle.radius * 2,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: isFocused
                ? Colors.blueAccent.withOpacity(0.8)
                : Colors.white.withOpacity(0.3),
            width: isFocused ? 3 : 1.5,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: Colors.blueAccent.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        child: Container(
          margin: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.transparent,
          ),
          child: Stack(
            alignment: Alignment.center,
            clipBehavior: Clip.none,
            children: [
              // Label do círculo
              Positioned(
                top: 15,
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  style: TextStyle(
                    color: isFocused ? Colors.white : Colors.white70,
                    fontWeight: isFocused ? FontWeight.bold : FontWeight.normal,
                    fontSize: isFocused ? 16 : 14,
                  ),
                  child: Text(circle.label),
                ),
              ),

              // Avatares preenchendo o semicírculo
              ClipPath(
                clipper: SemicircleClipper(),
                child: AvatarCluster(
                  circle: circle,
                  circleIndex: index,
                  scale: scale,
                  isFocused: isFocused,
                ),
              ),

              // Indicador de interação quando focado
              if (isFocused)
                Positioned(
                  bottom: 20,
                  child: AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: isFocused ? 1.0 : 0.0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.touch_app,
                            color: Colors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Toque para abrir',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Clipper para criar um semicírculo (metade superior)
class SemicircleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, size.height / 2);
    path.arcToPoint(
      Offset(size.width, size.height / 2),
      radius: Radius.circular(size.width / 2),
      clockwise: false,
    );
    path.lineTo(size.width, size.height / 2);
    path.lineTo(0, size.height / 2);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
