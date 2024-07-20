import 'package:contrapp/custom_navbar.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/button/travel_button.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),
      body: Center(
        child: SizedBox(
          width: 1000,
          child: Row(
            children: <Widget>[              
                TravelButton(color: Colors.amber, icon: Icons.file_upload, label: 'Charger un contrat existant', link: '/home', height: 500, roundedBorder: 30, textSize: 50),            
                TravelButton(color: Colors.green, icon: Icons.create, label: 'Créer un nouveau contrat', link: '/common', height: 500, roundedBorder: 30, textSize: 50),
            ],
          ),
        ),
      )
    );
  }
}