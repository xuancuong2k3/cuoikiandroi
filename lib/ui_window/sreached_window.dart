import 'dart:convert';

import 'package:cocktailapp/constants.dart';
import 'package:cocktailapp/services/cocktail_manager.dart';
import 'package:cocktailapp/services/ingredient.dart';
import 'package:cocktailapp/ui_window/result_window.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class SearchedList extends StatefulWidget {
  final String name;
  final bool searchOption;

  const SearchedList({Key? key, required this.searchOption, required this.name})
      : super(key: key);

  @override
  State<SearchedList> createState() => _SearchedList();
}

class _SearchedList extends State<SearchedList> {
  late List<String> listCocktails = [];

  @override
  void initState() {
    super.initState();
    fetchListCocktails();
  }

  Future<void> fetchListCocktails() async {
    var network;
    widget.name.toLowerCase().replaceAll(' ', '_');
    if (widget.searchOption) {
      network = await get(Uri.parse(kMainUrl + widget.name));
    } else {
      network = await get(Uri.parse(kIngrediantUrl + widget.name));
    }
    List<String> listCocktail = [];
    var json = jsonDecode(network.body);
    for (int i = 0; i < json['drinks'].length; i++) {
      String strDrink = json['drinks'][i]['strDrink'];
      listCocktail.add(strDrink);
    }
    setState(() {
      listCocktails = listCocktail;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.searchOption
            ? 'Search by name: ${widget.name}'
            : 'Search by ingrediant: ${widget.name}'),
      ),
      body: ListView.builder(
        itemCount: listCocktails.length,
        itemBuilder: (context, index) {
          final cocktailName = listCocktails[index];
          return Card(
            child: ListTile(
              title: Text(
                cocktailName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              onTap: () async {
                if (cocktailName == null) return;

                cocktailName.toLowerCase().replaceAll(' ', '_');

                CocktailManager cm = CocktailManager(
                    name: '',
                    alcoholic: '',
                    category: '',
                    glassType: '',
                    ingredients: [],
                    instructions: '',
                    pictureUrl: '');

                var network = await get(Uri.parse(kMainUrl + cocktailName));

                var json = jsonDecode(network.body);

                cm.name = json['drinks'][0]['strDrink'];
                cm.alcoholic = json['drinks'][0]['strAlcoholic'];
                cm.glassType = json['drinks'][0]['strGlass'];
                cm.pictureUrl = json['drinks'][0]['strDrinkThumb'];
                cm.category = json['drinks'][0]['strCategory'];
                cm.instructions = json['drinks'][0]['strInstructions'];

                String strIngredientName, strIngredientMeasure;
                List<Ingredient> ingrdientList = [];

                for (int i = 1; i < 16; i++) {
                  strIngredientName = 'strIngredient' + i.toString();
                  strIngredientMeasure = 'strMeasure' + i.toString();

                  ingrdientList.add(
                    Ingredient(
                      name: json['drinks'][0][strIngredientName],
                      mesure: json['drinks'][0][strIngredientMeasure],
                    ),
                  );
                }

                ingrdientList.removeWhere((element) =>
                    element.name == null && element.mesure == null);

                ingrdientList.forEach((element) {
                  if (element.mesure == null) {
                    element.mesure = ' ';
                  }
                });

                cm.ingredients = ingrdientList;

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) {
                    return ResultWindow(
                        name: cm.name,
                        category: cm.category,
                        alcoholic: cm.alcoholic,
                        glassType: cm.glassType,
                        pictureUrl: cm.pictureUrl,
                        instructions: cm.instructions,
                        ingredients: cm.ingredients);
                  }),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
