import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

import 'package:focusease/screens/login_screen.dart';
import 'package:focusease/screens/register_screen.dart';
import 'package:focusease/screens/tasks_screen.dart';
import 'package:focusease/screens/media_screen.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
  runApp(const FocusEaseApp());
}

class FocusEaseApp extends StatelessWidget {
  const FocusEaseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FocusEase',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/tasks': (context) => const TasksScreen(),
        '/media': (context) => const MediaScreen(),
      },
    );
  }
}
