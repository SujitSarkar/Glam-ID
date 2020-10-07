import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


fadingCircle(){
  return Container(
    alignment: Alignment.center,
    child: SpinKitFadingCircle(
      color: Colors.deepPurple,
      size: 50.0,
    ),
  );
}

doubleBounce(){
  return Container(
    alignment: Alignment.center,
    child: SpinKitDoubleBounce(
      color: Colors.deepPurple,
      size: 60.0,
    ),
  );
}

cubeGrid(){
  return Container(
    alignment: Alignment.center,
    child: SpinKitCubeGrid(
      color: Colors.deepPurple,
      size: 300.0,
    ),
  );
}

