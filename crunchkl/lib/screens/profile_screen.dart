import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../main.dart';
import '../models/user_profile.dart';
import '../models/anime.dart';
import '../core/constants.dart';
import 'login_screen.dart';
import 'anime_details_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserProfile? _profile;
  List<Anime> _watchlist = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final data = await supabase.from('profiles').select().eq('id', user.id).single();
      final watchlistRes = await supabase.from('watchlist').select('animes(*)').eq('user_id', user.id);
      
      if (mounted) {
        setState(() {
          _profile = UserProfile.fromJson(data);
          _watchlist = watchlistRes.map<Anime>((item) => Anime.fromJson(item['animes'])).toList();
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _uploadAvatar() async {
    final picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery, maxWidth: 300, maxHeight: 300);
    if (imageFile == null) return;

    setState(() => _isLoading = true);
    try {
      final userId = supabase.auth.currentUser!.id;
      final fileExtension = imageFile.path.split('.').last;
      final fileName = '$userId-${DateTime.now().millisecondsSinceEpoch}.$fileExtension';
      final fileBytes = await imageFile.readAsBytes();

      await supabase.storage.from('avatars').uploadBinary(fileName, fileBytes);
      final imageUrl = supabase.storage.from('avatars').getPublicUrl(fileName);
      await supabase.from('profiles').update({'avatar_url': imageUrl}).eq('id', userId);
      await _fetchProfile();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Erro ao atualizar foto')));
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _signOut() async {
    await supabase.auth.signOut();
    Constants.watchlistNotifier.value = [];
    if (mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (_profile == null) {
      return const Scaffold(body: Center(child: Text('Erro ao carregar perfil', style: TextStyle(color: Colors.white))));
    }

    final avatarUrl = _profile!.profilePictureUrl.isNotEmpty
        ? _profile!.profilePictureUrl
        : 'https://s4.anilist.co/file/anilistcdn/user/avatar/large/default.png';

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFFE87722), Color(0xFF1A1A2E)],
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _uploadAvatar,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey[800],
                            backgroundImage: NetworkImage(avatarUrl),
                            onBackgroundImageError: (_, __) {},
                          ),
                          Positioned(
                            bottom: 0, right: 0,
                            child: CircleAvatar(
                              radius: 16,
                              backgroundColor: Colors.orangeAccent,
                              child: const Icon(Icons.camera_alt, size: 16, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_profile!.username, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(_profile!.bio, style: const TextStyle(fontSize: 12, color: Colors.white70)),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(icon: const Icon(Icons.logout, color: Colors.white), onPressed: _signOut),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStat('Assistidos', _watchlist.length),
                  _buildStat('Seguidores', _profile!.followersCount),
                  _buildStat('Seguindo', _profile!.followingCount),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: Text('Minha Lista', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.orangeAccent)),
            ),
          ),
          if (_watchlist.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Nenhum anime na sua lista ainda.\nAbra um anime e dê play em um episódio!', style: TextStyle(color: Colors.white54), textAlign: TextAlign.center),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final anime = _watchlist[index];
                    return GestureDetector(
                      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => AnimeDetailsScreen(anime: anime))),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                anime.coverUrl,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (_, __, ___) => Container(
                                  color: Colors.grey[800],
                                  child: const Icon(Icons.broken_image, color: Colors.white54),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(anime.title, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12, color: Colors.white)),
                        ],
                      ),
                    );
                  },
                  childCount: _watchlist.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.65,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 12,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStat(String label, int value) {
    return Column(
      children: [
        Text(value.toString(), style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white54)),
      ],
    );
  }
}
