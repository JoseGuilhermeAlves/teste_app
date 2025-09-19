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

class _CirclesPageState extends State<CirclesPage> {
  final ScrollController _scrollController = ScrollController();
  final List<CircleModel> circles = [
    CircleModel(label: "Círculo 1", radius: 100, avatarCount: 5),
    CircleModel(label: "Círculo 2", radius: 150, avatarCount: 8),
    CircleModel(label: "Círculo 3", radius: 220, avatarCount: 12),
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
    double maxOffset = 300.0;
    double progress = (scrollOffset / maxOffset).clamp(0.0, 1.0);
    double baseScale = 1.0 - (progress * 0.5);
    double indexFactor = index / circles.length;
    return baseScale - (indexFactor * progress * 0.3);
  }

  @override
  Widget build(BuildContext context) {
    if (selectedCircleIndex != null) {
      return CircleDetailPage(
        circle: circles[selectedCircleIndex!],
        onBack: () => setState(() => selectedCircleIndex = null),
      );
    }

    final biggest = circles.last.radius * 2;

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
                      label: "Novo ${circles.length + 1}",
                      radius: circles.last.radius + 70,
                      avatarCount: 6,
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
          child: SingleChildScrollView(
            controller: _scrollController,
            child: SizedBox(
              height: biggest + 300,
              child: Stack(
                alignment: Alignment.topCenter,
                clipBehavior: Clip.none,
                children: [
                  for (int i = 0; i < circles.length; i++)
                    Positioned(
                      top: 50,
                      child: Transform.scale(
                        scale: _calculateScale(i),
                        child: CircleWidget(
                          circle: circles[i],
                          index: i,
                          scale: _calculateScale(i),
                          onTap: () => setState(() => selectedCircleIndex = i),
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
}
