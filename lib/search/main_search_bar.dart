import 'package:contrapp/object/equipment.dart';
import 'package:flutter/material.dart';
import 'package:contrapp/main.dart';
import 'package:provider/provider.dart';
import 'package:contrapp/object/equip_list.dart';
import 'package:contrapp/pages/equip_page.dart';

class MainSearchBar extends StatefulWidget {
  const MainSearchBar({super.key});

  @override
  MainSearchBarState createState() => MainSearchBarState();
}



class MainSearchBarState extends State<MainSearchBar> {

  //Les variables pour la barre de recherche
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";

  List<Equipment> _searchList = []; // Liste des résultats de la recherche
  bool _isLoading = false; // Attend quand on clique sur un élément avant de fermer la barre de recherche
  bool _isSearching = false; // Si la barre de recherche est active

  // Constructeur de la classe
  //Gère les changements de focus dans la barre de recherche
  MainSearchBarState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
      });
    });
    _searchFocusNode.addListener(() {
    if (_isLoading) {

    Future.delayed(const Duration(milliseconds: 400), () {
      if (!mounted) return;
      setState(() {
        _isSearching = _searchFocusNode.hasFocus;
        _isLoading = false;
      });
    });
  }
  else {
    setState(() {
      _isSearching = _searchFocusNode.hasFocus;
    });
  }
  });
  }

  @override
  void initState() {
    _searchList = equipToPick.equipList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
  return Center(
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8, // Occupera 80% de la largeur de l'écran
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.all(20.0),
              child: TextField(
                focusNode: _searchFocusNode,
                controller: _filter,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Ajouter un équipement...',
                ),
                onSubmitted: (value) { 
                  if (_searchList.isNotEmpty) {
                    // Si la liste n'est pas vide, déclencher l'action de la première entrée
                    equipPicked.add(_searchList[0]);
                    _searchFocusNode.unfocus();
                    _filter.clear();
                    _isLoading = false;
                  } else if (_searchText.isNotEmpty) {
                    // Si la liste est vide mais _searchText n'est pas vide, déclencher l'action du bouton "Ajouter"
                    Equipment newEquip = Equipment(equipName: _searchText);
                    equipPicked.add(newEquip);
                    equipToPick.add(newEquip);
                    _searchFocusNode.unfocus();
                    _filter.clear();
                    _isLoading = false;
                  }
                },
              ),
            ),
            _buildSearchList(),
          ],
        ),
      )
    );
  }


  Widget _buildSearchList() {
    if(!_isSearching) {
      return const SizedBox();
    }
    if (_searchText.isNotEmpty) {
      _searchList = filterSearchResults(equipToPickList, _searchText);
    }
    else {
      _searchList = equipToPickList;
    }

    return Expanded(
  child: GridView.builder(
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2, // Nombre de colonnes
      childAspectRatio: 15, // Ajustez ceci pour contrôler la largeur des éléments
    ),
    itemCount: _searchList.length + (_searchText.isNotEmpty ? 1 : 0), // Ajoutez 1 pour l'élément "Ajouter" si _searchText n'est pas vide
    itemBuilder: (BuildContext context, int index) {
      if (index == _searchList.length && _searchText.isNotEmpty) {
        // Case "Ajouter"
        return InkWell(
          onHover: (value) => {
            setState(() {
              _isLoading = value;
            })
          },
          onTap: () {
            equipPicked.add(_searchText);
            equipToPickList.add(_searchText);
            const EquipPage().modifyApp();
            _searchFocusNode.unfocus();
            _filter.clear();
            _isLoading = false;
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.green,
              border: Border.all(color: Colors.green[900]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.add, color: Colors.white),
                  Text("Ajouter '$_searchText'", style: const TextStyle(color: Colors.white, fontSize: 20)),
                ],
              ),
            ),
          ),
        );
      } else {
        // Autres éléments de la liste
        return InkWell(
          onHover: (value) => {
            setState(() {
              _isLoading = value;
            })
          },
          onTap: () {
            equipPicked.add(_searchList[index]);
            _searchFocusNode.unfocus();
            _filter.clear();
            _isLoading = false;
          },
          child: SizedBox(
            height: 100, // Définissez la hauteur souhaitée ici
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Center(
                    child: Text(_searchList[index], style: const TextStyle(fontSize: 20)),
                  ),
                ),
                Center(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.red, // foreground
                    ),
                    onPressed: () async {
                      bool? confirm = await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirmation"),
                            content: Text("Supprimer ${_searchList[index]} ?"),
                            actions: <Widget>[
                              TextButton(
                                child: const Text("Non"),
                                onPressed: () {
                                  Navigator.of(context).pop(false);
                                },
                              ),
                              TextButton(
                                child: const Text("Oui"),
                                onPressed: () {
                                  Navigator.of(context).pop(true);
                                },
                              ),
                            ],
                          );
                        },
                      );

                      if (confirm == true) {
                        setState(() {
                          equipToPick.equipList.remove(_searchList[index]);
                        });
                        await const EquipPage().modifyApp();
                      }
                    },
                    child: const Icon(Icons.delete),
                  ),
                ),

              ],
            ),
          ),
        );
      }
    },
  ),
);



  }

  // Vérifier si un mot contient tous les caractères d'une requête
  bool containsAllCharacters(String word, String query) {
    Map<String, int> wordCharCount = {};
    Map<String, int> queryCharCount = {};

    // Compter les occurrences de chaque caractère dans le mot
    for (var char in word.split('')) {
      wordCharCount[char] = (wordCharCount[char] ?? 0) + 1;
    }

    // Compter les occurrences de chaque caractère dans la requête
    for (var char in query.split('')) {
      queryCharCount[char] = (queryCharCount[char] ?? 0) + 1;
    }

    // Vérifier si le mot contient au moins autant de chaque caractère que la requête
    for (var char in queryCharCount.keys) {
      if (wordCharCount[char] == null || wordCharCount[char]! < queryCharCount[char]!) {
        return false;
      }
    }

    return true;
  }

  // Filtrer les résultats de la recherche
  List<String> filterSearchResults(List<String> searchList, String query) {
    return searchList.where((word) => containsAllCharacters(word, query)).toList();
  }

}