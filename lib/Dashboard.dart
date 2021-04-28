import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/list_item_widget/MainMenuCard.dart';
import 'package:flutter_applicationdemo08/screens/HomeworkListScreeen.dart';
import 'model/Choice.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";

class Dashboard extends StatefulWidget {
  _Dashboard createState() => _Dashboard();
}

Widget _mainAppBar(BuildContext context,String str_teachername) {

  return Container(
    height: 250.0,
    color: Colors.blue,
    child: Container(
      margin: EdgeInsets.only(left: 25),
      child: Center(
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: CircleAvatar(
                backgroundImage: NetworkImage(url),
                radius: 50,
              ),
            ),
            new Center(
              child: Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(left: 25),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          str_teachername,
                          style: TextStyle(
                              fontSize: 26,
                              color: Colors.white70,
                              fontFamily: 'intel',
                              decoration: TextDecoration.none),
                        ),
                        Text(
                          "Other Teacher Details",
                          style: TextStyle(
                              fontSize: 16,
                              color: Colors.white60,
                              fontFamily: 'intel',
                              decoration: TextDecoration.none),
                        ),
                      ],
                    ),
                  )),
            )
          ],
        ),
      ),
    ),
  );
}

Widget _menuList(BuildContext context) {
  return Container(
      color: Colors.white,
      child: GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 2.0,
        mainAxisSpacing: 2.0,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: NeverScrollableScrollPhysics(),
        children: List.generate(choices.length, (index) {
          return Center(
            child: new Column(
              children: [
                new Expanded(
                  child: MainMenuCard(choice: choices[index]),
                ),
              ],
            ),
          );
        }),
      ));
}

class _Dashboard extends State<Dashboard> {
  String get str_teachername => "Teacher name";

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return ListView(
        children: <Widget>[_mainAppBar(context,str_teachername),
          _menuList(context)],
      );
    });
  }
}



const List<Choice> choices = const <Choice>[
  const Choice(title: 'Home', icon: Icons.home),
  const Choice(title: 'Holiday', icon: Icons.weekend_sharp),
  const Choice(title: 'Moment', icon: Icons.collections),
  const Choice(title: 'Leave Request', icon: Icons.request_page),
  const Choice(title: 'Answer Sheet', icon: Icons.question_answer_outlined),
  const Choice(title: 'Help', icon: Icons.mobile_friendly),
  const Choice(title: 'Attendances', icon: Icons.people_alt_outlined),
  const Choice(
      title: 'Notification', icon: Icons.notifications_active_outlined),
  const Choice(title: 'WiFi', icon: Icons.wifi),
];

