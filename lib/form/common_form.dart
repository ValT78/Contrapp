import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importez le package intl
import 'package:contrapp/main.dart'; // Importez le fichier main.dart

class CommonForm extends StatefulWidget {
  const CommonForm({super.key});

  static CommonFormState? of(BuildContext context) => context.findAncestorStateOfType<CommonFormState>();

  @override
  CommonFormState createState() => CommonFormState();
}

class CommonFormState extends State<CommonForm> {
  final _formKey = GlobalKey<FormState>();

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
      child: SingleChildScrollView(
        child:
      Column(
        children: [
      Container(
        margin: const EdgeInsets.fromLTRB(20, 30, 20, 20),
        padding: const EdgeInsets.all(20),
        width: 1000, // Définissez la largeur de votre choix
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(20),
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
                Text(
                  'Informations sur l\'Entreprise',
                  style: TextStyle(
                    color: Colors.purple[900],
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    shadows: const [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.purple[600],
                    decorationStyle: TextDecorationStyle.dotted,
                  ),
                ),
                const SizedBox(height: 20),

                Container(
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                  color: Colors.purple[50],
                  borderRadius: BorderRadius.circular(10), // Add rounded edge
                  ),
                  child: TextFormField(
                    controller: entrepriseController,
                    maxLines: 1,
                    focusNode: entrepriseFocusNode,
                    decoration: InputDecoration(
                      labelText: 'Nom de l\'entreprise',
                      labelStyle: TextStyle(
                        fontSize: 20.0, // Augmenter la taille du label
                        fontWeight: FontWeight.bold, // Mettre le label en gras
                        color: Colors.purple[600], // Changer la couleur du label
                      ),
                      prefixIcon: Icon(Icons.business, color: Colors.purple[600], size: 60.0), // Changer la couleur et la taille de l'icône
                    ),
                    style: TextStyle(
                      fontSize: 30.0, // Augmenter la taille du texte entré
                      color: Colors.purple[900], // Changer la couleur du texte entré
                      fontWeight : FontWeight.bold
                    ),
                    onChanged: (value) {
                      setState(() {
                        entreprise = value;
                      });
                    },
                     onFieldSubmitted: (term){
                      // Lorsque vous appuyez sur Entrée, il passe au champ suivant
                      entrepriseFocusNode.unfocus();
                      FocusScope.of(context).requestFocus(adresse1FocusNode);
                    },
                  ),
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 5, bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.blue[50], // Changer la couleur de fond en vert
                          borderRadius: BorderRadius.circular(10), // Ajouter des bords arrondis
                        ),
                        child: TextFormField(
                          controller: adresse1Controller,
                          focusNode: adresse1FocusNode,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Adresse 1',
                            labelStyle: TextStyle(
                              fontSize: 16.0, // Augmenter la taille du label
                              fontWeight: FontWeight.bold, // Mettre le label en gras
                              color: Colors.blue[600], // Changer la couleur du label en vert
                            ),
                            prefixIcon: Icon(Icons.location_on, color: Colors.blue[600], size: 60.0), // Changer la couleur et la taille de l'icône en vert
                          ),
                          style: TextStyle(
                            fontSize: 20.0, // Augmenter la taille du texte entré
                            color: Colors.blue[900], // Changer la couleur du texte entré en vert
                            fontWeight : FontWeight.bold
                          ),
                          onChanged: (value) {
                            setState(() {
                              adresse1 = value;
                            });
                          },
                          onFieldSubmitted: (term){
                            // Lorsque vous appuyez sur Entrée, il passe au champ suivant
                            adresse1FocusNode.unfocus();
                            FocusScope.of(context).requestFocus(adresse2FocusNode);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(left: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.blue[50], // Changer la couleur de fond en vert
                          borderRadius: BorderRadius.circular(10), // Ajouter des bords arrondis
                        ),
                        child: TextFormField(
                          controller: adresse2Controller,
                          focusNode: adresse2FocusNode,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Adresse 2',
                            labelStyle: TextStyle(
                              fontSize: 16.0, // Augmenter la taille du label
                              fontWeight: FontWeight.bold, // Mettre le label en gras
                              color: Colors.blue[500], // Changer la couleur du label en vert
                            ),
                            prefixIcon: Icon(Icons.location_on, color: Colors.blue[500], size: 60.0), // Changer la couleur et la taille de l'icône en vert
                          ),
                          style: TextStyle(
                            fontSize: 20.0, // Augmenter la taille du texte entré
                            color: Colors.blue[800], // Changer la couleur du texte entré en vert
                            fontWeight : FontWeight.bold
                          ),
                          onChanged: (value) {
                            setState(() {
                              adresse2 = value;
                            });
                          },
                          onFieldSubmitted: (term){
                            // Lorsque vous appuyez sur Entrée, il passe au champ suivant
                            adresse2FocusNode.unfocus();
                            FocusScope.of(context).requestFocus(capitalFocusNode);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1, // Le widget orange occupe 1/3 de l'espace disponible
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(right: 5, top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: Colors.green[100], // Changer la couleur de fond en orange
                          borderRadius: BorderRadius.circular(10), // Ajouter des bords arrondis
                        ),
                        child: TextFormField(
                          controller: capitalController,
                          focusNode: capitalFocusNode,
                          maxLines: 1,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Capital',
                            labelStyle: TextStyle(
                              fontSize: 20.0, // Augmenter la taille du label
                              fontWeight: FontWeight.bold, // Mettre le label en gras
                              color: Colors.green[600], // Changer la couleur du label en orange
                            ),
                            prefixIcon: Icon(Icons.euro_symbol, color: Colors.green[600], size: 60.0), // Changer la couleur et la taille de l'icône en orange
                          ),
                          style: TextStyle(
                            fontSize: 30.0, // Augmenter la taille du texte entré
                            color: Colors.green[700], // Changer la couleur du texte entré en orange
                            fontWeight : FontWeight.bold
                          ),
                          onChanged: (value) {
                            setState(() {
                              capital = int.tryParse(value) ?? 0;
                            });
                          },
                          onFieldSubmitted: (term){
                            // Lorsque vous appuyez sur Entrée, il passe au champ suivant
                            capitalFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(matriculeFocusNode);
                          },
                          validator: (value) {
                            if (value != null && int.tryParse(value) == null) {
                              return 'Veuillez entrer un nombre valide';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 2, // Le widget jaune occupe 2/3 de l'espace disponible
                      child: Container(
                        margin: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.green[50], // Changer la couleur de fond en jaune
                          borderRadius: BorderRadius.circular(10), // Ajouter des bords arrondis
                        ),
                        child: TextFormField(
                          controller: matriculeController,
                          focusNode: matriculeFocusNode,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Matricule',
                            labelStyle: TextStyle(
                              fontSize: 20.0, // Augmenter la taille du label
                              fontWeight: FontWeight.bold, // Mettre le label en gras
                              color: Colors.green[600], // Changer la couleur du label en jaune
                            ),
                            prefixIcon: Icon(Icons.confirmation_number, color: Colors.green[600], size: 60.0), // Changer la couleur et la taille de l'icône en jaune
                          ),
                          style: TextStyle(
                            fontSize: 30.0, // Augmenter la taille du texte entré
                            color: Colors.green[800], // Changer la couleur du texte entré en jaune
                            fontWeight : FontWeight.bold
                          ),
                          onChanged: (value) {
                            setState(() {
                              matricule = value;
                            });
                          },
                          onFieldSubmitted: (term){
                            // Lorsque vous appuyez sur Entrée, il passe au champ suivant
                            matriculeFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(versionContratFocusNode);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Date et version du contrat',
                  style: TextStyle(
                    color: Colors.red[900],
                    fontSize: 50.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 2.0,
                    shadows: const [
                      Shadow(
                        blurRadius: 10.0,
                        color: Colors.black26,
                        offset: Offset(5.0, 5.0),
                      ),
                    ],
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.red[600],
                    decorationStyle: TextDecorationStyle.dotted,
                  ),
                ),
                const SizedBox(height: 20),

                Row(
                  children: <Widget>[
                    Expanded(
                      flex: 1, // Le widget magenta occupe 1/2 de l'espace disponible
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.pink[50], // Changer la couleur de fond en magenta
                          borderRadius: BorderRadius.circular(10), // Ajouter des bords arrondis
                        ),
                        child: TextFormField(
                          controller: versionContratController,
                          focusNode: versionContratFocusNode,
                          maxLines: 1,
                          decoration: InputDecoration(
                            labelText: 'Version du contrat',
                            labelStyle: TextStyle(
                              fontSize: 20.0, // Augmenter la taille du label
                              fontWeight: FontWeight.bold, // Mettre le label en gras
                              color: Colors.pink[600], // Changer la couleur du label en magenta
                            ),
                            prefixIcon: Icon(Icons.description, color: Colors.pink[600], size: 60.0), // Changer la couleur et la taille de l'icône en magenta
                          ),
                          style: TextStyle(
                            fontSize: 30.0, // Augmenter la taille du texte entré
                            color: Colors.pink[900], // Changer la couleur du texte entré en magenta
                            fontWeight : FontWeight.bold
                          ),
                          onChanged: (value) {
                            setState(() {
                              versionContrat = int.parse(value);
                            });
                          },
                          onFieldSubmitted: (term){
                            // Lorsque vous appuyez sur Entrée, il passe au champ suivant
                            versionContratFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(dateFocusNode);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      flex: 3, // Le widget rouge occupe 1/2 de l'espace disponible
                      child: Container(
                        height: 100,
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.red[50], // Changer la couleur de fond en rouge
                          borderRadius: BorderRadius.circular(10), // Ajouter des bords arrondis
                        ),
                        child: TextFormField(
                          controller: dateController,
                          maxLines: 1,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: 'Date',
                            labelStyle: TextStyle(
                              fontSize: 20.0, // Augmenter la taille du label
                              fontWeight: FontWeight.bold, // Mettre le label en gras
                              color: Colors.red[600], // Changer la couleur du label en rouge
                            ),
                            prefixIcon: Icon(Icons.date_range, color: Colors.red[600], size: 60.0), // Changer la couleur et la taille de l'icône en rouge
                          ),
                          style: TextStyle(
                            fontSize: 30.0, // Augmenter la taille du texte entré
                            color: Colors.red[900], // Changer la couleur du texte entré en rouge
                            fontWeight : FontWeight.bold
                          ),
                          onTap: () async {
                            final selectedDate = await showDatePicker(
                              context: context,
                              initialDate: date,
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                date = selectedDate;
                                dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
      ],
      ),
      ),
    );
  }
}
