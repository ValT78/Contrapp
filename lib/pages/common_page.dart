import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';

class CommonPage extends StatelessWidget {
  const CommonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),      body: Center(child: Text('Common Page')),
    );
  }
}