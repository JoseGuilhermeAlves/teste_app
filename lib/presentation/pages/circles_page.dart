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
  late PageController _pageController;
  late AnimationController _animationController;

  final List<CircleModel> circles = [
    CircleModel(label: "Círculo 1", radius: 100, avatarCount: 5),
    CircleModel(label: "Círculo 2", radius: 150, avatarCount: 8),
    CircleModel(label: "Círculo 3", radius: 220, avatarCount: 12),
  ];

  int? selectedCircleIndex;
  int currentFocusedIndex = 0;
  double pageValue = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 1.0);
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _pageController.addListener(() {
      setState(() {
        pageValue = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (selectedCircleIndex != null) {
      return CircleDetailPage(
        circle: circles[selectedCircleIndex!],
        onBack: () => setState(() => selectedCircleIndex = null),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                icon: Icon(Icons.add_circle, color: kButtonTextColor, size: 20),
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
                    Icon(Icons.bubble_chart, color: kButtonTextColor, size: 20),
                label: Text("More Circles",
                    style: TextStyle(color: kButtonTextColor)),
                onPressed: () {
                  setState(() {
                    circles.add(CircleModel(
                      label: "Círculo ${circles.length + 1}",
                      radius: 100 + (circles.length * 50).toDouble(),
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
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            itemCount: circles.length,
            onPageChanged: (index) {
              setState(() {
                currentFocusedIndex = index;
              });
            },
            itemBuilder: (context, index) {
              return Center(
                child: AnimatedBuilder(
                  animation: _pageController,
                  builder: (context, child) {
                    double value = 0.0;
                    if (_pageController.position.haveDimensions) {
                      value = index - (pageValue);
                      value = (1 - (value.abs() * 0.5)).clamp(0.0, 1.0);
                    } else {
                      value = index == 0 ? 1.0 : 0.5;
                    }

                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value.clamp(0.3, 1.0),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Círculos anteriores (menores)
                            for (int i = 0; i < index; i++)
                              if ((index - i) <=
                                  2) // Mostrar apenas os 2 anteriores
                                Opacity(
                                  opacity: 0.3,
                                  child: Container(
                                    width: circles[i].radius * 2,
                                    height: circles[i].radius * 2,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withOpacity(0.2),
                                        width: 1,
                                      ),
                                    ),
                                  ),
                                ),

                            // Círculo atual
                            GestureDetector(
                              onTap: index == currentFocusedIndex
                                  ? () => setState(
                                      () => selectedCircleIndex = index)
                                  : null,
                              child: CircleWidget(
                                circle: circles[index],
                                index: index,
                                isFocused: index == currentFocusedIndex,
                                scale: value,
                                onTap: () =>
                                    setState(() => selectedCircleIndex = index),
                              ),
                            ),

                            // Círculos posteriores (maiores)
                            for (int i = index + 1; i < circles.length; i++)
                              if ((i - index) <=
                                  2) // Mostrar apenas os 2 próximos
                                IgnorePointer(
                                  child: Opacity(
                                    opacity: 0.1,
                                    child: Container(
                                      width: circles[i].radius * 2,
                                      height: circles[i].radius * 2,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.1),
                                          width: 1,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                          ],
                        ),
                      ),
                    );
                  },
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
              return Container(
                width: 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: currentFocusedIndex == entry.key
                      ? Colors.white
                      : Colors.white.withOpacity(0.3),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
