class Anime {
  final String id;
  final String title;
  final String coverUrl;
  final String description;
  final bool isTrending;

  Anime({
    required this.id,
    required this.title,
    required this.coverUrl,
    required this.description,
    this.isTrending = false,
  });

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['id'],
      title: json['title'],
      coverUrl: json['cover_url'],
      description: json['description'] ?? 'Descrição não disponível.',
      isTrending: json['is_trending'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'cover_url': coverUrl,
      'description': description,
      'is_trending': isTrending,
    };
  }
}
