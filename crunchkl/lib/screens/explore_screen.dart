import 'package:flutter/material.dart';
import '../main.dart';
import '../models/anime.dart';
import '../widgets/anime_grid_item.dart';
import 'anime_details_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  List<Anime> _allAnimes = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAllAnimes();
  }

  Future<void> _fetchAllAnimes() async {
    try {
      final data = await supabase.from('animes').select();
      if (mounted) {
        setState(() {
          _allAnimes = data.map((e) => Anime.fromJson(e)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explorar', style: TextStyle(color: Colors.white)), elevation: 0),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator())
        : Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextField(
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Buscar animes e mangás...',
                    prefixIcon: const Icon(Icons.search, color: Colors.white54),
                    filled: true,
                    fillColor: Colors.grey[800],
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.0), borderSide: BorderSide.none),
                  ),
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12.0,
                    mainAxisSpacing: 16.0,
                  ),
                  itemCount: _allAnimes.length,
                  itemBuilder: (context, index) {
                    final anime = _allAnimes[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnimeDetailsScreen(anime: anime))),
                      child: AnimeGridItem(anime: anime),
                    );
                  },
                ),
              ),
            ],
          ),
    );
  }
}
