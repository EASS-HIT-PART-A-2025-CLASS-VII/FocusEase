import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focusease/utils/notification_service.dart';

import 'package:focusease/screens/login_screen.dart';
import 'package:focusease/screens/register_screen.dart';
import 'package:focusease/screens/tasks_screen.dart';
import 'package:focusease/screens/media_screen.dart';
import 'package:focusease/screens/manual_task_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize notifications at startup
  final notificationService = NotificationService();
  await notificationService.init();

  runApp(const FocusEaseApp());
}

class FocusEaseApp extends StatelessWidget {
  const FocusEaseApp({super.key});

  Future<Widget> _getInitialScreen() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwt_token');

    if (token != null && token.isNotEmpty) {
      return TasksScreen(token: token);
    } else {
      return const LoginScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
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
          return TasksScreen(token: token);
        },
        '/media': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return MediaScreen(token: token);
        },
        '/manual': (context) {
          final token = ModalRoute.of(context)!.settings.arguments as String;
          return ManualTaskScreen(token: token);
        },
      },
    );
  }
}
