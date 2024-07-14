import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';

class EquipPage extends StatelessWidget {
  const EquipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),
      body: Center(child: Text('Equip Page')),
    );
  }
}