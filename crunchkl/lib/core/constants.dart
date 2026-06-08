import 'package:flutter/foundation.dart';
import '../models/anime.dart';

class Constants {
  static final ValueNotifier<List<Anime>> watchlistNotifier = ValueNotifier([]);

  // ATENÇÃO: Substitua os valores abaixo pelas suas credenciais do Supabase!
  static const String supabaseUrl = 'https://pdljidlitztpcdkmdcno.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InBkbGppZGxpdHp0cGNka21kY25vIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODA4ODcyMzQsImV4cCI6MjA5NjQ2MzIzNH0.RqfgF0VNqFV6-Kuvd-7xvIGg2AiGFj-yFjn7PGKq81g';

  static String getProxyUrl(String originalUrl) {
    // Anilist CDN suporta CORS nativamente, sem proxy necessário
    return originalUrl;
  }
}
