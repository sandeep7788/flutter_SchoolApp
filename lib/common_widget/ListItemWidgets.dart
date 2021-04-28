
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

get borderRadius => BorderRadius.circular(4.0);

Widget ListButton(int type, IconData my_icon, String str_title,
    BuildContext _context) {
  return Expanded(
    child: Card(
      elevation: 4,
      shadowColor: Colors.blueAccent,
      child: Container(
        margin: EdgeInsets.only(left: 2, right: 2,top: 4),
        child: Material(
          shadowColor: Colors.white10,
          elevation: 10,
          borderRadius: borderRadius,
          child: Container(
            height: 50.0,
            decoration: BoxDecoration(
              borderRadius: borderRadius,
            ),
            child: Row(
              children: <Widget>[
                LayoutBuilder(builder: (context, constraints) {
                  print(constraints);
                  return Container(
                    height: constraints.maxHeight,
                    width: constraints.maxHeight,
                    decoration: BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: borderRadius,
                    ),
                    child: Icon(
                      my_icon,
                      color: Colors.white,
                    ),
                  );
                }),
                Expanded(
                  child: Text(
                    str_title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 21,
                      fontFamily: 'intel'
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );
}
