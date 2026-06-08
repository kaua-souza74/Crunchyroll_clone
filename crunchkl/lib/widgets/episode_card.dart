import 'package:flutter/material.dart';
import '../models/episode.dart';

class EpisodeCard extends StatefulWidget {
  final Episode episode;

  const EpisodeCard({super.key, required this.episode});

  @override
  State<EpisodeCard> createState() => _EpisodeCardState();
}

class _EpisodeCardState extends State<EpisodeCard> {
  late bool isFavorite;
  late int favoriteCount;

  @override
  void initState() {
    super.initState();
    isFavorite = widget.episode.isFavorite;
    favoriteCount = widget.episode.favoriteCount;
  }

  void _toggleFavorite() {
    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) {
        favoriteCount++;
      } else {
        favoriteCount--;
      }
      widget.episode.isFavorite = isFavorite;
      widget.episode.favoriteCount = favoriteCount;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      color: Colors.grey[900],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 120,
                height: 160,
                child: Image.network(
                  widget.episode.anime.coverUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(color: Colors.grey[800]),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.episode.anime.title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orangeAccent,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Episódio ${widget.episode.episodeNumber}',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.episode.description,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.white54,
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Container(
            color: Colors.black12,
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.redAccent : Colors.white54,
                      ),
                      onPressed: _toggleFavorite,
                    ),
                    Text(
                      '$favoriteCount',
                      style: const TextStyle(color: Colors.white54),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.comment_outlined, color: Colors.white54),
                  onPressed: () {
                    // Simular ação de comentário
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Abrindo comentários...')),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
