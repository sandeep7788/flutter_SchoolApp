import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/list_item_widget/MainMenuCard.dart';
import 'package:flutter_applicationdemo08/screens/AccountSetting.dart';
import 'package:flutter_applicationdemo08/screens/AttandenceScreen.dart';
import 'package:flutter_applicationdemo08/screens/HolidayScreen.dart';
import 'package:flutter_applicationdemo08/screens/HomeworkListScreeen.dart';
import 'package:flutter_applicationdemo08/screens/LeaveRequest.dart';
import 'package:flutter_applicationdemo08/screens/MomentsLIstScreen.dart';
import 'package:flutter_applicationdemo08/screens/NotificationListScreen.dart';
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
    height: 220.0,
    color: Colors.blue,
    child: Container(
      margin: EdgeInsets.only(left: 32, bottom: 16,top: 16),
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
                    margin: EdgeInsets.only(left: 8, right: 8),
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
                                    fontSize: 26,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'intel',
                                    decoration: TextDecoration.none),
                              ),
                            ),
                            Container(
                              margin:
                                  EdgeInsets.only(left: 8, right: 8, top: 4),
                              child: Text(
                                str_teacherDes,
                                maxLines: 2,
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
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
    return Scaffold(
      body: Container(
        color: Colors.blue,
        child: ListView(
          children: <Widget>[
            _mainAppBar(context, str_teachername),
            sliverGridWidget(context)
          ],
        ),
      ),
    );
  }

  @override
  Future<void> initState() {
    super.initState();
    setDetails();
  }

  Widget sliverGridWidget(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: choices.length,
      itemBuilder: (context, index) {
        return Card(
          elevation: 4,
          margin: EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 8.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
          ),
          shadowColor: Colors.blueAccent,
          color: Colors.white70,
          child: GestureDetector(
              onTap: () => {
                    if (index == 0)
                      {
                        Util().navigateToNextScreen(context, HomeworkListScreeen())
                      }
                    else if (index == 1)
                      {Util().navigateToNextScreen(context, HolidayScreem())}
                    else if (index == 2)
                      {
                        Util().navigateToNextScreen(context, MomentsListScreen())
                      }
                    else if (index == 6)
                      {Util().navigateToNextScreen(context, AttandenceScreen())}
                    else if (index == 3)
                      {Util().navigateToNextScreen(context, LeaveRequest())}
                    else if (index == 7)
                      {Util().navigateToNextScreen(context, NotificationListScreen())}
                    else if (index == 8)
                      {Util().navigateToNextScreen(context, AccountSetting())}
                  },
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    new Expanded(
                      child: new Container(
                        child: new Icon(
                          choices[index].icon,
                          color: Colors.blueAccent,
                          size: 80.0,
                        ),
                      ),
                      flex: 2,
                    ),
                    new Expanded(
                      child: new Container(
                          margin: EdgeInsets.only(top: 12),
                          child: new Text(
                            choices[index].title,
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'intel'),
                          )),
                      flex: 1,
                    ),
                  ])),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.count(2, 2.5),
      //Make size as you want.
      mainAxisSpacing: 1.0,
      crossAxisSpacing: 1.0,
    );
  }

  navigateToNextScreen(
      BuildContext context, StatefulWidget homeworkListScreeen) {
    Navigator.of(context)
        .push(MaterialPageRoute(builder: (context) => homeworkListScreeen));
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
  const Choice(title: 'Profile', icon: Icons.account_circle),
];
