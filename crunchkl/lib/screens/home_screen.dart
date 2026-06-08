import 'package:flutter/material.dart';
import '../main.dart';
import '../models/anime.dart';
import '../widgets/release_item.dart';
import '../core/constants.dart';
import 'anime_details_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Anime> _trendingAnimes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final trendingData = await supabase.from('animes').select().eq('is_trending', true);
      
      final userId = supabase.auth.currentUser?.id;
      List<dynamic> watchlistData = [];
      if (userId != null) {
        final res = await supabase.from('watchlist').select('animes(*)').eq('user_id', userId);
        watchlistData = res.map((item) => item['animes']).toList();
      }

      if (mounted) {
        setState(() {
          _trendingAnimes = trendingData.map((e) => Anime.fromJson(e)).toList();
          _isLoading = false;
        });
        if (userId != null) {
          Constants.watchlistNotifier.value = watchlistData.map((e) => Anime.fromJson(e)).toList();
        }
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crunchkl', style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [IconButton(icon: const Icon(Icons.notifications_none, color: Colors.white), onPressed: () {})],
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Lançamentos da Temporada', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                SizedBox(
                  height: 220,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    scrollDirection: Axis.horizontal,
                    itemCount: _trendingAnimes.length,
                    itemBuilder: (context, index) {
                      final anime = _trendingAnimes[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnimeDetailsScreen(anime: anime))),
                        child: ReleaseItem(anime: anime),
                      );
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Continue Assistindo', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
                ValueListenableBuilder<List<Anime>>(
                  valueListenable: Constants.watchlistNotifier,
                  builder: (context, watchlist, child) {
                    if (watchlist.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.0),
                        child: Text('Você ainda não começou a assistir nada. Clique em um anime e dê play!', style: TextStyle(color: Colors.white54)),
                      );
                    }
                    return SizedBox(
                      height: 220,
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        scrollDirection: Axis.horizontal,
                        itemCount: watchlist.length,
                        itemBuilder: (context, index) {
                          final anime = watchlist[index];
                          return GestureDetector(
                            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnimeDetailsScreen(anime: anime))),
                            child: ReleaseItem(anime: anime),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}
