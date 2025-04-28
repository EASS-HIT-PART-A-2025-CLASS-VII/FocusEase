import 'package:flutter/material.dart';
import 'package:focusease/screens/now_playing_screen.dart';

class SpotifyConnectScreen extends StatelessWidget {
  const SpotifyConnectScreen({super.key});

  void _connectToSpotify(BuildContext context) {
    // 🛠️ Mock: Pretend to connect
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Connected to Spotify (Mock)!')),
    );

    // ✅ Navigate to Now Playing after 1 second
    Future.delayed(const Duration(seconds: 1), () {
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 500),
            pageBuilder: (context, animation, secondaryAnimation) {
              return const NowPlayingScreen();
            },
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              final tween = Tween(begin: begin, end: end)
                  .chain(CurveTween(curve: Curves.ease));
              return SlideTransition(
                  position: animation.drive(tween), child: child);
            },
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connect Spotify'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "🎵 Connect your Spotify to boost focus with music!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () => _connectToSpotify(context),
                icon: const Icon(Icons.music_note),
                label: const Text("Connect to Spotify"),
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
