import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

CustomDialog(String msg,String des) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10.0),
      ),
    ),
    content: Container(
      width: 250.0,
      height: 100.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            msg,
            style: new TextStyle(
                color: Colors.blueAccent,
                fontSize: 16,
                fontFamily: "intel",
                fontWeight: FontWeight.bold),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Text(
              des,
              style: TextStyle(
                fontFamily: "intel",
                color: Color(0xFF5B6978),
              ),
            ),
          )
        ],

      ),
    ),
  );
}

/*    showDialog(
                barrierDismissible: false,
                context: context,
                child: new CupertinoAlertDialog(
                  title: new Column(
                    children: <Widget>[
                      new Text("GridView"),
                      new Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ],
                  ),
                  content: new Text( spacecrafts[index]),
                  actions: <Widget>[
                    new FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: new Text("OK"))
                  ],
                ));*/
