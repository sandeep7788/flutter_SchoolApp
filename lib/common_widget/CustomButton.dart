import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

get borderRadius => BorderRadius.circular(8.0);

Widget CustomButton(
    int type, IconData my_icon, String str_title, BuildContext _context) {
  return Container(
    margin: EdgeInsets.only(left: 2, right: 2),
    child: Material(
      shadowColor: Colors.blueAccent,
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
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
