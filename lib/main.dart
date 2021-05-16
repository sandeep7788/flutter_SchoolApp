import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/Dashboard.dart';
import 'package:flutter_applicationdemo08/splashScreen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:connectivity_widget/connectivity_widget.dart';

import 'helper/ConnectionStatusSingleton.dart';

void main() {
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();


  runApp(MyApp());

  //connectionStatus.dispose();
}

// void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ConnectivityWidget(
        builder: (context, isOnline) => Center(
          child: Splash(),
        ),
      ),
    );
  }
}