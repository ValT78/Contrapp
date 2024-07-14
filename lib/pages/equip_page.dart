import 'package:flutter/material.dart';
import '../navbar.dart';

class EquipPage extends StatelessWidget {
  const EquipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNavBar(),
      body: Center(child: Text('Equip Page')),
    );
  }
}