import 'user_profile.dart';

class Comment {
  final String id;
  final String animeId;
  final String userId;
  final String content;
  final DateTime createdAt;
  final UserProfile? user;

  Comment({
    required this.id,
    required this.animeId,
    required this.userId,
    required this.content,
    required this.createdAt,
    this.user,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      animeId: json['anime_id'],
      userId: json['user_id'],
      content: json['content'],
      createdAt: DateTime.parse(json['created_at']),
      user: json['profiles'] != null ? UserProfile.fromJson(json['profiles']) : null,
    );
  }
}
