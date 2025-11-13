import 'package:flutter/material.dart';
import 'package:cluster_visualizer/core/constants/colors.dart';
import 'package:cluster_visualizer/data/models/cluster_model.dart';
import 'package:cluster_visualizer/data/repositories/cluster_repository.dart';
import 'package:cluster_visualizer/presentation/widgets/cluster_detail_page.dart';
import 'package:intl/intl.dart';

class TimelineClusterView extends StatefulWidget {
  const TimelineClusterView({super.key});

  @override
  State<TimelineClusterView> createState() => _TimelineClusterViewState();
}

class _TimelineClusterViewState extends State<TimelineClusterView> {
  final ClusterRepository _repository = ClusterRepository();
  List<ClusterModel> clusters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadClusters();
  }

  Future<void> _loadClusters() async {
    final loadedClusters = await _repository.getAllClusters();
    // Ordenar por data de criação
    loadedClusters.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    setState(() {
      clusters = loadedClusters;
      isLoading = false;
    });
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
                    'Timeline View',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Timeline
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: clusters.length,
                itemBuilder: (context, index) {
                  final cluster = clusters[index];
                  final isLast = index == clusters.length - 1;
                  return _buildTimelineItem(cluster, isLast, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimelineItem(ClusterModel cluster, bool isLast, int index) {
    final clusterColor = _getColorFromHex(cluster.colorHex);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset((1 - value) * 50, 0),
          child: Opacity(
            opacity: value,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline line
                  SizedBox(
                    width: 60,
                    child: Column(
                      children: [
                        // Date
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: clusterColor.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: clusterColor.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            DateFormat.MMMd().format(cluster.createdAt),
                            style: TextStyle(
                              color: clusterColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        // Dot
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: clusterColor,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: kBackground,
                              width: 3,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: clusterColor.withOpacity(0.5),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                        // Line
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    clusterColor.withOpacity(0.5),
                                    clusterColor.withOpacity(0.1),
                                  ],
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 16),

                  // Content card
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ClusterDetailPage(
                                cluster: cluster,
                                onBack: () => Navigator.pop(context),
                              ),
                            ),
                          ),
                          borderRadius: BorderRadius.circular(16),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  clusterColor.withOpacity(0.2),
                                  clusterColor.withOpacity(0.05),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: clusterColor.withOpacity(0.3),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        cluster.iconEmoji,
                                        style: const TextStyle(fontSize: 28),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              cluster.name,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              cluster.category,
                                              style: TextStyle(
                                                color: clusterColor,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: clusterColor.withOpacity(0.2),
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.people,
                                              color: clusterColor,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${cluster.memberCount}',
                                              style: TextStyle(
                                                color: clusterColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    cluster.description,
                                    style: TextStyle(
                                      color: Colors.white.withOpacity(0.7),
                                      fontSize: 13,
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // Members preview
                                  Wrap(
                                    spacing: -8,
                                    children: List.generate(
                                      cluster.members.take(5).length,
                                      (i) => Container(
                                        width: 32,
                                        height: 32,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: kBackground,
                                            width: 2,
                                          ),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              cluster.members[i].avatarUrl,
                                            ),
                                          ),
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
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
