class UserProfile {
  final String id;
  final String username;
  final String bio;
  final String profilePictureUrl;
  final int watchedCount;
  final int followersCount;
  final int followingCount;

  UserProfile({
    required this.id,
    required this.username,
    required this.bio,
    required this.profilePictureUrl,
    this.watchedCount = 0,
    this.followersCount = 0,
    this.followingCount = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      username: json['username'],
      bio: json['bio'] ?? '',
      profilePictureUrl: json['avatar_url'] ?? '',
      watchedCount: json['watched_count'] ?? 0,
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
    );
  }
}
