import 'package:contrapp/common_tiles/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importez le package intl
import 'package:contrapp/main.dart'; // Importez le fichier main.dart
import 'package:contrapp/common_tiles/super_title.dart'; // Importez le fichier super_title.dart

class CommonForm extends StatefulWidget {
  const CommonForm({super.key});

  static CommonFormState? of(BuildContext context) => context.findAncestorStateOfType<CommonFormState>();

  @override
  CommonFormState createState() => CommonFormState();
}

class CommonFormState extends State<CommonForm> {  

  // // Création des FocusNodes
  // late FocusNode entrepriseFocusNode;
  // late FocusNode adresse1FocusNode;
  // late FocusNode adresse2FocusNode;
  // late FocusNode matriculeFocusNode;
  // late FocusNode capitalFocusNode;
  // late FocusNode dateFocusNode;
  // late FocusNode versionContratFocusNode;

  //  // Création des TextEditingController
  // late TextEditingController adresse1Controller;
  // late TextEditingController adresse2Controller;
  // late TextEditingController matriculeController;
  // late TextEditingController capitalController;
  // late TextEditingController dateController;
  // late TextEditingController versionContratController;

  @override
  void initState() {
    super.initState();

    // // Initialisation des FocusNodes
    // entrepriseFocusNode = FocusNode();
    // adresse1FocusNode = FocusNode();
    // adresse2FocusNode = FocusNode();
    // matriculeFocusNode = FocusNode();
    // capitalFocusNode = FocusNode();
    // dateFocusNode = FocusNode();
    // versionContratFocusNode = FocusNode();

    // // Initialisation des TextEditingController avec les valeurs actuelles
    // adresse1Controller = TextEditingController(text: variablesContrat['adresse1']);
    // adresse2Controller = TextEditingController(text: variablesContrat['adresse2']);
    // matriculeController = TextEditingController(text: variablesContrat['matricule']);
    // capitalController = TextEditingController(text: variablesContrat['capital'] == 0 ? '' : variablesContrat['capital'].toString());
    // dateController = TextEditingController(text: variablesContrat['date']);
    // versionContratController = TextEditingController(text: variablesContrat['versionContrat'].toString());

    // // Demande le focus sur le premier champ du formulaire
    // entrepriseFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // Nettoyage des FocusNodes
    // entrepriseFocusNode.dispose();
    // adresse1FocusNode.dispose();
    // adresse2FocusNode.dispose();
    // matriculeFocusNode.dispose();
    // capitalFocusNode.dispose();
    // dateFocusNode.dispose();
    // versionContratFocusNode.dispose();

    // // Nettoyage du TextEditingController
    // dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.fromLTRB(20, 10, 20, 20),
        padding: const EdgeInsets.all(20),
        width: 1000, // Définissez la largeur de votre choix
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black, width: 2),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.8), // Increase opacity to make the shadow more visible
              spreadRadius: 10,
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
              children: <Widget>[
                const SuperTitle(title: 'Informations sur l\'entreprise', color: Colors.purple),
                const SizedBox(height: 20),
                CustomFormField(
                  color: Colors.purple, 
                  icon: Icons.business, 
                  textSize: 50, 
                  height: 100, 
                  label: "Nom de l'entreprise", 
                  initValue: variablesContrat['entreprise'],
                  onChanged: (value) {
                    variablesContrat['entreprise'] = value;
                  },
                ),
                const SizedBox(height: 20,),
                Row(
                  children: <Widget>[
                    Expanded(child:
                    CustomFormField(
                      color: Colors.blue, 
                      icon: Icons.location_on, 
                      textSize: 50, 
                      height: 100, 
                      label: "Adresse 1", 
                      initValue: variablesContrat['adresse1'],
                      onChanged: (value) {
                        variablesContrat['adresse1'] = value;
                      },
                    ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(child:
                    CustomFormField(
                      color: Colors.blue, 
                      icon: Icons.location_on, 
                      textSize: 50, 
                      height: 100, 
                      label: "Adresse 2", 
                      initValue: variablesContrat['adresse2'],
                      onChanged: (value) {
                        variablesContrat['adresse2'] = value;
                      },
                    ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1, // Le widget orange occupe 1/3 de l'espace disponible
                      child: CustomFormField(
                        color: Colors.green, 
                        icon: Icons.euro, 
                        textSize: 50, 
                        height: 100, 
                        label: "Capital", 
                        initValue: variablesContrat['capital'],
                        onChanged: (value) {
                          variablesContrat['capital'] = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2, // Le widget jaune occupe 2/3 de l'espace disponible
                      child: CustomFormField(
                        color: Colors.lightGreen, 
                        icon: Icons.confirmation_num, 
                        textSize: 50, 
                        height: 100, 
                        label: "Matricule", 
                        initValue: variablesContrat['matricule'],
                        onChanged: (value) {
                          variablesContrat['matricule'] = value;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const SuperTitle(title: 'Date et Version du Contrat', color: Colors.red),
                const SizedBox(height: 20),

                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1, // Le widget magenta occupe 1/2 de l'espace disponible
                      child: CustomFormField(
                        color: Colors.pink, 
                        icon: Icons.description, 
                        textSize: 50, 
                        height: 100, 
                        label: "Version du contrat", 
                        initValue: variablesContrat['versionContrat'],
                        onChanged: (value) {
                          variablesContrat['versionContrat'] = value;
                        },
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3, // Le widget rouge occupe 1/2 de l'espace disponible
                      child: CustomFormField(
                        color: Colors.red, 
                        icon: Icons.calendar_today, 
                        textSize: 50, 
                        height: 100, 
                        label: "Date du contrat", 
                        initValue: variablesContrat['date'],
                        onChanged: (value) {
                          variablesContrat['date'] = value;
                        },
                        onTap: onTapCalendar,
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
      );    
  }

  void onTapCalendar(TextEditingController controller) async {
    final selectedDate = await showDatePicker(
      context: context,
      initialDate: DateFormat('dd/MM/yyyy').parse(variablesContrat['date']),
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (selectedDate != null) {
      setState(() {
        controller.text = DateFormat('dd/MM/yyyy').format(selectedDate);
      });
    }
  }
  
}
