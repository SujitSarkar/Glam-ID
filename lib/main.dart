import 'package:flutter/material.dart';
import 'package:telegramchatapp/pages/LoginPage.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Glam ID",
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        canvasColor: Colors.transparent,
        cursorColor: Colors.deepPurple,
        textTheme: TextTheme(
          headline1: TextStyle(fontFamily: "OpenSans-Regular"),
          headline2:TextStyle(fontFamily: "OpenSans-Regular"),
          headline3:TextStyle(fontFamily: "OpenSans-Regular"),
          headline4:TextStyle(fontFamily: "OpenSans-Regular"),
          headline5:TextStyle(fontFamily: "OpenSans-Regular"),
          headline6:TextStyle(fontFamily: "OpenSans-Regular"),
          subtitle1:TextStyle(fontFamily: "OpenSans-Regular"),
          subtitle2:TextStyle(fontFamily: "OpenSans-Regular"),
          bodyText1:TextStyle(fontFamily: "OpenSans-Regular"),
          bodyText2:TextStyle(fontFamily: "OpenSans-Regular"),
          caption:TextStyle(fontFamily: "OpenSans-Regular"),
          button:TextStyle(fontFamily: "OpenSans-Regular"),
          overline:TextStyle(fontFamily: "OpenSans-Regular"),
        ),
      ),
      home: LoginScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}





