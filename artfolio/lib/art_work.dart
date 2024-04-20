class Artwork {
  String id;
  String title;
  String description;
  String imageUrl;
  List<String> comments;
  String type; // New field for artwork type

  Artwork({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    this.comments = const [],
    this.type = '', // Default to empty or a predefined category
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'comments': comments,
      'type': type, // Ensure this is included in your Firestore document
    };
  }

  factory Artwork.fromMap(Map<String, dynamic> map, String documentId) {
    return Artwork(
      id: documentId,
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      comments: List<String>.from(map['comments'] ?? []),
      type: map['type'] ?? '',
    );
  }
}
