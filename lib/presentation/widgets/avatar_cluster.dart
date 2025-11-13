import 'dart:math';
import 'package:flutter/material.dart';
import 'package:voalis_teste/data/models/circle_model.dart';

class AvatarCluster extends StatelessWidget {
  final CircleModel circle;
  final int circleIndex;
  final double scale;
  final bool isFocused;

  const AvatarCluster({
    super.key,
    required this.circle,
    required this.circleIndex,
    required this.scale,
    this.isFocused = false,
  });

  @override
  Widget build(BuildContext context) {
    double baseAvatarSize = 45;
    double avatarSize = baseAvatarSize * scale.clamp(0.6, 1.0);
    int count = circle.avatarCount;

    // Calcular o layout em grade para preencher o semicírculo
    List<Widget> avatars = [];

    // Área disponível do semicírculo (metade superior)
    double availableRadius = circle.radius - 30; // Margem interna

    // Calcular número de linhas e colunas baseado na quantidade
    int rows = (sqrt(count * 2)).ceil(); // Mais linhas para semicírculo
    int maxCols = (count / rows).ceil();

    int avatarIndex = 0;

    for (int row = 0; row < rows && avatarIndex < count; row++) {
      // Y position - de cima para baixo no semicírculo
      double yPercent = (row + 0.5) / rows;
      double y = availableRadius * (1 - yPercent);

      // Calcular largura disponível nesta altura
      // Usando teorema de Pitágoras para encontrar a largura do círculo nesta altura
      double widthAtY = 2 * sqrt(max(0, pow(availableRadius, 2) - pow(y, 2)));

      // Número de avatares nesta linha (proporcional à largura)
      int colsInRow =
          max(1, (maxCols * (widthAtY / (2 * availableRadius))).round());
      colsInRow = min(colsInRow, count - avatarIndex);

      for (int col = 0; col < colsInRow && avatarIndex < count; col++) {
        // X position - distribuir uniformemente na largura disponível
        double xPercent = colsInRow == 1 ? 0.5 : col / (colsInRow - 1);
        double x = -widthAtY / 2 + widthAtY * xPercent;

        avatars.add(
          Positioned(
            left: circle.radius + x - avatarSize / 2,
            top: circle.radius - y - avatarSize / 2,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: avatarSize,
              height: avatarSize,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 200),
                opacity: isFocused ? 1.0 : 0.6,
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.white,
                      width: isFocused ? 2.5 : 1.5,
                    ),
                    boxShadow: isFocused
                        ? [
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.3),
                              blurRadius: 8,
                              spreadRadius: 2,
                            )
                          ]
                        : [],
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        'https://i.pravatar.cc/150?img=${circleIndex * 10 + avatarIndex}',
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
        avatarIndex++;
      }
    }

    return Stack(children: avatars);
  }
}
