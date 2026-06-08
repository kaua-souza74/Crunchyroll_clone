import 'package:flutter/material.dart';
import '../models/anime.dart';
import 'anime_image.dart';

class AnimeGridItem extends StatelessWidget {
  final Anime anime;

  const AnimeGridItem({super.key, required this.anime});

  @override
  Widget build(BuildContext context) {
    return Column(
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
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
