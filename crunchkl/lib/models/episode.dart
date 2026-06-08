import 'anime.dart';

class Episode {
  final String id;
  final String animeId;
  final int episodeNumber;
  final String description;
  final int favoriteCount;

  Episode({
    required this.id,
    required this.animeId,
    required this.episodeNumber,
    required this.description,
    this.favoriteCount = 0,
  });

  factory Episode.fromJson(Map<String, dynamic> json) {
    return Episode(
      id: json['id'],
      animeId: json['anime_id'],
      episodeNumber: json['episode_number'],
      description: json['description'] ?? '',
      favoriteCount: json['favorite_count'] ?? 0,
    );
  }
}
