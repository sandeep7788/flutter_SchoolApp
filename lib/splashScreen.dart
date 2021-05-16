import 'dart:async';

import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/Dashboard.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/screens/AttandenceScreen.dart';
import 'package:flutter_applicationdemo08/screens/SignUp.dart';

import 'Affiche_grille.dart';

class Splash extends StatefulWidget {
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        brightness: Brightness.dark, // this makes status bar text color black
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.blueAccent,
      body: ConnectivityWidget(
        builder: (context, isOnline) => Center(
          child: Container(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/logo.png',
                    width: 200,
                  ),
                ),
                Container(
                    alignment: Alignment.center,
                    child: Text(
                      "School",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontFamily: "intel",
                          fontWeight: FontWeight.w700),
                    )),
              ],
            ),
            /*  */
          ),
        ),
      ),
    );
  }

  @override
  Future<void> initState() {
    super.initState();
    asyncMethod(context);
  }
}

asyncMethod(BuildContext context) async {
  if (await SharedPreferencesClass.isLogin() != null) {
    await dashboardScreen(context);
  } else {
    await signUpScreen(context);
  }
}

void dashboardScreen(BuildContext context) {
  Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Dashboard())));
}

void signUpScreen(BuildContext context) {
  Timer(
      Duration(seconds: 2),
      () => Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => SignUp())));
}
