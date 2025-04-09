import 'package:flutter/material.dart';
import 'package:here/homePage.dart';

import 'homePage.dart'; // homePage.dart dosyasını import et

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Here', // Uygulama adını "Here" yaptım
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const HomePage(), // MyHomePage yerine HomePage’e yönlendiriyoruz
    );
  }
}