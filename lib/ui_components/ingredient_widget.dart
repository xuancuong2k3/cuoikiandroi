import 'package:flutter/material.dart';
import 'package:cocktailapp/constants.dart';
import 'package:cocktailapp/services/ingredient.dart';

class IngredientWidget extends StatelessWidget {
  IngredientWidget({required this.ingredientList});
  final List<Ingredient> ingredientList;

  Widget createTable() {
    List<TableRow> rows = [];

    for (int i = 0; i < ingredientList.length; i++) {
      rows.add(
        TableRow(
          children: [
            Center(
              child: Text(ingredientList[i].name.toString()),
            ),
            Center(
              child: Text(ingredientList[i].mesure.toString()),
            ),
          ],
        ),
      );
    }

    return Table(children: rows);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Ingredients",
          style: kTableTextStyle,
        ),
        SizedBox(
          height: 30,
        ),
        Expanded(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: createTable(),
          ),
        ),
      ],
    );
  }
}