import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

const Color kBackground = Color(0xFF000000); // Fundo preto puro

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
  final ScrollController _scrollController = ScrollController();
  final List<CircleData> circles = [
    CircleData(label: "Círculo 1", radius: 100, avatarCount: 5),
    CircleData(label: "Círculo 2", radius: 150, avatarCount: 8),
    CircleData(label: "Círculo 3", radius: 220, avatarCount: 12),
  ];

  int? selectedCircleIndex;
  double scrollOffset = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    setState(() {
      scrollOffset = _scrollController.offset;
    });
  }

  double _calculateScale(int index) {
    // Calcula a escala baseada na posição do scroll
    // Círculos menores ficam ainda menores conforme scrollamos
    double maxOffset = 300.0;
    double progress = (scrollOffset / maxOffset).clamp(0.0, 1.0);

    // Escala diferente para cada círculo
    double baseScale = 1.0 - (progress * 0.5);
    double indexFactor = index / circles.length;
    return baseScale - (indexFactor * progress * 0.3);
  }

  Color _calculateBorderColor(int index) {
    // Calcula a cor da borda baseada no scroll e índice
    double maxOffset = 300.0;
    double progress = (scrollOffset / maxOffset).clamp(0.0, 1.0);

    // Círculos maiores (índice maior) ficam mais brilhantes conforme o scroll
    double glowIntensity = 0.0;
    if (index == circles.length - 1) {
      // Último círculo (maior) fica mais brilhante
      glowIntensity = progress;
    } else if (index == circles.length - 2 && circles.length > 2) {
      // Penúltimo círculo tem brilho médio
      glowIntensity = progress * 0.6;
    } else {
      // Círculos menores perdem brilho
      glowIntensity = (1.0 - progress) * 0.5;
    }

    // Cor base azulada que vai de azul escuro a azul brilhante/ciano
    return Color.lerp(
      const Color(0xFF1E3A8A), // Azul escuro
      const Color(0xFF00D4FF), // Ciano brilhante
      glowIntensity,
    )!;
  }

  double _calculateBorderWidth(int index) {
    // Borda fica mais grossa para círculos em foco
    double maxOffset = 300.0;
    double progress = (scrollOffset / maxOffset).clamp(0.0, 1.0);

    if (index == circles.length - 1) {
      return 2.0 + (progress * 2.0); // 2 a 4 pixels
    } else {
      return 2.0 - (progress * 0.5); // 2 a 1.5 pixels
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se um círculo está selecionado, mostra apenas ele
    if (selectedCircleIndex != null) {
      return _buildSelectedCircleView();
    }

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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: const Color(0xFF00D4FF),
                  side: const BorderSide(color: Color(0xFF00D4FF), width: 1),
                ),
                onPressed: () {
                  // lógica de editar
                },
                child: const Text("Edit Circle"),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: const Color(0xFF00D4FF),
                  side: const BorderSide(color: Color(0xFF00D4FF), width: 1),
                ),
                onPressed: () {
                  setState(() {
                    circles.add(
                      CircleData(
                        label: "Novo ${circles.length + 1}",
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
            controller: _scrollController,
            child: SizedBox(
              height: biggest + 300, // espaço extra para scroll
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  for (int i = 0; i < circles.length; i++)
                    Positioned(
                      top: 50, // posição inicial mais baixa
                      child: Transform.scale(
                        scale: _calculateScale(i),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCircleIndex = i;
                            });
                          },
                          child: _buildCircle(circles[i], i),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSelectedCircleView() {
    final circle = circles[selectedCircleIndex!];
    final screenSize = MediaQuery.of(context).size;
    final circleSize = screenSize.width * 0.85; // Círculo ocupa 85% da largura

    return Column(
      children: [
        // Botão voltar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Color(0xFF00D4FF)),
                onPressed: () {
                  setState(() {
                    selectedCircleIndex = null;
                  });
                },
              ),
              Text(
                circle.label,
                style: const TextStyle(
                  color: Color(0xFF00D4FF),
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(
                      color: Color(0xFF00D4FF),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Círculo destacado com lista dentro
        Expanded(
          child: Center(
            child: Container(
              width: circleSize,
              height: circleSize,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00D4FF), width: 4),
                // Círculo transparente
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00D4FF).withOpacity(0.5),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(circleSize / 2),
                child: Column(
                  children: [
                    // Título dentro do círculo
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                      child: Text(
                        circle.label,
                        style: const TextStyle(
                          color: Color(0xFF00D4FF),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Color(0xFF00D4FF),
                              blurRadius: 10,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Lista de avatares dentro do círculo
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: ListView.builder(
                          padding: const EdgeInsets.only(bottom: 20),
                          itemCount: circle.avatarCount,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: const Color(0xFF00D4FF).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color:
                                      const Color(0xFF00D4FF).withOpacity(0.3),
                                  width: 1,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    // Avatar
                                    Container(
                                      width: 45,
                                      height: 45,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: const Color(0xFF00D4FF),
                                          width: 2,
                                        ),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            'https://i.pravatar.cc/150?img=${selectedCircleIndex! * 10 + index}',
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    // Nome
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Membro ${index + 1}',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          Text(
                                            'Ativo',
                                            style: TextStyle(
                                              color: const Color(0xFF00D4FF)
                                                  .withOpacity(0.6),
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    // Ícone de ação
                                    IconButton(
                                      icon: Icon(
                                        Icons.more_horiz,
                                        color: const Color(0xFF00D4FF)
                                            .withOpacity(0.7),
                                      ),
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
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
        border: Border.all(
          color: _calculateBorderColor(index),
          width: _calculateBorderWidth(index),
        ),
        // Sem preenchimento - totalmente transparente
        boxShadow: [
          BoxShadow(
            color: _calculateBorderColor(index).withOpacity(0.3),
            blurRadius: _calculateBorderWidth(index) * 4,
            spreadRadius: 0,
          ),
        ],
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
              style: TextStyle(
                color: _calculateBorderColor(index),
                fontWeight: FontWeight.bold,
                fontSize: 14,
                shadows: [
                  Shadow(
                    color: _calculateBorderColor(index).withOpacity(0.8),
                    blurRadius: 8,
                  ),
                ],
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
    // Tamanho do avatar ajusta com base na escala do círculo
    double scale = _calculateScale(circleIndex);
    double baseAvatarSize = 40;
    double avatarSize =
        baseAvatarSize * max(scale, 0.5); // Mínimo de 50% do tamanho

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
            border: Border.all(
              color: _calculateBorderColor(circleIndex),
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: _calculateBorderColor(circleIndex).withOpacity(0.5),
                blurRadius: 8,
                spreadRadius: 0,
              ),
            ],
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
