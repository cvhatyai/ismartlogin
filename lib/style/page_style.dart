import 'package:flutter/material.dart';

class StylePage {
  BoxDecoration boxWhite = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(15.0),
      topRight: Radius.circular(15.0),
      bottomLeft: Radius.circular(15.0),
      bottomRight: Radius.circular(15.0),
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        spreadRadius: 5,
        blurRadius: 7,
        offset: Offset(3, 0), // changes position of shadow
      ),
    ],
  );

  //---------

  BoxDecoration background = BoxDecoration(
    gradient: LinearGradient(
        colors: [
          Color(0xFF00B1FF),
          Color(0xFF79CFAC),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        stops: [0.0, 1.0],
        tileMode: TileMode.clamp),
  );
}
