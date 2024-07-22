import 'package:flutter/material.dart';
import 'package:contrapp/main.dart';
import 'package:provider/provider.dart';
import 'package:contrapp/search/equip_list.dart';

class MainSearchBar extends StatefulWidget {
  const MainSearchBar({super.key});

  @override
  MainSearchBarState createState() => MainSearchBarState();
}

class MainSearchBarState extends State<MainSearchBar> {
  final TextEditingController _filter = TextEditingController();
  String _searchText = "";
  List<String> _searchList = [];

  bool _isSearching = false;

  MainSearchBarState() {
    _filter.addListener(() {
      setState(() {
        _searchText = _filter.text;
        print(_searchText); // Affiche le texte recherché dans la console
      });
    });
  }

  @override
  void initState() {
    _searchList = equipToPickList;
    super.initState();
  }

  @override
Widget build(BuildContext context) {
  return Stack(
    children: <Widget>[
      GestureDetector(
        onTap: () {
          setState(() {
            _isSearching = false;
          });
          FocusScope.of(context).requestFocus(FocusNode()); // Ferme le clavier
        },
        child: Container(
          color: Colors.transparent,
          height: double.infinity,
          width: double.infinity,
        ),
      ),
      Center(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            children: <Widget>[
              Container(
                margin: const EdgeInsets.all(20.0),
                child: TextField(
                  controller: _filter,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Ajouter un équipement...'),
                  onTap: () {
                    setState(() {
                      _isSearching = true;
                      _searchList = equipToPickList;
                    });
                  },
                ),
              ),
              _buildSearchList(),
            ],
          ),
        ),
      ),
    ],
  );
}


  Widget _buildSearchList() {
    if(!_isSearching) {
      return const SizedBox();
    }
    if (_searchText.isNotEmpty) {
      List<String> tempList = [];
      for (int i = 0; i < _searchList.length; i++) {
        if (_searchList[i].toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(_searchList[i]);
        }
      }
      _searchList = tempList;
    }
    else {
      _searchList = equipToPickList;
    }
    return Expanded(
  child: ListView.builder(
    itemCount: _searchList.length,
    itemBuilder: (BuildContext context, int index) {
      return ListTile(
        title: Text(_searchList[index]),
        trailing: ElevatedButton(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white, backgroundColor: Colors.red, // foreground
          ),
          onPressed: () {
            setState(() {
              _searchList.removeAt(index);
            });
          },
          child: const Icon(Icons.delete),
        ),
        onTap: () {
          Provider.of<EquipList>(context, listen: false).add(_searchList[index]);
        },
      );
    },
  ),
);

  }
}