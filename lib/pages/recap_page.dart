import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';

class RecapPage extends StatelessWidget {
  const RecapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),
            body: Center(child: Text('Recap Page')),
    );
  }
}