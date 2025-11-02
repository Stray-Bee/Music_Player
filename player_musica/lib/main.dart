import 'package:flutter/material.dart';
import 'package:player_musica/model/Musica_Model.dart';
import 'package:player_musica/service/Musica_Player_Service.dart';
import 'package:player_musica/service/Musica_Service.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:player_musica/widget/Card_Musica.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.farteche.channel.audio',
    androidNotificationChannelName: 'Reprodução de Áudio',
    androidNotificationOngoing: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MP3 Player Elegante',
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.system,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.light(
          primary: Color(0xFFE1BEE7), // Lilás suave
          onPrimary: Colors.white,
          secondary: Color(0xFFF8BBD0), // Rosa claro
          onSecondary: Colors.black,
          surface: Color(0xFFFFF1F3),
          background: Color(0xFFFFF7FA),
          error: Color(0xFFD32F2F),
        ),
        scaffoldBackgroundColor: const Color(0xFFFFF7FA),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFE1BEE7),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 6,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.pink.shade100, width: 1),
          ),
          shadowColor: Colors.pinkAccent.withOpacity(0.2),
          color: const Color(0xFFFFF1F3),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFF48FB1),
          foregroundColor: Colors.white,
          elevation: 8,
          shape: CircleBorder(),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.purple,
          ),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.black87),
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFFCE93D8), // Lilás claro
          onPrimary: Colors.black,
          secondary: Color(0xFFF48FB1), // Rosa médio
          onSecondary: Colors.black,
          surface: Color(0xFF1E1E1E),
          background: Color(0xFF121212),
          error: Color(0xFFEF5350),
        ),
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4A148C),
          foregroundColor: Colors.white,
          elevation: 4,
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(16)),
          ),
        ),
        cardTheme: CardTheme(
          elevation: 6,
          margin: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
            side: BorderSide(color: Colors.purpleAccent, width: 1),
          ),
          shadowColor: Colors.purpleAccent.withOpacity(0.3),
          color: const Color(0xFF1E1E1E),
        ),
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Color(0xFFCE93D8),
          foregroundColor: Colors.black,
          elevation: 8,
          shape: CircleBorder(),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
          bodyMedium: TextStyle(fontSize: 16, color: Colors.white70),
        ),
      ),
      home: const MyHomePage(title: 'Minhas Músicas'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final playerService = MusicaPlayerService();
  List<MusicaModel> musicas = [];
  bool carregando = true;

  @override
  void initState() {
    super.initState();
    carregarMusicas();
  }

  void carregarMusicas() async {
    try {
      musicas = await MusicaService.fetchMusicas();
    } catch (e) {
      print('Erro ao carregar músicas: $e');
    } finally {
      setState(() => carregando = false);
    }
  }

  @override
  void dispose() {
    playerService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (carregando) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: ValueListenableBuilder<bool>(
        valueListenable: playerService.isPlaying,
        builder: (context, isPlaying, _) {
          return ListView.builder(
            itemCount: musicas.length,
            itemBuilder: (context, index) {
              final musica = musicas[index];
              final isSelected = playerService.musicaAtual?.url == musica.url;

              return CardMusica(
                musicaC: musica,
                isPlaying: isPlaying,
                isSelected: isSelected,
                onPressed: () => playerService.tocarOuPausar(musica),
              );
            },
          );
        },
      ),
    );
  }
}
