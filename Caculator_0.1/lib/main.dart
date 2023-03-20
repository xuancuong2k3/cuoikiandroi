// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  State<MyHomePage> createState() => _MyHomePageState();
  const MyHomePage({super.key});
}

class _MyHomePageState extends State<MyHomePage> {
  String show2 = "0";
  String show1 = "";
  String dau = "";
  String dautruoc = "";
  bool nhapmoi = true;
  double str = 0;

  String toChuoi(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  @override
  Widget build(BuildContext context) {
    var myButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      fixedSize: Size(90, 90),
    );
    var mButtonStyle = ElevatedButton.styleFrom(
      backgroundColor: Color.fromARGB(255, 255, 89, 0),
      fixedSize: Size(90, 90),
    );
    var textStytes = TextStyle(
      color: Color.fromARGB(255, 0, 0, 0),
      fontSize: 35,
    );
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 40, 40, 40),
      appBar: AppBar(
        title: Text('Demo calculator'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Container(
              width: 360,
              height: 20,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              child: Text(
                show1,
                style: TextStyle(
                    fontSize: 18, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            Container(
              width: 360,
              height: 60,
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 0, 0, 0),
              ),
              child: Text(
                show2,
                style: TextStyle(
                    fontSize: 58, color: Color.fromARGB(255, 255, 255, 255)),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      show2 = "";
                      show1 = "";
                      dau = "";
                      dautruoc = "";
                      nhapmoi = true;
                      str = 0;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    fixedSize: Size(90, 90),
                  ),
                  child: Text('AC',style: textStytes,),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      show2 = "0";
                    });
                  },
                  style: mButtonStyle,
                  child: Text('C',style: textStytes,),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (show2.isNotEmpty) {
                      setState(() {
                        show2 = show2.substring(0, show2.length - 1);
                      });
                    }
                  },
                  style: mButtonStyle,
                  child: Text('<',style: textStytes,),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dau == '+' || dau == '-' || dau == '*') {
                      setState(() {
                        show1 = show2 + '/';
                      });
                      nhapmoi = true;
                    } else if (dautruoc == "+") {
                      setState(() {
                        show2 = toChuoi(str + double.parse(show2));
                        show1 = show2 + '/';
                      });
                      str = double.parse(show2);
                      dau = "/";
                      nhapmoi = true;
                    } else if (dautruoc == "-") {
                      setState(() {
                        show2 = toChuoi(str - double.parse(show2));
                        show1 = show2 + '/';
                      });
                      str = double.parse(show2);
                      dau = "/";
                      nhapmoi = true;
                    } else if (dautruoc == "*") {
                      setState(() {
                        show2 = toChuoi(str * double.parse(show2));
                        show1 = show2 + '/';
                      });
                      str = double.parse(show2);
                      dau = "/";
                      nhapmoi = true;
                    } else if (dautruoc == "/") {
                      setState(() {
                        show2 = toChuoi(str / double.parse(show2));
                        show1 = show2 + '/';
                      });
                      str = double.parse(show2);
                      dau = "/";
                      nhapmoi = true;
                    } else if (dau == "") {
                      str = double.parse(show2);
                      setState(() {
                        dau = '/';
                        show1 = toChuoi(str) + dau;
                      });
                      nhapmoi = true;
                    }
                  },
                  style: mButtonStyle,
                  child: Text('/',style: textStytes,),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '9';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '9';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '9',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '8';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '8';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '8',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '7';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '7';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '7',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dau == '+' || dau == '-' || dau == '/') {
                      setState(() {
                        show1 = show2 + '*';
                      });
                      nhapmoi = true;
                    } else if (dautruoc == "+") {
                      setState(() {
                        show2 = toChuoi(str + double.parse(show2));
                        show1 = show2 + '*';
                      });
                      str = double.parse(show2);
                      dau = "*";
                      nhapmoi = true;
                    } else if (dautruoc == "-") {
                      setState(() {
                        show2 = toChuoi(str - double.parse(show2));
                        show1 = show2 + '*';
                      });
                      str = double.parse(show2);
                      dau = "*";
                      nhapmoi = true;
                    } else if (dautruoc == "*") {
                      setState(() {
                        show2 = toChuoi(str * double.parse(show2));
                        show1 = show2 + '*';
                      });
                      str = double.parse(show2);
                      dau = "*";
                      nhapmoi = true;
                    } else if (dautruoc == "/") {
                      setState(() {
                        show2 = toChuoi(str / double.parse(show2));
                        show1 = show2 + '*';
                      });
                      str = double.parse(show2);
                      dau = "*";
                      nhapmoi = true;
                    } else if (dau == "") {
                      str = double.parse(show2);
                      setState(() {
                        dau = '*';
                        show1 = toChuoi(str) + dau;
                      });
                      nhapmoi = true;
                    }
                  },
                  style: mButtonStyle,
                  child: Text(
                    'x',
                    style: textStytes,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '6';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '6';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '6',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '5';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '5';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '5',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '4';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '4';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '4',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dau == '+' || dau == '*' || dau == '/') {
                      setState(() {
                        show1 = show2 + '-';
                      });
                      nhapmoi = true;
                    } else if (dautruoc == "+") {
                      setState(() {
                        show2 = toChuoi(str + double.parse(show2));
                        show1 = show2 + '-';
                      });
                      str = double.parse(show2);
                      dau = "-";
                      nhapmoi = true;
                    } else if (dautruoc == "-") {
                      setState(() {
                        show2 = toChuoi(str - double.parse(show2));
                        show1 = show2 + '-';
                      });
                      str = double.parse(show2);
                      dau = "-";
                      nhapmoi = true;
                    } else if (dautruoc == "*") {
                      setState(() {
                        show2 = toChuoi(str * double.parse(show2));
                        show1 = show2 + '-';
                      });
                      str = double.parse(show2);
                      dau = "-";
                      nhapmoi = true;
                    } else if (dautruoc == "/") {
                      setState(() {
                        show2 = toChuoi(str / double.parse(show2));
                        show1 = show2 + '-';
                      });
                      str = double.parse(show2);
                      dau = "-";
                      nhapmoi = true;
                    } else if (dau == "") {
                      str = double.parse(show2);
                      setState(() {
                        dau = '-';
                        show1 = toChuoi(str) + dau;
                      });
                      nhapmoi = true;
                    }
                  },
                  style: mButtonStyle,
                  child: Text(
                    '-',
                    style: textStytes,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '3';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '3';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '3',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '2';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '2';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '2',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '1';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '1';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '1',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dau == '-' || dau == '*' || dau == '/') {
                      setState(() {
                        show1 = show2 + '+';
                      });
                      nhapmoi = true;
                    } else if (dautruoc == "+") {
                      setState(() {
                        show2 = toChuoi(str + double.parse(show2));
                        show1 = show2 + '+';
                      });
                      str = double.parse(show2);
                      dau = "+";
                      nhapmoi = true;
                    } else if (dautruoc == "-") {
                      setState(() {
                        show2 = toChuoi(str - double.parse(show2));
                        show1 = show2 + '+';
                      });
                      str = double.parse(show2);
                      dau = "+";
                      nhapmoi = true;
                    } else if (dautruoc == "*") {
                      setState(() {
                        show2 = toChuoi(str * double.parse(show2));
                        show1 = show2 + '+';
                      });
                      str = double.parse(show2);
                      dau = "+";
                      nhapmoi = true;
                    } else if (dautruoc == "/") {
                      setState(() {
                        show2 = toChuoi(str / double.parse(show2));
                        show1 = show2 + '+';
                      });
                      str = double.parse(show2);
                      dau = "+";
                      nhapmoi = true;
                    } else if (dau == "") {
                      str = double.parse(show2);
                      setState(() {
                        dau = "+";
                        show1 = toChuoi(str) + dau;
                      });
                      nhapmoi = true;
                    }
                  },
                  style: mButtonStyle,
                  child: Text(
                    '+',
                    style: textStytes,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '0';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '0';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '0',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (show2 != "") {
                      setState(() {
                        show2 += ".";
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '.',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (nhapmoi == true) {
                      dautruoc = dau;
                      setState(() {
                        show2 = '00';
                        dau = "";
                      });
                      nhapmoi = false;
                    } else {
                      setState(() {
                        show2 += '00';
                      });
                    }
                  },
                  style: myButtonStyle,
                  child: Text(
                    '00',
                    style: textStytes,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (dautruoc == "+") {
                      setState(() {
                        show1 = "${toChuoi(str)} + $show2=";
                        show2 = toChuoi(str + double.parse(show2));
                      });
                      str = double.parse(show2);
                      dau = "";
                      dautruoc = "";
                      nhapmoi = true;
                    } else if (dautruoc == "-") {
                      setState(() {
                        show1 = "${toChuoi(str)} - $show2=";
                        show2 = toChuoi(str - double.parse(show2));
                      });
                      str = double.parse(show2);
                      dau = "";
                      dautruoc = "";
                      nhapmoi = true;
                    } else if (dautruoc == "*") {
                      setState(() {
                        show1 = toChuoi(str) + "*" + show2 + "=";
                        show2 = toChuoi(str * double.parse(show2));
                      });
                      str = double.parse(show2);
                      dau = "";
                      dautruoc = "";
                      nhapmoi = true;
                    } else if (dautruoc == "/") {
                      setState(() {
                        show1 = toChuoi(str) + "/" + show2 + "=";
                        show2 = toChuoi(str / double.parse(show2));
                      });
                      str = double.parse(show2);
                      dau = "";
                      dautruoc = "";
                      nhapmoi = true;
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 111, 0),
                    fixedSize: Size(90, 90),
                  ),
                  child: Text(
                    '=',
                    style: textStytes,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
