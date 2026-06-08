import 'package:flutter/material.dart';
import '../models/anime.dart';
import 'anime_image.dart';

class ReleaseItem extends StatelessWidget {
  final Anime anime;

  const ReleaseItem({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 140,
      margin: const EdgeInsets.only(right: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: AnimeImage(
                animeTitle: anime.title,
                fallbackUrl: anime.coverUrl,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          Text(
            anime.title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
