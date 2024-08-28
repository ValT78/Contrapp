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
        child: Center(
        child: Column(
          children: [
             SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              height: MediaQuery.of(context).size.height - 200,
              child: const CalendarContainer(),
            ),
            SizedBox(
                width: 1200 * MediaQuery.of(context).size.width * 0.9/1920,
                child: const Row(
                  children: <Widget>[
                    TravelButton(
                      color: Colors.deepPurple,
                      icon: Icons.navigate_before,
                      label: 'Précédent',
                      link: '/equip',
                      height: 100,
                      width: 500,
                      roundedBorder: 50,
                      textSize: 30,
                      scaleWidthFactor: 1,
                    ),
                    TravelButton(
                      color: Colors.green,
                      icon: Icons.navigate_next,
                      label: 'Suivant',
                      link: '/attach',
                      height: 100,
                      width: 500,
                      roundedBorder: 50,
                      textSize: 30,
                      scaleWidthFactor: 1,
                    ),
                  ],
                ),
              ),
          ],
        ),
        ),
      ),
    );
  }
}