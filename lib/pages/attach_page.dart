import 'package:flutter/material.dart';
import '../navbar.dart';

class AttachPage extends StatelessWidget {
  const AttachPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNavBar(),
      body: Center(child: Text('Attach Page')),
    );
  }
}