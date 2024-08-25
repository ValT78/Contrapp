import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/skeleton/calendar_container.dart';

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
              height: MediaQuery.of(context).size.height - 200,
              child: const CalendarContainer(),
            ),
            const SizedBox(
                width: 1000,
                child: Row(
                  children: <Widget>[
                    TravelButton(
                      color: Colors.deepPurple,
                      icon: Icons.navigate_before,
                      label: 'Précédent',
                      link: '/home',
                      height: 100,
                      roundedBorder: 50,
                      textSize: 30,
                    ),
                    TravelButton(
                      color: Colors.green,
                      icon: Icons.navigate_next,
                      label: 'Suivant',
                      link: '/equip',
                      height: 100,
                      roundedBorder: 50,
                      textSize: 30,
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}