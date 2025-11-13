import 'package:flutter/material.dart';
import 'package:cluster_visualizer/core/constants/colors.dart';
import 'package:cluster_visualizer/data/models/cluster_model.dart';
import 'package:cluster_visualizer/data/repositories/cluster_repository.dart';
import 'package:cluster_visualizer/presentation/widgets/cluster_detail_page.dart';

class GridClusterView extends StatefulWidget {
  const GridClusterView({super.key});

  @override
  State<GridClusterView> createState() => _GridClusterViewState();
}

class _GridClusterViewState extends State<GridClusterView> {
  final ClusterRepository _repository = ClusterRepository();
  List<ClusterModel> clusters = [];
  bool isLoading = true;
  String? selectedCategory;

  @override
  void initState() {
    super.initState();
    _loadClusters();
  }

  Future<void> _loadClusters() async {
    final loadedClusters = await _repository.getAllClusters();
    setState(() {
      clusters = loadedClusters;
      isLoading = false;
    });
  }

  List<ClusterModel> get filteredClusters {
    if (selectedCategory == null) return clusters;
    return clusters
        .where((cluster) => cluster.category == selectedCategory)
        .toList();
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

    final categories = _repository.getCategories();

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
                    'Grid View',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            // Category filter
            SizedBox(
              height: 50,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _buildCategoryChip('All', selectedCategory == null),
                  ...categories.map(
                    (category) => _buildCategoryChip(
                      category,
                      selectedCategory == category,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Grid of clusters
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: filteredClusters.length,
                itemBuilder: (context, index) {
                  final cluster = filteredClusters[index];
                  return _buildClusterCard(cluster, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (selected) {
          setState(() {
            selectedCategory = selected && label != 'All' ? label : null;
          });
        },
        backgroundColor: Colors.white.withOpacity(0.1),
        selectedColor: Colors.blueAccent,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white70,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
        ),
        side: BorderSide(
          color: isSelected ? Colors.blueAccent : Colors.white.withOpacity(0.2),
        ),
      ),
    );
  }

  Widget _buildClusterCard(ClusterModel cluster, int index) {
    final clusterColor = _getColorFromHex(cluster.colorHex);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 400 + (index * 100)),
      curve: Curves.easeOutBack,
      builder: (context, value, child) {
        return Transform.scale(
          scale: value,
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
              borderRadius: BorderRadius.circular(20),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      clusterColor.withOpacity(0.3),
                      clusterColor.withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: clusterColor.withOpacity(0.3),
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            cluster.iconEmoji,
                            style: const TextStyle(fontSize: 32),
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: clusterColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${cluster.memberCount}',
                              style: TextStyle(
                                color: clusterColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        cluster.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        cluster.description,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 12,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // Avatar stack
                      SizedBox(
                        height: 30,
                        child: Stack(
                          children: List.generate(
                            cluster.members.take(4).length,
                            (i) => Positioned(
                              left: i * 20.0,
                              child: Container(
                                width: 30,
                                height: 30,
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
