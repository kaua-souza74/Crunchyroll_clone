import 'dart:convert';
import 'package:http/http.dart' as http;

/// Serviço que busca imagens de capa dos animes pela API pública do Anilist.co
/// A API é 100% CORS-enabled e não precisa de chave.
class AnilistService {
  static const String _url = 'https://graphql.anilist.co';

  static const Map<String, int> _titleToAnilistId = {
    'Solo Leveling': 166531,
    'Jujutsu Kaisen': 113415,
    'Demon Slayer': 101922,
    'Attack on Titan': 16498,
    'One Piece': 21,
    'Spy x Family': 140960,
    'Bleach: Thousand-Year Blood War': 41467,
    'Chainsaw Man': 127230,
    'Naruto Shippuden': 1735,
    'My Hero Academia': 97940,
    'Frieren: Beyond Journey\'s End': 154587,
    'Mashle: Magic and Muscles': 166786,
  };

  static final Map<String, String> _cache = {};

  static Future<String?> getCoverUrl(String animeTitle) async {
    if (_cache.containsKey(animeTitle)) return _cache[animeTitle];

    final anilistId = _titleToAnilistId[animeTitle];
    if (anilistId == null) return null;

    const query = '''
      query (\$id: Int) {
        Media(id: \$id, type: ANIME) {
          coverImage {
            large
            extraLarge
          }
        }
      }
    ''';

    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'query': query, 'variables': {'id': anilistId}}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final url = data['data']['Media']['coverImage']['large'] as String?;
        if (url != null) {
          _cache[animeTitle] = url;
        }
        return url;
      }
    } catch (_) {}
    return null;
  }
}
