import 'package:contrapp/navbare.dart';
import 'package:flutter/material.dart';
import '../navbar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: CustomNavBar(),
      body: Navbare(),
      );
    }
}