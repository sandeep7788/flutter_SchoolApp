import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/Dashboard.dart';

class Splash extends StatefulWidget {
  _Splash createState() => _Splash();
}

class _Splash extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(248, 98, 55, 1.0),
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/backgroundimg.png'),
            fit: BoxFit.cover,
          ),
        ),
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
                      fontFamily: "Mulish",
                      fontWeight: FontWeight.w700),
                )),
          ],
        ),
        /*  */
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    goto();
  }
}

extension HelpingMethod on _Splash {
  void goto() async {
    Timer(
        Duration(seconds: 2),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Dashboard())));
  }
}
