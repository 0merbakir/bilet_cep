import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Main Page'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(Icons.logout)),
        ],
      ),
      body: const Column(
        children: [
          Center(
            child: Text(
              'Anasayfa',
              style: TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}
