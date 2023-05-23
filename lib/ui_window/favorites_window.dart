import 'dart:convert';

import 'package:cocktailapp/constants.dart';
import 'package:cocktailapp/services/cocktail_manager.dart';
import 'package:cocktailapp/services/ingredient.dart';
import 'package:cocktailapp/ui_window/result_window.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart';

class FavoritesPage extends StatefulWidget {
  final String docID;

  const FavoritesPage({Key? key, required this.docID}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<String> favoriteCocktails = [];

  @override
  void initState() {
    super.initState();
    fetchFavoriteCocktails();
  }

  Future<void> fetchFavoriteCocktails() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.docID)
        .get();

    List<dynamic> docs = querySnapshot.data()?['favorites'];

    List<String> cocktailNames = docs.map((item) => item.toString()).toList();

    setState(() {
      favoriteCocktails = cocktailNames;
    });
  }

  Future<void> confirmDelete(String cocktailName) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete $cocktailName?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text(
                'Delete',
                style: TextStyle(color: Colors.red),
              ),
              onPressed: () async {
                final washingtonRef = FirebaseFirestore.instance
                    .collection('users')
                    .doc(widget.docID);
                await washingtonRef.update({
                  "favorites": FieldValue.arrayRemove([cocktailName]),
                });
                const text = 'Cocktails Removed from Favorites';
                final snackBar = SnackBar(content: Text(text));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop();

                // Cập nhật danh sách cocktail yêu thích sau khi xóa
                await fetchFavoriteCocktails();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorites List'),
      ),
      body: ListView.builder(
        itemCount: favoriteCocktails.length,
        itemBuilder: (context, index) {
          final cocktailName = favoriteCocktails[index];
          return Card(
            child: ListTile(
              title: Text(
                cocktailName,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  Icons.delete,
                  color: Colors.red,
                ),
                onPressed: () {
                  confirmDelete(cocktailName);
                },
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
