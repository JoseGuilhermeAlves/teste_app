import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const Color kBackground = Color(0xFF1A1A2E);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: kBackground,
        body: const SafeArea(
          child: ConcentricCircles(),
        ),
      ),
    );
  }
}

class CircleData {
  final String label;
  final double radius;
  final int avatarCount;

  CircleData({
    required this.label,
    required this.radius,
    required this.avatarCount,
  });
}

class ConcentricCircles extends StatefulWidget {
  const ConcentricCircles({super.key});

  @override
  State<ConcentricCircles> createState() => _ConcentricCirclesState();
}

class _ConcentricCirclesState extends State<ConcentricCircles> {
  final List<CircleData> circles = [
    CircleData(label: "Círculo 1", radius: 100, avatarCount: 5),
    CircleData(label: "Círculo 2", radius: 150, avatarCount: 8),
    CircleData(label: "Círculo 3", radius: 220, avatarCount: 12),
  ];

  @override
  Widget build(BuildContext context) {
    final biggest = circles.last.radius * 2;

    return Column(
      children: [
        // Botões acima
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // lógica de editar
                },
                child: const Text("Edit Circle"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    circles.add(
                      CircleData(
                        label: "Novo",
                        radius: circles.last.radius + 70,
                        avatarCount: 6,
                      ),
                    );
                  });
                },
                child: const Text("Add Circle"),
              ),
            ],
          ),
        ),

        // Área com scroll para círculos
        Expanded(
          child: SingleChildScrollView(
            child: SizedBox(
              height: biggest + 100, // espaço suficiente para o maior círculo
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  for (int i = 0; i < circles.length; i++)
                    Positioned(
                      top: 0,
                      child: _buildCircle(circles[i], i),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCircle(CircleData circle, int index) {
    return Container(
      width: circle.radius * 2,
      height: circle.radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
      ),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Label
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
          // Avatares na parte inferior
          ..._buildBottomCluster(circle, index),
        ],
      ),
    );
  }

  List<Widget> _buildBottomCluster(CircleData circle, int circleIndex) {
    double avatarSize = 40;
    double radius = circle.radius - avatarSize;
    int count = circle.avatarCount;

    List<Widget> avatars = [];

    // arco inferior (30° até 150°)
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

    return avatars;
  }
}
