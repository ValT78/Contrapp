import 'package:flutter/material.dart';
import '../navbar.dart';

class RecapPage extends StatelessWidget {
  const RecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNavBar(),
      body: Center(child: Text('Recap Page')),
    );
  }
}