import 'package:flutter/material.dart';
import 'package:voalis_teste/data/models/cluster_model.dart';

class ClusterCircleWidget extends StatelessWidget {
  final ClusterModel cluster;
  final bool isFocused;
  final VoidCallback onTap;
  final double size;

  const ClusterCircleWidget({
    super.key,
    required this.cluster,
    required this.isFocused,
    required this.onTap,
    this.size = 300,
  });

  Color _getColorFromHex(String hexColor) {
    final hex = hexColor.replaceAll('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }

  @override
  Widget build(BuildContext context) {
    final clusterColor = _getColorFromHex(cluster.colorHex);

    return GestureDetector(
      onTap: isFocused ? onTap : null,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: clusterColor.withOpacity(isFocused ? 0.8 : 0.5),
            width: isFocused ? 3 : 2,
          ),
          boxShadow: isFocused
              ? [
                  BoxShadow(
                    color: clusterColor.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]
              : [],
        ),
        child: ClipOval(
          child: Stack(
            children: [
              // Emoji e nome do cluster no topo
              Positioned(
                top: size * 0.12,
                left: 0,
                right: 0,
                child: Center(
                  child: Column(
                    children: [
                      Text(
                        cluster.iconEmoji,
                        style: TextStyle(
                            fontSize: isFocused ? size * 0.15 : size * 0.12),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          cluster.name,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isFocused ? 18 : 12,
                            fontWeight:
                                isFocused ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Avatares na metade inferior
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                height: size * 0.5,
                child: _buildAvatarGrid(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    final avatarSize = size * 0.12;
    final spacing = size * 0.02;

    // Limitar a 12 avatares para não sobrecarregar
    final displayMembers = cluster.members.take(12).toList();

    return Padding(
      padding: EdgeInsets.all(size * 0.08),
      child: Wrap(
        alignment: WrapAlignment.center,
        spacing: spacing,
        runSpacing: spacing,
        children: displayMembers.map((member) {
          return Container(
            width: avatarSize,
            height: avatarSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: member.isOnline ? Colors.greenAccent : Colors.white,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 4,
                ),
              ],
              image: DecorationImage(
                fit: BoxFit.cover,
                image: NetworkImage(member.avatarUrl),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
