import '../models/anime.dart';
import '../models/episode.dart';
import '../models/user_profile.dart';

class MockData {
  static final List<Anime> animes = [
    Anime(
      id: '1',
      title: 'Solo Leveling',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1100/138338.jpg',
      description: 'Em um mundo onde caçadores lutam contra monstros...',
    ),
    Anime(
      id: '2',
      title: 'Jujutsu Kaisen',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1171/109222.jpg',
    ),
    Anime(
      id: '3',
      title: 'Demon Slayer',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1286/99889.jpg',
    ),
    Anime(
      id: '4',
      title: 'Attack on Titan',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/10/47347.jpg',
    ),
    Anime(
      id: '5',
      title: 'One Piece',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/9/73444.jpg',
    ),
    Anime(
      id: '6',
      title: 'Spy x Family',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1441/122795.jpg',
    ),
    Anime(
      id: '7',
      title: 'Bleach: Thousand-Year Blood War',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1764/126627.jpg',
    ),
    Anime(
      id: '8',
      title: 'Chainsaw Man',
      coverUrl: 'https://cdn.myanimelist.net/images/anime/1806/126216.jpg',
    ),
  ];

  static final List<Episode> recentEpisodes = [
    Episode(
      id: 'ep1',
      anime: animes[0],
      episodeNumber: 12,
      description: 'O surgimento das sombras. Jinwoo enfrenta seu maior desafio até agora.',
      favoriteCount: 1530,
    ),
    Episode(
      id: 'ep2',
      anime: animes[1],
      episodeNumber: 47,
      description: 'Incidente em Shibuya continua, maldições de nível especial entram em ação.',
      favoriteCount: 2045,
    ),
    Episode(
      id: 'ep3',
      anime: animes[2],
      episodeNumber: 55,
      description: 'O treinamento Hashira atinge seu ápice.',
      favoriteCount: 980,
    ),
    Episode(
      id: 'ep4',
      anime: animes[5],
      episodeNumber: 37,
      description: 'Anya recebe uma nova missão secreta na escola.',
      favoriteCount: 1200,
    ),
  ];

  static final UserProfile currentUser = UserProfile(
    username: 'OtakuMaster99',
    bio: 'Amante de Shounen e Isekai. Sempre maratonando!',
    profilePictureUrl: 'https://cdn.myanimelist.net/images/characters/11/286916.jpg', // Saitama avatar
    watchedCount: 342,
    followersCount: 128,
    followingCount: 45,
    watchlist: [animes[0], animes[1], animes[3], animes[4], animes[7]],
  );
}
