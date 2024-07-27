import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/skeleton/common_form.dart';
import 'package:contrapp/button/travel_button.dart';

class RecapPage extends StatefulWidget {
  const RecapPage({super.key});

  static RecapPageState? of(BuildContext context) => context.findAncestorStateOfType<RecapPageState>();

  @override
  RecapPageState createState() => RecapPageState();
}

class RecapPageState extends State<RecapPage> {
 
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100),
      ),      
      body:  Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              CommonForm(),
              SizedBox(
                width: 1000,
                child: Row(
                  children: <Widget>[              
                    TravelButton(color: Colors.deepPurple, icon: Icons.navigate_before, label: 'Précédent', link: '/attach', height: 100, roundedBorder: 50, textSize: 30),            
                    TravelButton(color: Colors.green, icon: Icons.navigate_next, label: 'Suivant', link: '/equip', height: 100, roundedBorder: 50, textSize: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}