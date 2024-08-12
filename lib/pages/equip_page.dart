import 'package:contrapp/button/custom_form_field.dart';
import 'package:contrapp/button/travel_button.dart';
import 'package:contrapp/button/variable_indicator.dart';
import 'package:contrapp/main.dart';
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
         SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: Row(
              children: <Widget>[              
                const TravelButton(
                  color: Colors.deepPurple, 
                  icon: Icons.navigate_before, 
                  label: 'Précédent', 
                  link: '/common', 
                  height: 100, 
                  roundedBorder: 50, 
                  textSize: 30
                ),
                CustomFormField(
                  color: Colors.green, 
                  icon: Icons.access_time, 
                  textSize: 32, 
                  width: 150, 
                  onChanged: (double value) {
                    tauxHoraireNotifier.value = value;
                    for (var equip in equipPicked.equipList) {
                      equip.priceNotifier.value = (value * equip.hoursExpectedNotifier.value).toInt();
                    }
                    montantHT = equipPicked.equipList.fold(0, (sum, equip) => sum + equip.priceNotifier.value);
                  }, 
                  initValue: tauxHoraireNotifier.value, 
                  label: "Taux Horaire",
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: VariableIndicator(
                    color: Colors.green, 
                    icon: Icons.euro, 
                    variableNotifier: montantHTNotifier, 
                    textSize: 32, 
                    height: 50, 
                    width: 160,
                  ),
                ),
                VariableIndicator(
                  color: Colors.deepOrange, 
                  icon: Icons.timelapse, 
                  variableNotifier: hoursOfWorkNotifier, 
                  textSize: 32, 
                  height: 50, 
                  width: 170,
                ),
                const TravelButton(
                  color: Colors.green, 
                  icon: Icons.navigate_next, 
                  label: 'Suivant', 
                  link: '/calendar', 
                  height: 100, 
                  roundedBorder: 50, 
                  textSize: 30
                ),
              ],
            ),
          ),
          
        
        ],
        ),
      )
    );
  }

}