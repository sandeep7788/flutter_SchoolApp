import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter_applicationdemo08/screens/AddHomeworkScreen.dart';

Future<Widget> ConectivityMsgSnackBar(BuildContext context) async {

  var message="Please check internet connection";
  /*Flushbar(
    flushbarPosition: FlushbarPosition.BOTTOM,
    message: "please check connection",
    icon: Icon(
      Icons.info_outline,
      size: 28.0,
      color: Colors.red,
    ),
    backgroundColor: Colors.red,
    duration: Duration(seconds: 5),
    leftBarIndicatorColor: Colors.red,

  )..show(context).then((r)=> Navigator.push(
      context, MaterialPageRoute(builder: (context) => AddHomeworkScreen())));*/

  Flushbar(
    duration: Duration(seconds: 3),
    icon: Container(
      margin: const EdgeInsets.only(bottom: 50),
      child: Icon(Icons.signal_cellular_connected_no_internet_4_bar_sharp, color: Colors.red),
    ),
    messageText: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('ERREUR',
            style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        Text(
          '$message',
          style: TextStyle(color: Colors.lightBlue[50]),
          softWrap: true,
        ),
      ],
    ),
    isDismissible: true,
    dismissDirection: FlushbarDismissDirection.HORIZONTAL,
    backgroundColor: Colors.blueGrey[700],
    leftBarIndicatorColor: Colors.red,
  ).show(context);

}

/*  Container(
    child: Center(
      child: MaterialButton(
        onPressed: () {
          flush = Flushbar<bool>(
            title: "Hey Ninja",
            message:
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry",
            icon: Icon(
              Icons.info_outline,
              color: Colors.blue,
            ),
            mainButton: FlatButton(
              onPressed: () {
                flush.dismiss(true); // result = true
              },
              child: Text(
                "hide",
                style: TextStyle(color: Colors.amber),
              ),
            ),
          ) // <bool> is the type of the result passed to dismiss() and collected by show().then((result){})
            ..show(context).then((result) {});
        },
      ),
    ),
  );*/