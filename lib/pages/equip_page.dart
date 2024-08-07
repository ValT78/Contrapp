import 'package:contrapp/button/travel_button.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/search/main_search_bar.dart';
import 'package:contrapp/skeleton/selected_equip.dart';


class EquipPage extends StatelessWidget {
  const EquipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),
      body: Center(
        child: Column( 
          children: [
         Stack(
          children: [
            Center(child:
            Column(
              children: [
                const SizedBox(
                  height: 100,
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height - 320,
                  child: const SelectedEquip(),
                ),
              ],
            ),
          ),
            const MainSearchBar(), 
          ],
         ),
          const SizedBox(
            width: 1000,
            child: Row(
              children: <Widget>[              
                TravelButton(color: Colors.deepPurple, icon: Icons.navigate_before, label: 'Précédent', link: '/common', height: 100, roundedBorder: 50, textSize: 30),            
                TravelButton(color: Colors.green, icon: Icons.navigate_next, label: 'Suivant', link: '/calendar', height: 100, roundedBorder: 50, textSize: 30),
              ],
            ),
          ),
        
        ],
        ),
      )
    );
  }

}