import 'dart:convert';
import 'package:cluster_visualizer/data/datasources/fake_clusters_data.dart';
import 'package:cluster_visualizer/data/models/cluster_model.dart';

class ClusterRepository {
  List<ClusterModel>? _cachedClusters;

  Future<List<ClusterModel>> getAllClusters() async {
    if (_cachedClusters != null) {
      return _cachedClusters!;
    }

    // Simular delay de rede
    await Future.delayed(const Duration(milliseconds: 500));

    final Map<String, dynamic> jsonData = json.decode(fakeClustersJson);
    final List<dynamic> clustersJson = jsonData['clusters'];

    _cachedClusters =
        clustersJson.map((json) => ClusterModel.fromJson(json)).toList();

    return _cachedClusters!;
  }

  Future<ClusterModel?> getClusterById(String id) async {
    final clusters = await getAllClusters();
    try {
      return clusters.firstWhere((cluster) => cluster.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<List<ClusterModel>> getClustersByCategory(String category) async {
    final clusters = await getAllClusters();
    return clusters.where((cluster) => cluster.category == category).toList();
  }

  List<String> getCategories() {
    if (_cachedClusters == null) return [];
    return _cachedClusters!.map((cluster) => cluster.category).toSet().toList();
  }

  void clearCache() {
    _cachedClusters = null;
  }
}
