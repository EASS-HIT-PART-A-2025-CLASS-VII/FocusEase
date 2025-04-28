import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focusease/utils/notification_service.dart';
import 'package:focusease/screens/login_screen.dart';
import 'package:focusease/screens/register_screen.dart';
import 'package:focusease/screens/tasks_screen.dart';
import 'package:focusease/screens/media_screen.dart';
import 'package:focusease/screens/manual_task_screen.dart';
import 'package:focusease/screens/spotify_connect_screen.dart';
import 'package:focusease/screens/now_playing_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notificationService = NotificationService();
  await notificationService.init();
  runApp(const FocusEaseApp());
}

class FocusEaseApp extends StatefulWidget {
  const FocusEaseApp({super.key});

  @override
  State<FocusEaseApp> createState() => _FocusEaseAppState();
}

class _FocusEaseAppState extends State<FocusEaseApp> {
  ThemeMode _themeMode = ThemeMode.system;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = prefs.getBool('isDarkMode') ?? false;
    setState(() {
      _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<void> _toggleTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final isDark = _themeMode == ThemeMode.dark;
    await prefs.setBool('isDarkMode', !isDark);
    setState(() {
      _themeMode = !isDark ? ThemeMode.dark : ThemeMode.light;
    });
  }

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');
    if (token != null && token.isNotEmpty) {
      return TasksScreen(token: token, toggleTheme: _toggleTheme);
    } else {
      return LoginScreen(toggleTheme: _toggleTheme);
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusEase',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      themeMode: _themeMode,
      home: FutureBuilder(
        future: _getInitialScreen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!;
          } else {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
        },
      ),
      routes: {
        '/register': (context) => const RegisterScreen(),
        '/tasks': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return TasksScreen(token: token, toggleTheme: _toggleTheme);
        },
        '/media': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return MediaScreen(token: token);
        },
        '/manual': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return ManualTaskScreen(token: token);
        },
        '/spotify': (context) => const SpotifyConnectScreen(),
        '/nowplaying': (context) => const NowPlayingScreen(),
      },
    );
  }
}
