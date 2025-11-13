import 'dart:math';
import 'package:flutter/material.dart';
import 'package:voalis_teste/core/constants/colors.dart';
import 'package:voalis_teste/data/models/cluster_model.dart';
import 'package:voalis_teste/data/repositories/cluster_repository.dart';
import 'package:voalis_teste/presentation/widgets/cluster_detail_page.dart';

class NetworkGraphView extends StatefulWidget {
  const NetworkGraphView({super.key});

  @override
  State<NetworkGraphView> createState() => _NetworkGraphViewState();
}

class _NetworkGraphViewState extends State<NetworkGraphView>
    with SingleTickerProviderStateMixin {
  final ClusterRepository _repository = ClusterRepository();
  List<ClusterModel> clusters = [];
  bool isLoading = true;
  late AnimationController _animationController;
  ClusterModel? selectedCluster;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
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
    _animationController.dispose();
    super.dispose();
  }

  Color _getColorFromHex(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
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

    if (selectedCluster != null) {
      return ClusterDetailPage(
        cluster: selectedCluster!,
        onBack: () => setState(() => selectedCluster = null),
      );
    }

    return Scaffold(
      backgroundColor: kBackground,
      body: SafeArea(
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
                  const Text(
                    'Network Graph',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Network graph
            Expanded(
              child: AnimatedBuilder(
                animation: _animationController,
                builder: (context, child) {
                  return CustomPaint(
                    painter: NetworkGraphPainter(
                      clusters: clusters,
                      animationValue: _animationController.value,
                      getColorFromHex: _getColorFromHex,
                    ),
                    child: Stack(
                      children: clusters.asMap().entries.map((entry) {
                        return _buildClusterNode(
                          entry.value,
                          entry.key,
                          clusters.length,
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ),

            // Legend
            Container(
              margin: const EdgeInsets.all(16),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.white.withOpacity(0.1),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildLegendItem(
                    Icons.circle,
                    'Node Size',
                    'Member Count',
                    Colors.blueAccent,
                  ),
                  _buildLegendItem(
                    Icons.timeline,
                    'Connections',
                    'Related Clusters',
                    Colors.purpleAccent,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLegendItem(
    IconData icon,
    String title,
    String subtitle,
    Color color,
  ) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: Colors.white.withOpacity(0.6),
                fontSize: 10,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildClusterNode(ClusterModel cluster, int index, int totalClusters) {
    final size = MediaQuery.of(context).size;
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    // Posicionar em círculo
    final angle = (2 * pi * index) / totalClusters;
    final radius = min(size.width, size.height) * 0.3;
    final x = centerX + radius * cos(angle);
    final y = centerY + radius * sin(angle);

    // Tamanho baseado em membros
    final nodeSize = 40.0 + (cluster.memberCount * 2);
    final clusterColor = _getColorFromHex(cluster.colorHex);

    return Positioned(
      left: x - (nodeSize / 2),
      top: y - (nodeSize / 2),
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0.0, end: 1.0),
        duration: Duration(milliseconds: 800 + (index * 100)),
        curve: Curves.elasticOut,
        builder: (context, value, child) {
          return Transform.scale(
            scale: value,
            child: GestureDetector(
              onTap: () => setState(() => selectedCluster = cluster),
              child: Container(
                width: nodeSize,
                height: nodeSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      clusterColor.withOpacity(0.8),
                      clusterColor.withOpacity(0.3),
                    ],
                  ),
                  border: Border.all(
                    color: clusterColor,
                    width: 3,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: clusterColor.withOpacity(0.5),
                      blurRadius: 15,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        cluster.iconEmoji,
                        style: TextStyle(fontSize: nodeSize * 0.4),
                      ),
                      Text(
                        '${cluster.memberCount}',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: nodeSize * 0.2,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NetworkGraphPainter extends CustomPainter {
  final List<ClusterModel> clusters;
  final double animationValue;
  final Color Function(String) getColorFromHex;

  NetworkGraphPainter({
    required this.clusters,
    required this.animationValue,
    required this.getColorFromHex,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = min(size.width, size.height) * 0.3;

    // Desenhar conexões entre clusters
    for (int i = 0; i < clusters.length; i++) {
      final angle1 = (2 * pi * i) / clusters.length;
      final x1 = centerX + radius * cos(angle1);
      final y1 = centerY + radius * sin(angle1);

      // Conectar ao próximo cluster
      final nextIndex = (i + 1) % clusters.length;
      final angle2 = (2 * pi * nextIndex) / clusters.length;
      final x2 = centerX + radius * cos(angle2);
      final y2 = centerY + radius * sin(angle2);

      final paint = Paint()
        ..color = Colors.white.withOpacity(0.1)
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(x1, y1), Offset(x2, y2), paint);

      // Conexão animada
      final progress = (animationValue + (i / clusters.length)) % 1.0;
      final animX = x1 + (x2 - x1) * progress;
      final animY = y1 + (y2 - y1) * progress;

      final animPaint = Paint()
        ..color = getColorFromHex(clusters[i].colorHex).withOpacity(0.6)
        ..strokeWidth = 3;

      canvas.drawCircle(Offset(animX, animY), 3, animPaint);
    }

    // Conectar todos ao centro
    for (int i = 0; i < clusters.length; i++) {
      final angle = (2 * pi * i) / clusters.length;
      final x = centerX + radius * cos(angle);
      final y = centerY + radius * sin(angle);

      final paint = Paint()
        ..color = Colors.white.withOpacity(0.05)
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawLine(Offset(x, y), Offset(centerX, centerY), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
