// navbar.dart
import 'package:flutter/material.dart';


class CustomNavBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomNavBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
  return AppBar(
    
    backgroundColor: Colors.yellow,
    leading: GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/home');
      },
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        
        child: Container(
          height: 30.0, // Ajustez la hauteur comme vous le souhaitez
          width: 10.0, // Ajustez la largeur comme vous le souhaitez
          child: Stack(
            children: [
              SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Image.asset('assets/smallLogo.png', fit: BoxFit.cover),
              ),
              const Positioned(
                right: 10,
                bottom: 10,
                width: 25,
                height: 25,
                child: Icon(Icons.home),
              ),
            ],
          ),
        ),
      ),
    ),
    // Le reste de votre code AppBar...
  

    actions: [
      IconButton(
        icon: const Icon(Icons.save),
        onPressed: () {
          // Ajoutez votre logique de sauvegarde ici
        },
      ),
      IconButton(
        icon: const Icon(Icons.exit_to_app),
        onPressed: () {
          // Ajoutez votre logique de sortie ici
        },
      ),
    ],
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ElevatedButton(
          child: const Text('Common'),
          onPressed: () {
            Navigator.pushNamed(context, '/common');
          },
        ),
        ElevatedButton(
          child: const Text('Equip'),
          onPressed: () {
            Navigator.pushNamed(context, '/equip');
          },
        ),
        ElevatedButton(
          child: const Text('Calendar'),
          onPressed: () {
            Navigator.pushNamed(context, '/calendar');
          },
        ),
        ElevatedButton(
          child: const Text('Attach'),
          onPressed: () {
            Navigator.pushNamed(context, '/attach');
          },
        ),
        ElevatedButton(
          child: const Text('Recap'),
          onPressed: () {
            Navigator.pushNamed(context, '/recap');
          },
        ),
      ],
    ),
  );
}


}
