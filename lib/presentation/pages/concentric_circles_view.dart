import 'package:flutter/material.dart';
import 'package:cluster_visualizer/core/constants/colors.dart';
import 'package:cluster_visualizer/data/models/cluster_model.dart';
import 'package:cluster_visualizer/data/repositories/cluster_repository.dart';
import 'package:cluster_visualizer/presentation/widgets/cluster_circle_widget.dart';
import 'package:cluster_visualizer/presentation/widgets/cluster_detail_page.dart';

class ConcentricCirclesView extends StatefulWidget {
  const ConcentricCirclesView({super.key});

  @override
  State<ConcentricCirclesView> createState() => _ConcentricCirclesViewState();
}

class _ConcentricCirclesViewState extends State<ConcentricCirclesView>
    with TickerProviderStateMixin {
  late AnimationController _transitionController;
  final ClusterRepository _repository = ClusterRepository();

  List<ClusterModel> clusters = [];
  bool isLoading = true;
  int? selectedClusterIndex;
  int currentFocusedIndex = 0;
  bool _isAnimating = false;
  int _animationDirection = 1;

  @override
  void initState() {
    super.initState();
    _transitionController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _loadClusters();
  }

  Future<void> _loadClusters() async {
    final loadedClusters = await _repository.getAllClusters();
    setState(() {
      clusters = loadedClusters;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _transitionController.dispose();
    super.dispose();
  }

  void _goToNext() {
    if (_isAnimating || currentFocusedIndex >= clusters.length - 1) return;

    setState(() {
      _isAnimating = true;
      _animationDirection = 1;
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
      _animationDirection = -1;
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
    if (isLoading) {
      return Scaffold(
        backgroundColor: kBackground,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    if (selectedClusterIndex != null) {
      return ClusterDetailPage(
        cluster: clusters[selectedClusterIndex!],
        onBack: () => setState(() => selectedClusterIndex = null),
      );
    }

    final screenSize = MediaQuery.of(context).size;
    final focusedCircleSize = screenSize.width * 0.85;

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragEnd: (details) {
            if (details.primaryVelocity! < -500) {
              _goToNext();
            } else if (details.primaryVelocity! > 500) {
              _goToPrevious();
            }
          },
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Concentric Circles',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              // Círculos concêntricos
              Expanded(
                child: AnimatedBuilder(
                  animation: _transitionController,
                  builder: (context, child) {
                    return Center(
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.none,
                        children: [
                          ...List.generate(clusters.length, (index) {
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
                  children: clusters.asMap().entries.map((entry) {
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
        ),
      ),
    );
  }

  Widget _buildAnimatedCircle(int index, double focusedSize, double progress) {
    final t = Curves.easeInOutCubic.transform(progress);
    final relation = index - currentFocusedIndex;

    double startSize;
    double startY;
    double startOpacity;

    double endSize;
    double endY;
    double endOpacity;

    bool isFocused = false;
    bool shouldShowContent = true;

    if (!_isAnimating) {
      if (relation < 0) {
        final distance = relation.abs();
        startSize = endSize =
            focusedSize * (0.22 - (distance * 0.03)).clamp(0.15, 0.22);
        startY =
            endY = -(focusedSize / 2) + (startSize / 2) + 40 + (distance * 15);
        startOpacity = endOpacity = 0.6;
      } else if (relation == 0) {
        startSize = endSize = focusedSize;
        startY = endY = 0;
        startOpacity = endOpacity = 1.0;
        isFocused = true;
      } else {
        final orbitLevel = relation;
        startSize = endSize = focusedSize * (1.0 + (orbitLevel * 0.4));
        startY = endY = 0;
        startOpacity = endOpacity = (0.5 / orbitLevel).clamp(0.15, 0.5);
        shouldShowContent = false;
      }
    } else {
      if (_animationDirection == 1) {
        if (relation == 0) {
          startSize = focusedSize;
          startY = 0;
          startOpacity = 1.0;

          final smallSize = focusedSize * 0.22;
          endSize = smallSize;
          endY = -(focusedSize / 2) + (smallSize / 2) + 40;
          endOpacity = 0.6;
          isFocused = true;
        } else if (relation == 1) {
          startSize = focusedSize * 1.4;
          startY = 0;
          startOpacity = 0.5;

          endSize = focusedSize;
          endY = 0;
          endOpacity = 1.0;
          shouldShowContent = true;
        } else if (relation > 1) {
          final orbitLevel = relation;
          startSize = focusedSize * (1.0 + (orbitLevel * 0.4));
          startY = 0;
          startOpacity = (0.5 / orbitLevel).clamp(0.15, 0.5);

          endSize = focusedSize * (1.0 + ((orbitLevel - 1) * 0.4));
          endY = 0;
          endOpacity = (0.5 / (orbitLevel - 1)).clamp(0.15, 0.5);
          shouldShowContent = false;
        } else if (relation < 0) {
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
          startSize = endSize = focusedSize;
          startY = endY = 0;
          startOpacity = endOpacity = 1.0;
          shouldShowContent = false;
        }
      } else {
        if (relation == 0) {
          startSize = focusedSize;
          startY = 0;
          startOpacity = 1.0;

          endSize = focusedSize * 1.4;
          endY = 0;
          endOpacity = 0.5;
          isFocused = true;
          shouldShowContent = false;
        } else if (relation == -1) {
          final smallSize = focusedSize * 0.22;
          startSize = smallSize;
          startY = -(focusedSize / 2) + (smallSize / 2) + 40;
          startOpacity = 0.6;

          endSize = focusedSize;
          endY = 0;
          endOpacity = 1.0;
          shouldShowContent = true;
        } else if (relation < -1) {
          final distance = relation.abs();
          startSize =
              focusedSize * (0.22 - (distance * 0.03)).clamp(0.15, 0.22);
          startY = -(focusedSize / 2) + (startSize / 2) + 40 + (distance * 15);
          startOpacity = 0.6;

          endSize =
              focusedSize * (0.22 - ((distance - 1) * 0.03)).clamp(0.15, 0.22);
          endY =
              -(focusedSize / 2) + (endSize / 2) + 40 + ((distance - 1) * 15);
          endOpacity = 0.6;
        } else if (relation > 0) {
          final orbitLevel = relation;
          startSize = focusedSize * (1.0 + ((orbitLevel - 1) * 0.4));
          startY = 0;
          startOpacity = (0.5 / (orbitLevel - 1)).clamp(0.15, 0.5);

          endSize = focusedSize * (1.0 + (orbitLevel * 0.4));
          endY = 0;
          endOpacity = (0.5 / orbitLevel).clamp(0.15, 0.5);
          shouldShowContent = false;
        } else {
          startSize = endSize = focusedSize;
          startY = endY = 0;
          startOpacity = endOpacity = 1.0;
          shouldShowContent = false;
        }
      }
    }

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
            ? ClusterCircleWidget(
                cluster: clusters[index],
                isFocused: isFocused,
                onTap: () {
                  if (isFocused && !_isAnimating) {
                    setState(() => selectedClusterIndex = index);
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
