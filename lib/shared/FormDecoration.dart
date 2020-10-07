import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
    hintText: 'User Id',
    fillColor: Colors.white,
    filled: true,
    enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.deepPurple,
          width: 2.0,
        )),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.deepPurple,
        width: 2.0,
      ),
    ),
    errorBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: Colors.red,
          width: 2.0,
        )),
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.red,
        width: 2.0,
      ),
    ));

const modalDecoration = BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.only(
    topLeft: Radius.circular(300.0),
    // topRight: Radius.circular(300.0),
    // bottomLeft: Radius.circular(300.0),
    bottomRight: Radius.circular(300.0),
  ),
);