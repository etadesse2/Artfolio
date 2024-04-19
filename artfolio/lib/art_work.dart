//Art work model

class Artwork {
  String id;
  String title;
  String description;
  String imageUrl;
  List<String> comments;

  Artwork(
      {required this.id,
      required this.title,
      required this.description,
      required this.imageUrl,
      this.comments = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'imageUrl': imageUrl,
      'comments': comments,
    };
  }

  factory Artwork.fromMap(Map<String, dynamic> map, String documentId) {
    return Artwork(
      id: documentId,
      title: map['title'],
      description: map['description'],
      imageUrl: map['imageUrl'],
      comments: List<String>.from(map['comments']),
    );
  }
}
