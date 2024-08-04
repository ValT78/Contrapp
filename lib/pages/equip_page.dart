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
        child: Stack(
          children: [
            Center(child:
            Column(
              children: [
                const SizedBox(
                  height: 100,
                ),

                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: MediaQuery.of(context).size.height - 220,
                  child: const SelectedEquip(),
                ),
              ],
            ),
          ),
            const MainSearchBar(), 
          ],
        )
      )
    );
  }

}