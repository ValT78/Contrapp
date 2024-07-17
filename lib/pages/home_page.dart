import 'package:auto_size_text/auto_size_text.dart';
import 'package:contrapp/custom_navbar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: CustomNavbar(height: 100,),
      ),
      body: Center(
  child: Expanded(
    child: AutoSizeText(
      'A really long String joqnfoiq nfoinqoifnioqjfioj siojfioqjiosfjioq jfoisjoifjqiojsoijfqiojs oifjqiojfois qjfoijqoijfsoisq joifjqsoijfoi qjoifqoifjoiqjf oiqjfoiq joijoi',
      minFontSize: 5,
      style: TextStyle(color: Colors.white, fontSize: 50),
      maxLines: 1,
    ),
  ),
)
    );
    }
}