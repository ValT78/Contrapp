import 'dart:async';
import 'dart:math';

import 'package:contrapp/common_tiles/bouncy_action_button.dart';
import 'package:contrapp/common_tiles/custom_form_field.dart';
import 'package:contrapp/common_tiles/super_title.dart';
import 'package:diacritic/diacritic.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MainSearchBar extends StatefulWidget {
  final String label;
  final List<String> storeList;
  final double yPosition;

  final void Function(String) addElement;
  final void Function(String) createNewElement;
  final void Function(String) deleteElement;
  final FutureOr<void> Function(String, String)? copyElement;

  const MainSearchBar({
    super.key,
    required this.label,
    required this.storeList,
    required this.addElement,
    required this.createNewElement,
    required this.deleteElement,
    required this.yPosition,
    this.copyElement,
  });

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
      } else {
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

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: _isSearching
                ? min(
                    (72 + 51 * ((_searchList.length + 3) / 2)).toDouble(),
                    MediaQuery.of(context).size.height - widget.yPosition,
                  )
                : 72,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.indigo[50],
              borderRadius: _isSearching
                  ? BorderRadius.circular(35)
                  : BorderRadius.circular(100),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[300]!.withValues(alpha: 0.5),
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
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[700],
                    ),
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
            return Material(
              color: Colors.transparent,
              child: Container(
                margin:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Ink(
                  decoration: BoxDecoration(
                    color: Colors.green[400],
                    border: Border.all(color: Colors.green[700]!, width: 2),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: InkWell(
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
                    borderRadius: BorderRadius.circular(8),
                    splashColor: const Color.fromARGB(255, 13, 32, 14)
                        .withValues(alpha: 0.2),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.add, color: Colors.white),
                          Text(
                            "Ajouter '$_searchText'",
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }

          final elementName = _searchList[index];

          return Material(
            color: Colors.transparent,
            child: InkWell(
              onHover: (value) {
                setState(() {
                  _isLoading = value;
                });
              },
              onTap: () {
                setState(() {
                  widget.addElement(elementName);
                  _pressEnter();
                });
              },
              hoverColor: Colors.grey.withValues(alpha: 0.2),
              child: SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Center(
                        child: Text(
                          elementName,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (widget.copyElement != null)
                          Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.blue,
                              ),
                              onPressed: () async {
                                final copiedName =
                                    await _showCopyElementDialog(elementName);
                                if (!mounted || copiedName == null) {
                                  return;
                                }

                                setState(() {
                                  widget.storeList.add(copiedName);
                                  _pressEnter();
                                });
                              },
                              child: const Icon(Icons.copy),
                            ),
                          ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () async {
                            final shouldDelete =
                                await _showDeleteElementDialog(elementName);
                            if (!mounted || !shouldDelete) {
                              return;
                            }

                            setState(() {
                              widget.deleteElement(elementName);
                              widget.storeList.remove(elementName);
                            });
                          },
                          child: const Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<String?> _showCopyElementDialog(String sourceName) async {
    final focusNode = FocusNode();
    final nameController = TextEditingController(text: '$sourceName - copie');
    final screenWidth = MediaQuery.of(context).size.width;

    final copiedName = await showDialog<String>(
      context: context,
      builder: (BuildContext context2) {
        String? errorText;

        return StatefulBuilder(
          builder: (context2, setDialogState) {
            return KeyboardListener(
              focusNode: focusNode,
              onKeyEvent: (KeyEvent event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.escape) {
                  Navigator.of(context2).pop();
                }
              },
              child: Dialog(
                child: Container(
                  width: screenWidth * 2 / 3,
                  height: MediaQuery.of(context2).size.height / 2,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SuperTitle(
                        title: 'Copier un équipement',
                        color: Colors.blue,
                        fontSize: 45,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.blue[200]!),
                        ),
                        child: Text(
                          'Équipement source : $sourceName',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.blue[900],
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      CustomFormField(
                        color: Colors.blue,
                        icon: Icons.drive_file_rename_outline,
                        textSize: 42,
                        width: screenWidth * 2 / 3 - 100,
                        label: 'Nouveau nom',
                        initValue: nameController.text,
                        controller: nameController,
                        onChanged: (String _) {
                          if (errorText != null) {
                            setDialogState(() {
                              errorText = null;
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 16),
                      if (errorText != null)
                        Text(
                          errorText!,
                          style: TextStyle(
                            color: Colors.red[800],
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TravelButton(
                            color: Colors.red,
                            icon: Icons.close,
                            label: 'Annuler',
                            roundedBorder: 16,
                            height: 110 * screenWidth / 1920,
                            width: screenWidth / 4.8,
                            textSize: 34 * screenWidth / 1920,
                            actionFunction: () {
                              Navigator.of(context2).pop();
                            },
                            scaleWidthFactor: 1,
                          ),
                          const SizedBox(width: 20),
                          TravelButton(
                            color: Colors.blue,
                            icon: Icons.copy,
                            label: 'Créer la copie',
                            roundedBorder: 16,
                            height: 110 * screenWidth / 1920,
                            width: screenWidth / 4.3,
                            textSize: 34 * screenWidth / 1920,
                            actionFunction: () async {
                              final newName = nameController.text.trim();
                              if (newName.isEmpty) {
                                setDialogState(() {
                                  errorText =
                                      'Le nouveau nom ne peut pas être vide.';
                                });
                                return;
                              }

                              if (_containsName(widget.storeList, newName)) {
                                setDialogState(() {
                                  errorText =
                                      'Un équipement avec ce nom existe déjà.';
                                });
                                return;
                              }

                              await widget.copyElement!(sourceName, newName);
                              if (context2.mounted) {
                                Navigator.of(context2).pop(newName);
                              }
                            },
                            scaleWidthFactor: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    focusNode.dispose();
    nameController.dispose();
    return copiedName;
  }

  Future<bool> _showDeleteElementDialog(String elementName) async {
    final focusNode = FocusNode();
    final screenWidth = MediaQuery.of(context).size.width;

    final shouldDelete = await showDialog<bool>(
          context: context,
          builder: (BuildContext context2) {
            return KeyboardListener(
              focusNode: focusNode,
              onKeyEvent: (KeyEvent event) {
                if (event is KeyDownEvent &&
                    event.logicalKey == LogicalKeyboardKey.escape) {
                  Navigator.of(context2).pop(false);
                }
              },
              child: Dialog(
                child: Container(
                  width: screenWidth * 2 / 3,
                  height: MediaQuery.of(context2).size.height / 2,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SuperTitle(
                        title: 'Suppression',
                        color: Colors.red,
                        fontSize: 45,
                      ),
                      const SizedBox(height: 24),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red[50],
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.red[200]!),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Supprimer "$elementName" ?',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red[900],
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Icon(
                                  Icons.warning_amber_rounded,
                                  color: Colors.red[800],
                                  size: 34,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    'Cette suppression est destructive et définitive. Les données associées à cet élément seront perdues.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.red[800],
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TravelButton(
                            color: Colors.yellow,
                            icon: Icons.undo,
                            label: 'Annuler',
                            roundedBorder: 16,
                            height: 110 * screenWidth / 1920,
                            width: screenWidth / 4.8,
                            textSize: 34 * screenWidth / 1920,
                            actionFunction: () {
                              Navigator.of(context2).pop(false);
                            },
                            scaleWidthFactor: 1,
                          ),
                          const SizedBox(width: 20),
                          TravelButton(
                            color: Colors.red,
                            icon: Icons.delete,
                            label: 'Supprimer',
                            roundedBorder: 16,
                            height: 110 * screenWidth / 1920,
                            width: screenWidth / 4.3,
                            textSize: 34 * screenWidth / 1920,
                            actionFunction: () {
                              Navigator.of(context2).pop(true);
                            },
                            scaleWidthFactor: 1,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ) ??
        false;

    focusNode.dispose();
    return shouldDelete;
  }

  void _pressEnter() {
    _searchFocusNode.unfocus();
    _filter.clear();
    _isLoading = false;
  }

  List<String> filterSearchResults(List<String> searchList, String query) {
    query = removeDiacritics(query.toLowerCase());
    List<String> queryWords = query.split(RegExp(r'\W+'));

    return searchList.where((entry) {
      String lowerEntry = removeDiacritics(entry.toLowerCase());
      List<String> entryWords = lowerEntry.split(RegExp(r'\W+'));

      bool matches = queryWords.every((queryWord) {
        return entryWords.any((entryWord) => entryWord.startsWith(queryWord));
      });

      return matches;
    }).toList();
  }

  bool _containsName(List<String> names, String candidate) {
    final normalizedCandidate =
        removeDiacritics(candidate.trim().toLowerCase());

    return names.any(
      (entry) =>
          removeDiacritics(entry.trim().toLowerCase()) == normalizedCandidate,
    );
  }
}
