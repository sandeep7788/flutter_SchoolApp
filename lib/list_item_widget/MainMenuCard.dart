import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/model/Choice.dart';
import 'package:flutter_applicationdemo08/screens/HomeworkListScreeen.dart';

class MainMenuCard extends StatelessWidget {
 /* const MainMenuCard(Choice  choice, Type int, {Key key, this.choice,this.index}) : super(key: key);
  */

  // MainMenuCard(this.choice,this.index);

  final Choice choice;
  final int index;

  const MainMenuCard({
    Key key,
    this.choice,
    this.index, int int, Choice Choice,
  }) : super(key: key);

  void _navigateToNextScreen(BuildContext context) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => HomeworkListScreeen()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1,
            mainAxisSpacing: 2

        ),
        itemBuilder: (contxt, indx) {
          return GestureDetector(
            onTap: (){
              print("@@@@@@@"+indx.toString());

              _navigateToNextScreen(contxt);
            },
            child: Card(

              elevation: 4,
              margin: EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              shadowColor: Colors.blueAccent,
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Container(

                  width: 4,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Expanded(
                          child: new Container(
                            child: new Icon(
                              choice.icon,
                              color: Colors.black,
                              size: 50.0,
                            ),
                          ),
                          flex: 2,
                        ),
                        new Expanded(
                          child: new Container(
                              margin: EdgeInsets.only(top: 12),
                              child: new Text(
                                choice.title,
                                style:
                                TextStyle(fontSize: 16, color: Colors.black),
                              )),
                          flex: 1,
                        ),
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}