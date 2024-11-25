import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';
import 'todo_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final String userIdentifier = await getOrCreateUserIdentifier();
  runApp(MyApp(userIdentifier: userIdentifier));
}

Future<String> getOrCreateUserIdentifier() async {
  final prefs = await SharedPreferences.getInstance();
  String? userIdentifier = prefs.getString('user_identifier');

  if (userIdentifier == null) {
    userIdentifier = generateUniqueIdentifier();
    await prefs.setString('user_identifier', userIdentifier);
  }

  return userIdentifier;
}

String generateUniqueIdentifier() {
  final random = Random();
  const chars =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
  return List.generate(16, (index) => chars[random.nextInt(chars.length)])
      .join();
}

class MyApp extends StatelessWidget {
  final String userIdentifier;

  const MyApp({super.key, required this.userIdentifier});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoListScreen(userIdentifier: userIdentifier),
    );
  }
}
