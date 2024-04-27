class Artwork {
  String id;
  String userId;
  String title;
  String description;
  String imageUrl;
  List<String> comments;
  String type;

  Artwork({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.comments = const [],
    this.type = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'comments': comments,
      'type': type,
    };
  }

  factory Artwork.fromMap(Map<String, dynamic> map, String documentId) {
    return Artwork(
      id: documentId,
      userId: map['userId'],
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      comments: List<String>.from(map['comments'] ?? []),
      type: map['type'] ?? '',
    );
  }
}
