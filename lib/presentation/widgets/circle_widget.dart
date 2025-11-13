import 'package:flutter/material.dart';
import 'package:voalis_teste/data/models/circle_model.dart';

class CircleWidget extends StatelessWidget {
  final CircleModel circle;
  final int index;
  final bool isFocused;
  final VoidCallback onTap;
  final double size;

  const CircleWidget({
    super.key,
    required this.circle,
    required this.index,
    required this.isFocused,
    required this.onTap,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isFocused ? onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // FUNDO TRANSPARENTE - apenas a borda
          border: Border.all(
            color: Colors.white.withOpacity(isFocused ? 0.8 : 0.5),
            width: isFocused ? 3 : 2,
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
        child: ClipOval(
          child: Stack(
            children: [
              // Label do círculo na parte superior
              Positioned(
                top: size * 0.15,
                left: 0,
                right: 0,
                child: Center(
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      circle.label,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isFocused ? 18 : 12,
                        fontWeight:
                            isFocused ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ),

              // Avatares preenchendo a METADE INFERIOR do círculo
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: size * 0.5,
                child: _buildAvatarGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    final avatarSize = size * 0.12;
    final spacing = size * 0.02;

    return Padding(
      padding: EdgeInsets.all(size * 0.08),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: spacing,
        runSpacing: spacing,
        children: List.generate(circle.avatarCount, (avatarIndex) {
          return Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(
                  'https://i.pravatar.cc/150?img=$avatarIndex',
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
