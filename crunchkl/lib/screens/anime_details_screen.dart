import 'package:flutter/material.dart';
import '../main.dart';
import '../models/anime.dart';
import '../models/episode.dart';
import '../models/comment.dart';
import '../core/constants.dart';
import '../widgets/anime_image.dart';

class AnimeDetailsScreen extends StatefulWidget {
  final Anime anime;

  const AnimeDetailsScreen({super.key, required this.anime});

  @override
  State<AnimeDetailsScreen> createState() => _AnimeDetailsScreenState();
}

class _AnimeDetailsScreenState extends State<AnimeDetailsScreen> {
  List<Episode> _episodes = [];
  List<Comment> _comments = [];
  bool _isLoading = true;
  final _commentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchDetails();
  }

  Future<void> _fetchDetails() async {
    setState(() => _isLoading = true);
    try {
      final episodesData = await supabase
          .from('episodes')
          .select()
          .eq('anime_id', widget.anime.id)
          .order('episode_number', ascending: true);

      final commentsData = await supabase
          .from('comments')
          .select('*, profiles(*)')
          .eq('anime_id', widget.anime.id)
          .order('created_at', ascending: false);

      if (mounted) {
        setState(() {
          _episodes = episodesData.map((e) => Episode.fromJson(e)).toList();
          _comments = commentsData.map((c) => Comment.fromJson(c)).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao carregar detalhes')));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _postComment() async {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;
    
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faça login para comentar')));
      return;
    }

    try {
      await supabase.from('comments').insert({
        'anime_id': widget.anime.id,
        'user_id': userId,
        'content': text,
      });
      _commentController.clear();
      _fetchDetails(); // Reload comments
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao enviar comentário')));
    }
  }

  Future<void> _watchEpisode(Episode ep) async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    
    // Adiciona na cache imediatamente
    final currentList = List<Anime>.from(Constants.watchlistNotifier.value);
    if (!currentList.any((a) => a.id == widget.anime.id)) {
      currentList.insert(0, widget.anime);
      Constants.watchlistNotifier.value = currentList;
    }

    try {
      await supabase.from('watchlist').upsert({
        'user_id': userId,
        'anime_id': widget.anime.id,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Assistindo Episódio ${ep.episodeNumber}...')));
    } catch (e) {
      // Falha silenciosa ou log
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(widget.anime.title, style: const TextStyle(shadows: [Shadow(color: Colors.black, blurRadius: 10)])),
                  background: AnimeImage(
                    animeTitle: widget.anime.title,
                    fallbackUrl: widget.anime.coverUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    widget.anime.description,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ),
              const SliverPersistentHeader(
                pinned: true,
                delegate: _SliverAppBarDelegate(
                  TabBar(
                    indicatorColor: Colors.orangeAccent,
                    labelColor: Colors.orangeAccent,
                    unselectedLabelColor: Colors.white54,
                    tabs: [Tab(text: 'Episódios'), Tab(text: 'Comentários')],
                  ),
                ),
              ),
            ];
          },
          body: _isLoading 
              ? const Center(child: CircularProgressIndicator()) 
              : TabBarView(
                  children: [
                    // Aba de Episódios
                    ListView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: _episodes.length,
                      itemBuilder: (context, index) {
                        final ep = _episodes[index];
                        return EpisodeListItem(
                          episode: ep,
                          onTap: () => _watchEpisode(ep),
                        );
                      },
                    ),
                    // Aba de Comentários
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _commentController,
                                  decoration: const InputDecoration(
                                    hintText: 'Adicionar comentário...',
                                    border: OutlineInputBorder(),
                                    filled: true,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.send, color: Colors.orangeAccent),
                                onPressed: _postComment,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: _comments.length,
                            itemBuilder: (context, index) {
                              final comment = _comments[index];
                              return ListTile(
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(Constants.getProxyUrl(comment.user?.profilePictureUrl ?? '')),
                                ),
                                title: Text(comment.user?.username ?? 'Desconhecido', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
                                subtitle: Text(comment.content, style: const TextStyle(color: Colors.white)),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  const _SliverAppBarDelegate(this._tabBar);

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Colors.black,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) => false;
}

class EpisodeListItem extends StatefulWidget {
  final Episode episode;
  final VoidCallback onTap;

  const EpisodeListItem({super.key, required this.episode, required this.onTap});

  @override
  State<EpisodeListItem> createState() => _EpisodeListItemState();
}

class _EpisodeListItemState extends State<EpisodeListItem> {
  bool isFavorite = false;
  late int favoriteCount;

  @override
  void initState() {
    super.initState();
    favoriteCount = widget.episode.favoriteCount;
    _checkIfFavorite();
  }

  Future<void> _checkIfFavorite() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) return;
    try {
      final res = await supabase.from('favorites').select().eq('user_id', userId).eq('episode_id', widget.episode.id);
      if (mounted && res.isNotEmpty) {
        setState(() => isFavorite = true);
      }
    } catch (e) {}
  }

  Future<void> _toggleFavorite() async {
    final userId = supabase.auth.currentUser?.id;
    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Faça login para favoritar')));
      return;
    }

    setState(() {
      isFavorite = !isFavorite;
      if (isFavorite) favoriteCount++; else favoriteCount--;
    });

    try {
      if (isFavorite) {
        await supabase.from('favorites').upsert({'user_id': userId, 'episode_id': widget.episode.id});
      } else {
        await supabase.from('favorites').delete().eq('user_id', userId).eq('episode_id', widget.episode.id);
      }
      await supabase.from('episodes').update({'favorite_count': favoriteCount}).eq('id', widget.episode.id);
    } catch (e) {
      if (mounted) {
        setState(() {
          isFavorite = !isFavorite;
          if (isFavorite) favoriteCount++; else favoriteCount--;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.play_circle_fill, color: Colors.orangeAccent, size: 40),
      title: Text('Episódio ${widget.episode.episodeNumber}'),
      subtitle: Text(widget.episode.description, maxLines: 2, overflow: TextOverflow.ellipsis),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: isFavorite ? Colors.redAccent : Colors.white54),
            onPressed: _toggleFavorite,
          ),
          Text('$favoriteCount', style: const TextStyle(color: Colors.white54)),
        ],
      ),
      onTap: widget.onTap,
    );
  }
}
