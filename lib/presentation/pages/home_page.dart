import 'package:flutter/material.dart';
import 'package:cluster_visualizer/core/constants/colors.dart';
import 'package:cluster_visualizer/presentation/pages/network_graph_view.dart';
import 'package:cluster_visualizer/presentation/pages/concentric_circles_view.dart';
import 'package:cluster_visualizer/presentation/pages/grid_cluster_view.dart';
import 'package:cluster_visualizer/presentation/pages/timeline_cluster_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late AnimationController _titleAnimationController;
  late AnimationController _cardAnimationController;
  late Animation<double> _titleSlideAnimation;
  late Animation<double> _titleFadeAnimation;
  late Animation<double> _cardStaggerAnimation;

  final List<Map<String, dynamic>> _visualizations = [
    {
      'title': 'Concentric Circles',
      'subtitle': 'Interactive orbital cluster view',
      'icon': Icons.bubble_chart,
      'gradient': const [
        Color(0xFF667EEA),
        Color(0xFF764BA2),
      ],
      'page': const ConcentricCirclesView(),
      'particles': 8,
    },
    {
      'title': 'Grid View',
      'subtitle': 'Card-based cluster organization',
      'icon': Icons.grid_view,
      'gradient': const [
        Color(0xFFF093FB),
        Color(0xFFF5576C),
      ],
      'page': const GridClusterView(),
      'particles': 6,
    },
    {
      'title': 'Timeline',
      'subtitle': 'Chronological cluster evolution',
      'icon': Icons.timeline,
      'gradient': const [
        Color(0xFF4FACFE),
        Color(0xFF00F2FE),
      ],
      'page': const TimelineClusterView(),
      'particles': 10,
    },
    {
      'title': 'Network Graph',
      'subtitle': 'Connected nodes visualization',
      'icon': Icons.hub,
      'gradient': const [
        Color(0xFF43E97B),
        Color(0xFF38F9D7),
      ],
      'page': const NetworkGraphView(),
      'particles': 12,
    },
  ];

  @override
  void initState() {
    super.initState();

    _titleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _cardAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleSlideAnimation = Tween<double>(
      begin: -50,
      end: 0,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _titleFadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _titleAnimationController,
      curve: Curves.easeOut,
    ));

    _cardStaggerAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _cardAnimationController,
      curve: Curves.easeOut,
    ));

    _startAnimations();
  }

  void _startAnimations() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _titleAnimationController.forward();
    await Future.delayed(const Duration(milliseconds: 500));
    _cardAnimationController.forward();
  }

  @override
  void dispose() {
    _titleAnimationController.dispose();
    _cardAnimationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Animated Header
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: AnimatedBuilder(
                animation: _titleAnimationController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(0, _titleSlideAnimation.value),
                    child: Opacity(
                      opacity: _titleFadeAnimation.value,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                width: 12,
                                height: 12,
                                decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(6),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.blueAccent.withOpacity(0.5),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Cluster Visualizer',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: -0.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Choose your preferred visualization style to explore data clusters',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 16,
                              height: 1.4,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Animated Visualization Cards
            Expanded(
              child: AnimatedBuilder(
                animation: _cardAnimationController,
                builder: (context, child) {
                  return ListView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    itemCount: _visualizations.length,
                    itemBuilder: (context, index) {
                      final double animationValue =
                          (_cardStaggerAnimation.value *
                                      _visualizations.length -
                                  index)
                              .clamp(0, 1)
                              .toDouble();

                      return Transform.translate(
                        offset: Offset(0, 50 * (1 - animationValue)),
                        child: Opacity(
                          opacity: animationValue,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: _buildAnimatedVisualizationCard(
                              context: context,
                              title: _visualizations[index]['title'] as String,
                              subtitle:
                                  _visualizations[index]['subtitle'] as String,
                              icon: _visualizations[index]['icon'] as IconData,
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: _visualizations[index]['gradient']
                                    as List<Color>,
                              ),
                              particles:
                                  _visualizations[index]['particles'] as int,
                              onTap: () => _navigateWithTransition(
                                context,
                                _visualizations[index]['page'] as Widget,
                                index,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateWithTransition(BuildContext context, Widget page, int index) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 600),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOutCubic;

          var tween =
              Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
          var offsetAnimation = animation.drive(tween);

          return SlideTransition(
            position: offsetAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          );
        },
      ),
    );
  }

  Widget _buildAnimatedVisualizationCard({
    required BuildContext context,
    required String title,
    required String subtitle,
    required IconData icon,
    required Gradient gradient,
    required int particles,
    required VoidCallback onTap,
  }) {
    double cardScale = 1.0;
    bool isHovering = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return MouseRegion(
          onEnter: (_) => setState(() {
            isHovering = true;
            cardScale = 1.02;
          }),
          onExit: (_) => setState(() {
            isHovering = false;
            cardScale = 1.0;
          }),
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 300),
            tween: Tween<double>(
                begin: isHovering ? 1.0 : cardScale, end: cardScale),
            builder: (context, scale, child) {
              return Transform.scale(
                scale: scale,
                child: child,
              );
            },
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onTap,
                borderRadius: BorderRadius.circular(24),
                splashColor: Colors.white.withOpacity(0.1),
                highlightColor: Colors.white.withOpacity(0.05),
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    gradient: gradient,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Floating particles background
                      ...List.generate(particles, (index) {
                        return Positioned(
                          left:
                              (index * 30) % MediaQuery.of(context).size.width,
                          top: (index * 20) % 140,
                          child: Container(
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.3),
                              shape: BoxShape.circle,
                            ),
                          ),
                        );
                      }),

                      // Main content
                      Padding(
                        padding: const EdgeInsets.all(24),
                        child: Row(
                          children: [
                            // Animated Icon Container
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 500),
                              tween: Tween<double>(begin: 0, end: 1),
                              builder: (context, value, child) {
                                return Transform.rotate(
                                  angle: value * 2 * 3.14159,
                                  child: child,
                                );
                              },
                              child: Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: Colors.white.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 32,
                                ),
                              ),
                            ),

                            const SizedBox(width: 20),

                            // Text content
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    subtitle,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 14,
                                      height: 1.3,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Animated arrow
                            TweenAnimationBuilder<double>(
                              duration: const Duration(milliseconds: 400),
                              tween: Tween<double>(begin: 0, end: 1),
                              builder: (context, value, child) {
                                return Transform.translate(
                                  offset: Offset(value * 5, 0),
                                  child: Opacity(
                                    opacity: value,
                                    child: child,
                                  ),
                                );
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Shine effect
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.white.withOpacity(0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
