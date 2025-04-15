import 'package:flutter/material.dart';

class DrawerMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text(
              'Menü',
              style: TextStyle(color: Colors.white, fontSize: 24),
            ),
          ),
          ListTile(
            title: Text('Hediyeler'),
            onTap: () {
              Navigator.pushNamed(context, '/gifts');
            },
          ),
          ListTile(
            title: Text('Görevler'),
            onTap: () {
              Navigator.pushNamed(context, '/tasks');
            },
          ),
        ],
      ),
    );
  }
}