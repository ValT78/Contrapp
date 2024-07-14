import 'package:flutter/material.dart';
import '../navbar.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomNavBar(),
      body: Center(child: Text('Calendar Page')),
    );
  }
}