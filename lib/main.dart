import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/store_screen.dart';
import 'screens/photo_screen.dart';
import 'screens/likes_screen.dart';
import 'screens/profile_screen.dart';
// import 'screens/gifts_screen.dart';
// import 'screens/tasks_screen.dart';
import 'screens/messages_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Here App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        // '/store': (context) => StoreScreen(),
        // '/photo': (context) => PhotoScreen(),
        // '/likes': (context) => LikesScreen(),
        // '/profile': (context) => ProfileScreen(),
        // '/gifts': (context) => GiftsScreen(),
        // '/tasks': (context) => TasksScreen(),
        // '/messages': (context) => MessagesScreen(),
      },
    );
  }
}