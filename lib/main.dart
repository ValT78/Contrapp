import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contrapp',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Contrapp'),
        ),
        body: const Center(
          child: Text('Welcome to Contrapp'),
        ),
      ),
    );
  }
} 