import 'package:contrapp/button/custom_form_field.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importez le package intl
import 'package:contrapp/main.dart'; // Importez le fichier main.dart
import 'package:contrapp/button/super_title.dart'; // Importez le fichier super_title.dart

class CommonForm extends StatefulWidget {
  const CommonForm({super.key});

  static CommonFormState? of(BuildContext context) => context.findAncestorStateOfType<CommonFormState>();

  @override
  CommonFormState createState() => CommonFormState();
}

class CommonFormState extends State<CommonForm> {  

  // Création des FocusNodes
  late FocusNode entrepriseFocusNode;
  late FocusNode adresse1FocusNode;
  late FocusNode adresse2FocusNode;
  late FocusNode matriculeFocusNode;
  late FocusNode capitalFocusNode;
  late FocusNode dateFocusNode;
  late FocusNode versionContratFocusNode;

   // Création des TextEditingController
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
    adresse1Controller = TextEditingController(text: variablesContrat['adresse1']);
    adresse2Controller = TextEditingController(text: variablesContrat['adresse2']);
    matriculeController = TextEditingController(text: variablesContrat['matricule']);
    capitalController = TextEditingController(text: variablesContrat['capital'] == 0 ? '' : variablesContrat['capital'].toString());
    dateController = TextEditingController(text: variablesContrat['date']);
    versionContratController = TextEditingController(text: variablesContrat['versionContrat'].toString());

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
                  width: 300,
                  height: 100, 
                  label: "Nom de l'entreprise", 
                  initValue: variablesContrat['entreprise'],
                  onChanged: (value) {
                    variablesContrat['entreprise'] = value;
                  },
                ),
                const SizedBox(height: 20,),
                // Container(
                //   height: 100,
                //   padding: const EdgeInsets.all(10),
                //   margin: const EdgeInsets.only(bottom: 10),
                //   decoration: BoxDecoration(
                //   color: Colors.purple[50],
                //   borderRadius: BorderRadius.circular(10), // Add rounded edge
                //   ),
                //   child: TextFormField(
                //     controller: entrepriseController,
                //     maxLines: 1,
                //     focusNode: entrepriseFocusNode,
                //     decoration: InputDecoration(
                //       labelText: 'Nom de l\'entreprise',
                //       labelStyle: TextStyle(\'
                //         fontSize: 20.0, // Augmenter la taille du label
                //         fontWeight: FontWeight.bold, // Mettre le label en gras
                //         color: Colors.purple[600], // Changer la couleur du label
                //       ),
                //       enabledBorder: UnderlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Colors.purple[600]!,
                //           width: 3.0, // Augmentez cette valeur pour une barre plus haute

                //         ),
                //       ),
                //       focusedBorder: UnderlineInputBorder(
                //         borderSide: BorderSide(
                //           color: Colors.purple[300]!,
                //           width: 2.0,
                //         ),
                //       ),
                //       prefixIcon: Icon(Icons.business, color: Colors.purple[600], size: 60.0), // Changer la couleur et la taille de l'icône
                //     ),
                //     style: TextStyle(
                //       fontSize: 30.0, // Augmenter la taille du texte entré
                //       color: Colors.purple[700], // Changer la couleur du texte entré
                //       fontWeight : FontWeight.bold
                //     ),
                //     onChanged: (value) {
                //       setState(() {
                //         _whenFieldChanged('entreprise', value, false);
                //       });
                //     },
                //      onFieldSubmitted: (term){
                //       // Lorsque vous appuyez sur Entrée, il passe au champ suivant
                //       entrepriseFocusNode.unfocus();
                //       FocusScope.of(context).requestFocus(adresse1FocusNode);
                //     },
                //   ),
                // ),
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
                            // _whenFieldChanged('adresse1', value, false);
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
                            // _whenFieldChanged('adresse2', value, false);
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
                              // _whenFieldChanged('capital', value, true);
                            },
                          onFieldSubmitted: (term){
                            // Lorsque vous appuyez sur Entrée, il passe au champ suivant
                            capitalFocusNode.unfocus();
                            FocusScope.of(context).requestFocus(matriculeFocusNode);
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
                              // _whenFieldChanged('matricule', value, false);
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
                const SuperTitle(title: 'Date et Version du Contrat', color: Colors.red),
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
                              // _whenFieldChanged('versionContrat', value, true);
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
                                initialDate: DateFormat('dd/MM/yyyy').parse(variablesContrat['date']),
                              firstDate: DateTime.now().subtract(const Duration(days: 365)),
                                lastDate: DateTime.now().add(const Duration(days: 365)),
                            );
                            if (selectedDate != null) {
                              setState(() {
                                variablesContrat['date'] = DateFormat('dd/MM/yyyy').format(selectedDate);
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
      );    
  }

  
  
}
