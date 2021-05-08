import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget widgetCustomButton(String strTitle,
    BuildContext _context) {
  return Container(
    height: 50,
    margin: EdgeInsets.only(left: 8, right: 8,bottom: 4),
    width: MediaQuery.of(_context).size.width,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
      gradient: LinearGradient(

          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Colors.blue[900],
            Colors.blue[800],
            Colors.blue[700],
            Colors.blue[600],
            Colors.blue[500],
            Colors.blue[600],
            Colors.blue[700],
            Colors.blue[800],
            Colors.blue[900],
          ]),
    ),
    child: Center(
      child: Text(
        strTitle,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          color: Colors.white,
          fontFamily: 'intel'
        ),
      ),
    ),
  );
}