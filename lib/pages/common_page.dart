import 'package:flutter/material.dart';
import '../navbar.dart';

class CommonPage extends StatelessWidget {
  const CommonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNavBar(),
      body: Center(child: Text('Common Page')),
    );
  }
}