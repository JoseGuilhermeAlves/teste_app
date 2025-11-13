import 'package:flutter/material.dart';
import 'package:voalis_teste/core/constants/colors.dart';
import 'package:voalis_teste/data/models/circle_model.dart';
import 'package:voalis_teste/presentation/widgets/circle_detail_page.dart';
import 'package:voalis_teste/presentation/widgets/circle_widget.dart';

class CirclesPage extends StatefulWidget {
  const CirclesPage({super.key});

  @override
  State<CirclesPage> createState() => _CirclesPageState();
}

class _CirclesPageState extends State<CirclesPage>
    with TickerProviderStateMixin {
  late AnimationController _transitionController;

  final List<CircleModel> circles = [
    CircleModel(label: "Círculo 1", radius: 150, avatarCount: 5),
    CircleModel(label: "Círculo 2", radius: 150, avatarCount: 8),
    CircleModel(label: "Círculo 3", radius: 150, avatarCount: 12),
  ];

  int? selectedCircleIndex;
  int currentFocusedIndex = 0;
  bool _isAnimating = false;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (_isAnimating || currentFocusedIndex >= circles.length - 1) return;

    setState(() {
      _isAnimating = true;
    });

    _transitionController.forward(from: 0.0).then((_) {
      setState(() {
        currentFocusedIndex++;
        _isAnimating = false;
      });
      _transitionController.value = 0.0;
    });
  }

  void _goToPrevious() {
    if (_isAnimating || currentFocusedIndex <= 0) return;

    setState(() {
      _isAnimating = true;
    });

    _transitionController.forward(from: 0.0).then((_) {
      setState(() {
        currentFocusedIndex--;
        _isAnimating = false;
      });
      _transitionController.value = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (selectedCircleIndex != null) {
      return CircleDetailPage(
        circle: circles[selectedCircleIndex!],
        onBack: () => setState(() => selectedCircleIndex = null),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final focusedCircleSize = screenSize.width * 0.85;

    return GestureDetector(
      onVerticalDragEnd: (details) {
        if (details.primaryVelocity! < -500) {
          _goToNext();
        } else if (details.primaryVelocity! > 500) {
          _goToPrevious();
        }
      },
      child: Column(
        children: [
          // Botões superiores
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.edit, color: kButtonTextColor, size: 20),
                  label: Text("Edit Circle",
                      style: TextStyle(color: kButtonTextColor)),
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonBackground,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton.icon(
                  icon:
                      Icon(Icons.add_circle, color: kButtonTextColor, size: 20),
                  label: Text("Add Circle",
                      style: TextStyle(color: kButtonTextColor)),
                  onPressed: () {
                    setState(() {
                      circles.add(CircleModel(
                        label: "Círculo ${circles.length + 1}",
                        radius: 150,
                        avatarCount: 5 + circles.length * 2,
                      ));
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kButtonBackground,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ],
            ),
          ),

          // Área dos círculos com transição FLUIDA
          Expanded(
            child: AnimatedBuilder(
              animation: _transitionController,
              builder: (context, child) {
                return Center(
                  child: Stack(
                    alignment: Alignment.center,
                    clipBehavior: Clip.none,
                    children: [
                      ...List.generate(circles.length, (index) {
                        return _buildAnimatedCircle(
                          index,
                          focusedCircleSize,
                          _transitionController.value,
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),

          // Indicador de página
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: circles.asMap().entries.map((entry) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: currentFocusedIndex == entry.key ? 24.0 : 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4),
                    color: currentFocusedIndex == entry.key
                        ? Colors.white
                        : Colors.white.withOpacity(0.3),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCircle(int index, double focusedSize, double progress) {
    final t = Curves.easeInOutCubic.transform(progress);
    final relation = index - currentFocusedIndex;

    // Posições e tamanhos INICIAIS (antes da animação)
    double startSize;
    double startY;
    double startOpacity;

    // Posições e tamanhos FINAIS (depois da animação)
    double endSize;
    double endY;
    double endOpacity;

    bool isFocused = false;
    bool shouldShowContent = true;

    if (!_isAnimating) {
      // Estado estável (sem animação)
      if (relation < 0) {
        // Círculos que já passaram - pequenos no topo
        final distance = relation.abs();
        startSize = endSize =
            focusedSize * (0.22 - (distance * 0.03)).clamp(0.15, 0.22);
        startY =
            endY = -(focusedSize / 2) + (startSize / 2) + 40 + (distance * 15);
        startOpacity = endOpacity = 0.6;
      } else if (relation == 0) {
        // Círculo focado
        startSize = endSize = focusedSize;
        startY = endY = 0;
        startOpacity = endOpacity = 1.0;
        isFocused = true;
      } else {
        // TODAS as órbitas externas (1, 2, 3, ...)
        final orbitLevel = relation;
        startSize = endSize = focusedSize * (1.0 + (orbitLevel * 0.4));
        startY = endY = 0;
        startOpacity = endOpacity = (0.5 / orbitLevel).clamp(0.15, 0.5);
        shouldShowContent = false;
      }
    } else {
      // Durante a animação
      if (relation == 0) {
        // Círculo que ESTÁ focado e vai DIMINUIR e SUBIR
        startSize = focusedSize;
        startY = 0;
        startOpacity = 1.0;

        final smallSize = focusedSize * 0.22;
        endSize = smallSize;
        endY = -(focusedSize / 2) + (smallSize / 2) + 40;
        endOpacity = 0.6;
        isFocused = true;
      } else if (relation == 1) {
        // Próximo círculo que vai ENCOLHER e vir pro CENTRO
        startSize = focusedSize * 1.4;
        startY = 0;
        startOpacity = 0.5;

        endSize = focusedSize;
        endY = 0;
        endOpacity = 1.0;
        shouldShowContent = true;
      } else if (relation > 1) {
        // Círculos que vão diminuir uma órbita (relation 2->1, 3->2, etc)
        final orbitLevel = relation;
        startSize = focusedSize * (1.0 + (orbitLevel * 0.4));
        startY = 0;
        startOpacity = (0.5 / orbitLevel).clamp(0.15, 0.5);

        endSize = focusedSize * (1.0 + ((orbitLevel - 1) * 0.4));
        endY = 0;
        endOpacity = (0.5 / (orbitLevel - 1)).clamp(0.15, 0.5);
        shouldShowContent = false;
      } else if (relation < 0) {
        // Círculos pequenos que sobem mais
        final distance = relation.abs();
        startSize =
            focusedSize * (0.22 - ((distance - 1) * 0.03)).clamp(0.15, 0.22);
        startY =
            -(focusedSize / 2) + (startSize / 2) + 40 + ((distance - 1) * 15);
        startOpacity = 0.6;

        endSize = focusedSize * (0.22 - (distance * 0.03)).clamp(0.15, 0.22);
        endY = -(focusedSize / 2) + (endSize / 2) + 40 + (distance * 15);
        endOpacity = 0.6;
      } else {
        // Fallback
        startSize = endSize = focusedSize;
        startY = endY = 0;
        startOpacity = endOpacity = 1.0;
        shouldShowContent = false;
      }
    }

    // Interpolar valores durante a animação
    final currentSize = startSize + ((endSize - startSize) * t);
    final currentY = startY + ((endY - startY) * t);
    final currentOpacity = startOpacity + ((endOpacity - startOpacity) * t);

    return Positioned(
      left: (MediaQuery.of(context).size.width / 2) - (currentSize / 2),
      top: (MediaQuery.of(context).size.height / 2) -
          (currentSize / 2) +
          currentY -
          80,
      child: Opacity(
        opacity: currentOpacity,
        child: shouldShowContent
            ? CircleWidget(
                circle: circles[index],
                index: index,
                isFocused: isFocused,
                onTap: () {
                  if (isFocused && !_isAnimating) {
                    setState(() => selectedCircleIndex = index);
                  }
                },
                size: currentSize,
              )
            : Container(
                width: currentSize,
                height: currentSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withOpacity(currentOpacity),
                    width: 2,
                  ),
                ),
              ),
      ),
    );
  }
}
