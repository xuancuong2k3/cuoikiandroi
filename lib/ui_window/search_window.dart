// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';

import 'package:cocktailapp/constants.dart';
import 'package:cocktailapp/ui_window/result_window.dart';
import 'package:cocktailapp/ui_window/sreached_window.dart';
import 'package:flutter/material.dart';
import 'package:cocktailapp/services/cocktail_manager.dart';
import 'package:http/http.dart';

import '../services/ingredient.dart';

enum SearchOption {
  byName,
  byIngredient,
}

class SearchWindow extends StatefulWidget {
  @override
  _SearchWindow createState() => _SearchWindow();
}

class _SearchWindow extends State<SearchWindow> {
  String cocktailName = "";
  SearchOption searchOption = SearchOption.byName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: 150,
                ),
                Center(
                  child: Text(
                    "Cocktails",
                    style: TextStyle(fontSize: 70),
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Center(
                  child: DropdownButton<SearchOption>(
                    value: searchOption,
                    onChanged: (SearchOption? newValue) {
                      setState(() {
                        searchOption = newValue!;
                      });
                    },
                    items: <DropdownMenuItem<SearchOption>>[
                      DropdownMenuItem<SearchOption>(
                        value: SearchOption.byName,
                        child: Center(child: Text('Search by Name')),
                      ),
                      DropdownMenuItem<SearchOption>(
                        value: SearchOption.byIngredient,
                        child: Center(child: Text('Search by Ingredient')),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                TextField(
                  onChanged: (value) {
                    cocktailName = value;
                  },
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(20),
                    hintText: searchOption == SearchOption.byName
                        ? "Enter a Cocktail?"
                        : "Enter an Ingredient",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: kBorderSide,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: kBorderSide,
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (cocktailName == null) return;
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return SearchedList(
                          name: cocktailName,
                          searchOption: searchOption == SearchOption.byName);
                    }));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kComponentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: kButtonMinSize,
                  ),
                  child: Text("Search"),
                ),
                SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () async {
                    CocktailManager cm = CocktailManager(
                      alcoholic: '',
                      category: '',
                      glassType: '',
                      ingredients: [],
                      instructions: '',
                      name: '',
                      pictureUrl: '',
                    );

                    var network = await get(Uri.parse(kRandomUrl));

                    var json = jsonDecode(network.body);

                    cm.name = json['drinks'][0]['strDrink'];
                    cm.alcoholic = json['drinks'][0]['strAlcoholic'];
                    cm.glassType = json['drinks'][0]['strGlass'];
                    cm.pictureUrl = json['drinks'][0]['strDrinkThumb'];
                    cm.category = json['drinks'][0]['strCategory'];
                    cm.instructions = json['drinks'][0]['strInstructions'];

                    String strIngredientName, strIngredientMeasure;
                    List<Ingredient> ingredientList = [];

                    for (int i = 1; i < 16; i++) {
                      strIngredientName = 'strIngredient' + i.toString();
                      strIngredientMeasure = 'strMeasure' + i.toString();

                      ingredientList.add(
                        Ingredient(
                          name: json['drinks'][0][strIngredientName],
                          mesure: json['drinks'][0][strIngredientMeasure],
                        ),
                      );
                    }

                    ingredientList.removeWhere((element) =>
                        element.name == null && element.mesure == null);

                    ingredientList.forEach((element) {
                      if (element.mesure == null) {
                        element.mesure = ' ';
                      }
                    });

                    cm.ingredients = ingredientList;

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
                          ingredients: cm.ingredients,
                        );
                      }),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: kComponentColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    minimumSize: kButtonMinSize,
                  ),
                  child: Text("Random"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
