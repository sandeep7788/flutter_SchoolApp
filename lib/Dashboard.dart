import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/list_item_widget/MainMenuCard.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'APIContent.dart';
import 'model/Choice.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";
String str_teachername = "Teacher name";
String str_teacherDes = "d";

class Dashboard extends StatefulWidget {
  _Dashboard createState() => _Dashboard();
}

Widget _mainAppBar(BuildContext context, String str_teachername) {
  return Container(
    height: 250.0,
    color: Colors.blue,
    child: Container(
      margin: EdgeInsets.only(left: 25),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              radius: 60,
              child: CircleAvatar(
                backgroundImage: NetworkImage(url),
                radius: 50,
              ),
            ),
            Expanded(
                child: Container(
                  margin: EdgeInsets.only(left: 8,right: 8),
                    child: Center(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Text(
                        str_teachername,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 21,
                            color: Colors.white70,
                            fontFamily: 'intel',
                            decoration: TextDecoration.none),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 8,right: 8,top: 4),
                      child: Text(
                        str_teacherDes,
                        maxLines: 2,
                        style: TextStyle(
                            fontSize: 16,
                            color: Colors.white60,
                            fontFamily: 'intel',
                            decoration: TextDecoration.none),
                      ),
                    ),
                  ]),
            )))
          ],
        ),
      ),
    ),
  );
}



class _Dashboard extends State<Dashboard> {
  Future<void> setDetails() async {
    str_teachername = await SharedPreferencesClass.get(ApiContent.PREF_name);
    str_teacherDes =
        await SharedPreferencesClass.get(ApiContent.PREF_school_name);
    log.fine(str_teachername + " _ " + str_teacherDes);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Container(
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            _mainAppBar(context, str_teachername),
            sliverGridWidget(context)
          ],
        ),
      );
    });
  }

  @override
  Future<void> initState() {
    super.initState();
    setDetails();
  }
  Widget sliverGridWidget(BuildContext context){
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: choices.length,
      itemBuilder: (context, index){
        return Card(
          elevation: 4,
          margin: EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          shadowColor: Colors.blueAccent,
          color: Colors.white70,
          child: Container(
              color: Colors.white,
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Expanded(
                      child: new Container(

                        child: new Icon(
                          choices[index].icon,
                          color: Colors.blueAccent,
                          size: 50.0,
                        ),
                      ),
                      flex: 2,
                    ),
                    new Expanded(
                      child: new Container(
                          margin: EdgeInsets.only(top: 12),
                          child: new Text(
                            choices[index].title,
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          )),
                      flex: 1,
                    ),
                  ])
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.count(2,2.5), //Make size as you want.
      mainAxisSpacing: 1.0,
      crossAxisSpacing:1.0,
    );
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

