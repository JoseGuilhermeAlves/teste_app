class ClusterModel {
  final String id;
  final String name;
  final String description;
  final String category;
  final int memberCount;
  final List<MemberModel> members;
  final DateTime createdAt;
  final String iconEmoji;
  final String colorHex;

  ClusterModel({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.memberCount,
    required this.members,
    required this.createdAt,
    required this.iconEmoji,
    required this.colorHex,
  });

  factory ClusterModel.fromJson(Map<String, dynamic> json) {
    return ClusterModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      memberCount: json['memberCount'] as int,
      members: (json['members'] as List)
          .map((m) => MemberModel.fromJson(m))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      iconEmoji: json['iconEmoji'] as String,
      colorHex: json['colorHex'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'category': category,
      'memberCount': memberCount,
      'members': members.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'iconEmoji': iconEmoji,
      'colorHex': colorHex,
    };
  }
}

class MemberModel {
  final String id;
  final String name;
  final String role;
  final String avatarUrl;
  final bool isOnline;
  final DateTime joinedAt;

  MemberModel({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.isOnline,
    required this.joinedAt,
  });

  factory MemberModel.fromJson(Map<String, dynamic> json) {
    return MemberModel(
      id: json['id'] as String,
      name: json['name'] as String,
      role: json['role'] as String,
      avatarUrl: json['avatarUrl'] as String,
      isOnline: json['isOnline'] as bool,
      joinedAt: DateTime.parse(json['joinedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'role': role,
      'avatarUrl': avatarUrl,
      'isOnline': isOnline,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}
