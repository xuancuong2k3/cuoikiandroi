import 'package:flutter/material.dart';

const kMainUrl = "https://www.thecocktaildb.com/api/json/v1/1/search.php?s=";
const kRandomUrl = "https://www.thecocktaildb.com/api/json/v1/1/random.php";
const kIngrediantUrl =
    "https://www.thecocktaildb.com/api/json/v1/1/filter.php?i=";
const kBackgroundColor = Color(0xFF1F2129);
const kComponentColor = Color(0xFF3C4D74);
const kGroupBackgroundColor = Color(0xFF383D4D);

const kHeaderTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w700,
);

const kListTextStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 16,
);

const kTableTextStyle = TextStyle(
  fontSize: 20,
  fontWeight: FontWeight.w500,
);

const kBorderSide = BorderSide(
  color: kComponentColor,
  width: 5,
);

const kBoxDecorationStyle = BoxDecoration(
  color: kGroupBackgroundColor,
  borderRadius: BorderRadius.all(
    Radius.circular(30),
  ),
);

const kButtonMinSize = Size(100, 55);
