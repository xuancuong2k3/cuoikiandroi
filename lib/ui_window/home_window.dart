// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, avoid_function_literals_in_foreach_calls

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cocktailapp/constants.dart';
import 'package:cocktailapp/services/cocktail_manager.dart';
import 'package:cocktailapp/services/ingredient.dart';
import 'package:cocktailapp/ui_components/ingredient_widget.dart';
import 'package:cocktailapp/ui_components/instruction_widget.dart';
import 'package:cocktailapp/ui_window/favorites_window.dart';
import 'package:cocktailapp/ui_window/search_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;

  List<String> docIDs = [];

  CocktailManager cm = CocktailManager(
      alcoholic: '',
      category: '',
      glassType: '',
      ingredients: [],
      instructions: '',
      name: '',
      pictureUrl: '');

  Future<CocktailManager> cocktailRandom() async {
    var network = await get(Uri.parse(kRandomUrl));
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
    ingrdientList.removeWhere(
        (element) => element.name == null && element.mesure == null);
    ingrdientList.forEach((element) {
      element.mesure ??= ' ';
    });
    cm.ingredients = ingrdientList;
    return cm;
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _cocktailFuture = cocktailRandom();
  // }

  Future<List<String>> getDocID() async {
    await FirebaseFirestore.instance
        .collection('users')
        .where('email', isEqualTo: user?.email)
        .get()
        .then(
          (snapshot) => snapshot.docs.forEach((document) {
            docIDs.add(document.reference.id);
          }),
        );
    return docIDs;
  }
  // Future getName() async {
  //   await FirebaseFirestore.instance
  //       .collection('users')
  //       .doc(docIDs[0])
  //       .get()
  //       .then((snapshot) {
  //     if (snapshot.exists) {
  //       userName = snapshot.data()!['first name'];

  //       // Hiển thị tên người dùng
  //       print('Tên người dùng: $userName');
  //     } else {}
  //   });
  // }

  // Future<String?> getUserId() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   User? user = auth.currentUser;

  //   if (user != null) {
  //     String userID = user.uid;
  //     return userID;
  //   } else {
  //     // Người dùng chưa đăng nhập
  //     return 'null';
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    CollectionReference users = FirebaseFirestore.instance.collection('users');

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<List<String>>(
              future: getDocID(),
              builder: (context, snapshot) {
                if (docIDs.isNotEmpty) {
                  return FutureBuilder<DocumentSnapshot>(
                    future: users.doc(docIDs[0]).get(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text(snapshot.data!['first name'] +
                            ' ' +
                            snapshot.data!['last name']);
                      } else if (snapshot.hasError) {
                        return Text('Error');
                      } else {
                        return Text('Loading...');
                      }
                    },
                  );
                } else {
                  return Text('Loading...');
                }
              },
            ),
            GestureDetector(
              onTap: () {
                FirebaseAuth.instance.signOut();
              },
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.deepPurple,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.turned_in_not),
            onPressed: () async {
              // final querySnapshot = await FirebaseFirestore.instance
              //     .collection('users')
              //     .doc(docIDs[0])
              //     .get();
              // List<String> docs = querySnapshot.data()?['favorites'];
              // bool ischecked = false;
              // docs.forEach((item) {
              //   if (item == cm.name) {
              //     return;
              //   }
              // })
              final washingtonRef =
                  FirebaseFirestore.instance.collection('users').doc(docIDs[0]);
              washingtonRef.update({
                'favorites': FieldValue.arrayUnion([cm.name]),
              });
              setState(() {
                const text = 'Cocktails saved to Favorites';
                final snackBar = SnackBar(content: Text(text));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) {
                  return SearchWindow();
                }),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hi!',
                    style: TextStyle(fontSize: 20),
                  ),
                  FutureBuilder<List<String>>(
                    future: getDocID(),
                    builder: (context, snapshot) {
                      if (docIDs.isNotEmpty) {
                        return FutureBuilder<DocumentSnapshot>(
                          future: users.doc(docIDs[0]).get(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data!['first name'] +
                                    ' ' +
                                    snapshot.data!['last name'] +
                                    '\nAge: ' +
                                    snapshot.data!['age'].toString(),
                                style: TextStyle(fontSize: 20),
                              );
                            } else if (snapshot.hasError) {
                              return Text('Error');
                            } else {
                              return Text('Loading...');
                            }
                          },
                        );
                      } else {
                        return Text('Loading...');
                      }
                    },
                  ),
                  Text(user!.email.toString(), style: TextStyle(fontSize: 14))
                ],
              ),
            ),
            ListTile(
              title: Text('Favorites List'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FavoritesPage(
                            docID: docIDs[0],
                          )),
                );
              },
              leading: Icon(Icons.turned_in_not),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<CocktailManager>(
            future: cocktailRandom(),
            builder: (context, snapshot) {
              if (cm.name != '') {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Text(
                        'Cocktail for you: ' + cm.name,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),

                    //Cocktail Details
                    // Container(
                    //   padding: EdgeInsets.symmetric(horizontal: 20),
                    //   height: 40,
                    //   decoration: BoxDecoration(
                    //     color: kGroupBackgroundColor,
                    //   ),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     children: [
                    //       Text(cm.category),
                    //       Text('-'),
                    //       Text(cm.alcoholic),
                    //       Text('-'),
                    //       Text(cm.glassType),
                    //     ],
                    //   ),
                    // ),

                    //Cocktail Image
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: NetworkImage(cm.pictureUrl),
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
                        ingredientList: cm.ingredients,
                      ),
                    ),

                    //Cocktail Instructions
                    Container(
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      height: 200,
                      decoration: kBoxDecorationStyle,
                      child: InstructionWidget(
                        instructions: cm.instructions,
                      ),
                    ),
                  ],
                );
              } else {
                return Text('Loading...');
              }
            }),
      ),
    );
  }
}
