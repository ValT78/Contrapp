import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/button/travel_button.dart';
import 'package:contrapp/create_pdf.dart';

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
              SizedBox(
                width: 1000,
                child: Row(
                  children: <Widget>[              
                    TravelButton(color: Colors.deepPurple, icon: Icons.navigate_before, label: 'Précédent', link: '/attach', height: 100, roundedBorder: 50, textSize: 30),            
                    TravelButton(color: Colors.green, icon: Icons.navigate_next, label: 'Genérer le PDF', actionFunction: createPdfFromMarkdown, height: 100, roundedBorder: 50, textSize: 30),
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