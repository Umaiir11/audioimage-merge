class Post {
  final String id;
  final String imagePath;
  final String audioPath;
  final DateTime createdAt;

  Post({
    required this.id,
    required this.imagePath,
    required this.audioPath,
    required this.createdAt,
  });

  // Convert Post to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'audioPath': audioPath,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  // Create Post from JSON
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      imagePath: json['imagePath'],
      audioPath: json['audioPath'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
