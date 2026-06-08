import 'package:flutter/material.dart';
import '../services/anilist_service.dart';

/// Widget inteligente de imagem de anime.
/// Primeiro tenta carregar da URL salva no banco.
/// Se falhar (404/403), busca da API do Anilist em tempo real.
class AnimeImage extends StatefulWidget {
  final String animeTitle;
  final String fallbackUrl;
  final BoxFit fit;

  const AnimeImage({
    super.key,
    required this.animeTitle,
    required this.fallbackUrl,
    this.fit = BoxFit.cover,
  });

  @override
  State<AnimeImage> createState() => _AnimeImageState();
}

class _AnimeImageState extends State<AnimeImage> {
  late String _resolvedUrl;
  bool _hasFailed = false;
  bool _isLoadingFallback = false;
  String? _anilistUrl;

  @override
  void initState() {
    super.initState();
    _resolvedUrl = widget.fallbackUrl;
    // Pré-carrega a imagem do Anilist em background para ter pronta
    _prefetch();
  }

  Future<void> _prefetch() async {
    final url = await AnilistService.getCoverUrl(widget.animeTitle);
    if (mounted && url != null) {
      setState(() {
        _anilistUrl = url;
        // Se já falhou, usa imediatamente
        if (_hasFailed) _resolvedUrl = url;
      });
    }
  }

  void _handleError() {
    if (_hasFailed || !mounted) return;
    _hasFailed = true;

    if (_anilistUrl != null) {
      // URL do Anilist já está pronta, usa direto
      Future.microtask(() {
        if (mounted) setState(() => _resolvedUrl = _anilistUrl!);
      });
    } else {
      // Ainda buscando, mostra loading até _prefetch() completar
      Future.microtask(() {
        if (mounted) setState(() => _isLoadingFallback = true);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Se temos url do Anilist e a original falhou, usa Anilist
    final url = (_hasFailed && _anilistUrl != null) ? _anilistUrl! : _resolvedUrl;

    if (_isLoadingFallback && _anilistUrl == null) {
      return Container(
        color: Colors.grey[850],
        child: const Center(
          child: SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2, color: Colors.orangeAccent),
          ),
        ),
      );
    }

    if (url.isEmpty) return _placeholder();

    return Image.network(
      url,
      fit: widget.fit,
      width: double.infinity,
      height: double.infinity,
      errorBuilder: (_, __, ___) {
        _handleError();
        return _placeholder();
      },
    );
  }

  Widget _placeholder() {
    return Container(
      color: Colors.grey[850],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.movie, color: Colors.white24, size: 28),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              widget.animeTitle,
              maxLines: 2,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.white30, fontSize: 9),
            ),
          ),
        ],
      ),
    );
  }
}
