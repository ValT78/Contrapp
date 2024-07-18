import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importez le package intl

class CommonForm extends StatefulWidget {
  const CommonForm({super.key});

  static CommonFormState? of(BuildContext context) => context.findAncestorStateOfType<CommonFormState>();

  @override
  CommonFormState createState() => CommonFormState();
}

class CommonFormState extends State<CommonForm> {
  final _formKey = GlobalKey<FormState>();
  String entreprise = '';
  String adresse1 = '';
  String adresse2 = '';
  String matricule = '';
  int capital = 0;
  DateTime date = DateTime.now();
  int versionContrat = 1;

  // Création des FocusNodes
  late FocusNode entrepriseFocusNode;
  late FocusNode adresse1FocusNode;
  late FocusNode adresse2FocusNode;
  late FocusNode matriculeFocusNode;
  late FocusNode capitalFocusNode;
  late FocusNode dateFocusNode;
  late FocusNode versionContratFocusNode;

   // Création des TextEditingController
  late TextEditingController entrepriseController;
  late TextEditingController adresse1Controller;
  late TextEditingController adresse2Controller;
  late TextEditingController matriculeController;
  late TextEditingController capitalController;
  late TextEditingController dateController;
  late TextEditingController versionContratController;

  @override
  void initState() {
    super.initState();

    // Initialisation des FocusNodes
    entrepriseFocusNode = FocusNode();
    adresse1FocusNode = FocusNode();
    adresse2FocusNode = FocusNode();
    matriculeFocusNode = FocusNode();
    capitalFocusNode = FocusNode();
    dateFocusNode = FocusNode();
    versionContratFocusNode = FocusNode();

    // Initialisation des TextEditingController avec les valeurs actuelles
    entrepriseController = TextEditingController(text: entreprise);
    adresse1Controller = TextEditingController(text: adresse1);
    adresse2Controller = TextEditingController(text: adresse2);
    matriculeController = TextEditingController(text: matricule);
    capitalController = TextEditingController(text: capital.toString());
    dateController = TextEditingController(text: DateFormat('dd/MM/yyyy').format(date));
    versionContratController = TextEditingController(text: versionContrat.toString());

    // Demande le focus sur le premier champ du formulaire
    entrepriseFocusNode.requestFocus();
  }

  @override
  void dispose() {
    // Nettoyage des FocusNodes
    entrepriseFocusNode.dispose();
    adresse1FocusNode.dispose();
    adresse2FocusNode.dispose();
    matriculeFocusNode.dispose();
    capitalFocusNode.dispose();
    dateFocusNode.dispose();
    versionContratFocusNode.dispose();

    // Nettoyage du TextEditingController
    dateController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        width: 1000, // Définissez la largeur de votre choix
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: <Widget>[
                TextFormField(
                  controller: entrepriseController,
                  decoration: InputDecoration(
                    labelText: 'Nom de l\'entreprise',
                    prefixIcon: Icon(Icons.business),
                  ),
                  onChanged: (value) {
                    entreprise = value;
                  },
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: TextFormField(
                        controller: adresse1Controller,
                        decoration: InputDecoration(
                          labelText: 'Adresse 1',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        onChanged: (value) {
                          adresse1 = value;
                        },
                      ),
                    ),
                    SizedBox(width: 10),
                    Expanded(
                      child: TextFormField(
                        controller: adresse2Controller,
                        decoration: InputDecoration(
                          labelText: 'Adresse 2',
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        onChanged: (value) {
                          adresse2 = value;
                        },
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  controller: matriculeController,
                  decoration: InputDecoration(
                    labelText: 'Matricule',
                    prefixIcon: Icon(Icons.confirmation_number),
                  ),
                  onChanged: (value) {
                    matricule = value;
                  },
                ),
                TextFormField(
                  controller: capitalController,
                  decoration: InputDecoration(
                    labelText: 'Capital (€)',
                    prefixIcon: Icon(Icons.euro_symbol),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    capital = int.tryParse(value) ?? 0;
                  },
                  validator: (value) {
                    if (value != null && int.tryParse(value) == null) {
                      return 'Veuillez entrer un nombre valide';
                    }
                    return null;
                  },
                ),
                const Text('Date et version du contrat'),
                TextFormField(
                  controller: dateController,
                  decoration: InputDecoration(
                    labelText: 'Date',
                    prefixIcon: Icon(Icons.date_range),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: date,
                      firstDate: DateTime(1900),
                      lastDate: DateTime.now(),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        date = selectedDate;
                        dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                      });
                    }
                  },
                ),
                TextFormField(
                  controller: versionContratController,
                  decoration: InputDecoration(
                    labelText: 'Version du contrat',
                    prefixIcon: Icon(Icons.description),
                  ),
                  onChanged: (value) {
                    versionContrat = int.parse(value);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
