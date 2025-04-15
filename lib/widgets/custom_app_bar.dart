import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(Icons.menu),
        onPressed: () {
          Scaffold.of(context).openDrawer();
        },
      ),
      title: Text('Here'),
      centerTitle: true,
      actions: [
        IconButton(
          icon: Icon(Icons.message),
          onPressed: () {
            Navigator.pushNamed(context, '/messages');
          },
        ),
      ],
    );
  }
}