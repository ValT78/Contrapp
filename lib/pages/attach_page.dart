import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:contrapp/skeleton/attach_picker.dart';

class AttachPage extends StatelessWidget {
  const AttachPage({super.key});

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
        AttachPicker(),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[              
              TravelButton(color: Colors.deepPurple, icon: Icons.navigate_before, label: 'Précédent', link: '/calendar', height: 100, width: 500, roundedBorder: 50, textSize: 30, scaleWidthFactor: 2,),            
              TravelButton(color: Colors.green, icon: Icons.navigate_next, label: 'Suivant', link: '/recap', height: 100, width: 500, roundedBorder: 50, textSize: 30, scaleWidthFactor: 2,),
            ],
          ),
      ],
    ),
  ),
)

    );
  }
}