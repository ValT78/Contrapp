import 'dart:math';
import 'package:flutter/material.dart';
import 'package:diacritic/diacritic.dart';

class MainSearchBar extends StatefulWidget {
  final String label;
  final List<String> storeList;
  final double yPosition;

  final void Function(String) addElement;
  final void Function(String) createNewElement;
  final void Function(String) deleteElement;

  const MainSearchBar({super.key, required this.label, required this.storeList, required this.addElement, required this.createNewElement, required this.deleteElement, required this.yPosition});

  @override
  MainSearchBarState createState() => MainSearchBarState();
}



class MainSearchBarState extends State<MainSearchBar> {

  //Les variables pour la barre de recherche
  final FocusNode _searchFocusNode = FocusNode();
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";

  List<String> _searchList = []; // Liste des résultats de la recherche
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
    _searchList = List<String>.from(widget.storeList);
    super.initState();
  }

// Corps du widget
  @override
Widget build(BuildContext context) {
  return Center(
    child: LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: _isSearching
              ? min(
                  (90 + 50 * ((_searchList.length + 3) ~/ 2)).toDouble(),
                  MediaQuery.of(context).size.height - widget.yPosition,
                )
              : 72,
          margin: const EdgeInsets.all(20.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: _isSearching ? BorderRadius.circular(35) : BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Colors.grey[300]!.withOpacity(0.5),
                spreadRadius: 10,
                blurRadius: 14,
                offset: const Offset(5, -5),
              ),
            ],
          ),
          child: Column(
            children: <Widget>[
              TextField(
                focusNode: _searchFocusNode,
                controller: _filter,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: widget.label,
                ),
                onSubmitted: (value) {
                  setState(() {
                    if (_searchList.isNotEmpty) {
                      widget.addElement(_searchList[0]);
                      _pressEnter();
                    } else if (_searchText.isNotEmpty) {
                      widget.createNewElement(_searchText);
                      widget.storeList.add(_searchText);
                      _pressEnter();
                    }
                  });
                },
              ),
              _buildSearchList(),
            ],
          ),
        );
      },
    ),
  );
}

Widget _buildSearchList() {
  if (!_isSearching) {
    return const SizedBox();
  }
  if (_searchText.isNotEmpty) {
    _searchList = filterSearchResults(widget.storeList, _searchText);
  } else {
    _searchList = widget.storeList;
  }

  return Expanded(
    child: GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 17, // Ajustez ceci pour contrôler la hauteur des éléments
        mainAxisExtent: 60,

      ),
      itemCount: _searchList.length + (_searchText.isNotEmpty ? 1 : 0),
      itemBuilder: (BuildContext context, int index) {
        if (index == _searchList.length && _searchText.isNotEmpty) {
          return InkWell(
            onHover: (value) {
              setState(() {
                _isLoading = value;
              });
            },
            onTap: () {
              setState(() {
                widget.createNewElement(_searchText);
                widget.storeList.add(_searchText);
                _pressEnter();
              });
            },
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
          return InkWell(
            onHover: (value) {
              setState(() {
                _isLoading = value;
              });
            },
            onTap: () {
              setState(() {
                widget.addElement(_searchList[index]);
                _pressEnter();
              });
            },
            child: SizedBox(
              height: 100,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(_searchList[index], style: const TextStyle(fontSize: 20), textAlign: TextAlign.center,),
                    ),
                  ),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.red,
                      ),
                      onPressed: () async {
                        await showDialog(
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
                                    setState(() {
                                      widget.storeList.remove(_searchList[index]);
                                      widget.deleteElement(_searchList[index]);
                                    });
                                    Navigator.of(context).pop(true);
                                  },
                                ),
                              ],
                            );
                          },
                        );
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



  void _pressEnter() {
    _searchFocusNode.unfocus();
    _filter.clear();
    _isLoading = false;
  }



List<String> filterSearchResults(List<String> searchList, String query) {
  query = removeDiacritics(query.toLowerCase());
  List<String> queryWords = query.split(RegExp(r'\W+')); // Diviser la requête sur les caractères non alphanumériques

  return searchList.where((entry) {
    String lowerEntry = removeDiacritics(entry.toLowerCase());
    List<String> entryWords = lowerEntry.split(RegExp(r'\W+')); // Diviser l'entrée sur les caractères non alphanumériques

    // Vérifier si chaque mot de la requête correspond au début de l'un des mots de l'entrée
    bool matches = queryWords.every((queryWord) {
      return entryWords.any((entryWord) => entryWord.startsWith(queryWord));
    });

    return matches;
  }).toList();
}



}