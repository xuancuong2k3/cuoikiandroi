// ignore_for_file: prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cocktailapp/constants.dart';
import '../services/ingredient.dart';
import 'package:cocktailapp/ui_components/instruction_widget.dart';
import 'package:cocktailapp/ui_components/ingredient_widget.dart';

class ResultWindow extends StatefulWidget {
  final String name;
  final String category;
  final String alcoholic;
  final String glassType;
  final String pictureUrl;
  final String instructions;
  final List<Ingredient> ingredients;

  ResultWindow({
    required this.name,
    required this.category,
    required this.alcoholic,
    required this.glassType,
    required this.pictureUrl,
    required this.instructions,
    required this.ingredients,
  });

  @override
  _ResultWindowState createState() => _ResultWindowState();
}

class _ResultWindowState extends State<ResultWindow> {
  bool isChecked = false;
  User? user = FirebaseAuth.instance.currentUser;
  late String docIDs;

  Future<void> fetchFavorites() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get()
        .then((snapshot) => snapshot.docs.forEach((document) {
              docIDs = document.reference.id;
            }));

    final querySnapshot =
        await FirebaseFirestore.instance.collection('users').doc(docIDs).get();
    List<dynamic> docs = querySnapshot.data()?['favorites'];
    docs.forEach((item) {
      if (item == widget.name) {
        isChecked = true;
      } else {
        isChecked = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            widget.name,
            style: kHeaderTextStyle,
          ),
          elevation: 0,
          actions: [
            FutureBuilder<void>(
              future: fetchFavorites(),
              builder: (context, snapshot) {
                if (true) {
                  return IconButton(
                    icon: isChecked
                        ? Icon(Icons.turned_in_sharp)
                        : Icon(Icons.turned_in_not),
                    onPressed: () async {
                      final washingtonRef = FirebaseFirestore.instance
                          .collection('users')
                          .doc(docIDs);
                      if (!isChecked) {
                        washingtonRef.update({
                          'favorites': FieldValue.arrayUnion([widget.name]),
                        });
                        const text = 'Cocktails saved to Favorites';
                        final snackBar = SnackBar(content: Text(text));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        washingtonRef.update({
                          "favorites": FieldValue.arrayRemove([widget.name]),
                        });
                        const text = 'Cocktails Removed to Favorites';
                        final snackBar = SnackBar(content: Text(text));
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      setState(() {
                        isChecked = !isChecked;
                      });
                    },
                  );
                } else {
                  return Text('Error');
                }
              },
            ),
          ]),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            //Cocktail Details
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              height: 40,
              decoration: BoxDecoration(
                color: kGroupBackgroundColor,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.category),
                  Text('-'),
                  Text(widget.alcoholic),
                  Text('-'),
                  Text(widget.glassType),
                ],
              ),
            ),

            //Cocktail Image
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(widget.pictureUrl),
                ),
              ),
            ),

            //Cocktail Ingredients
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 200,
              decoration: kBoxDecorationStyle,
              child: IngredientWidget(
                ingredientList: widget.ingredients,
              ),
            ),

            //Cocktail Instructions
            Container(
              padding: EdgeInsets.all(20),
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 200,
              decoration: kBoxDecorationStyle,
              child: InstructionWidget(
                instructions: widget.instructions,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
