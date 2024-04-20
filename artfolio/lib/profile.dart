// File: profile.dart
class Profile {
  String id;
  String firstName;
  String lastName;
  String email;
  String profileImageUrl;
  List<dynamic> artworks;

  Profile(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      this.profileImageUrl = '',
      this.artworks = const []});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'artworks': artworks,
    };
  }

  factory Profile.fromMap(Map<String, dynamic> map, String id) {
    return Profile(
      id: id,
      firstName: map['firstName'] ?? '',
      lastName: map['lastName'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      artworks: map['artworks'] ?? [],
    );
  }
}
