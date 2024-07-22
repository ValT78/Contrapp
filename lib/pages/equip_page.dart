import 'package:flutter/material.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:contrapp/search/main_search_bar.dart' as main_search_bar;
import 'package:contrapp/skeleton/selected_equip.dart';

class EquipPage extends StatelessWidget {
  const EquipPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),
      body: Center(
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: 100,
                ),
                Expanded(
                  child: SelectedEquip(),
                ),
              ],
            ),
            main_search_bar.MainSearchBar(),


          ],
        )
      
      )
      
    );
  }

  

}