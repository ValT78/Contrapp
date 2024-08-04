import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/skeleton/calendar.dart';
import 'package:contrapp/button/astreinte_button.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),  
      body: SingleChildScrollView(
        child: Column(
          children: [
             SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: 500,
              child: const Calendar(),
            ),
            const Center(
              child: 
              SizedBox(
                child: AstreinteButton(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}