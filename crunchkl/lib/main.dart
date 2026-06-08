import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/constants.dart';
import 'screens/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar o Supabase
  await Supabase.initialize(
    url: Constants.supabaseUrl,
    anonKey: Constants.supabaseAnonKey,
  );

  runApp(const CrunchklApp());
}

final supabase = Supabase.instance.client;

class CrunchklApp extends StatelessWidget {
  const CrunchklApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crunchkl',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: Colors.black,
        colorScheme: const ColorScheme.dark(
          primary: Colors.orangeAccent,
          secondary: Colors.orange,
          surface: Color(0xFF212121),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
