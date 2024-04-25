class Artwork {
  String id;
  String userId; // Add this field to store the creator's user ID
  String title;
  String description;
  String imageUrl;
  List<String> comments;
  String type; // Field for artwork type

  Artwork({
    required this.id,
    required this.userId, // Make this required
    required this.title,
    required this.description,
    required this.imageUrl,
    this.comments = const [],
    this.type = '',
    // Default to empty or a predefined category
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId, // Include userId in the map
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
      userId: map['userId'], // Extract userId from the map
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      comments: List<String>.from(map['comments'] ?? []),
      type: map['type'] ?? '',
    );
  }
}
