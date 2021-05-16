import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/common_widget/CustomDialog.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/list_item_widget/MainMenuCard.dart';
import 'package:flutter_applicationdemo08/models/MomentListModel.dart';
import 'package:flutter_applicationdemo08/models/NotifactionListModel.dart';
import 'package:flutter_applicationdemo08/screens/AttandenceScreen.dart';
import 'package:flutter_applicationdemo08/screens/HolidayScreen.dart';
import 'package:flutter_applicationdemo08/screens/HomeworkListScreeen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../APIContent.dart';
import 'package:http/http.dart' as http;

import 'AddMomentsScreen.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";
String str_teachername = "Teacher name";
String str_teacherDes = "d";
List<NotifactionListModel> _listNotifactionListModel = List();

class NotificationListScreen extends StatefulWidget {
  _NotificationListScreen createState() => _NotificationListScreen();
}

class _NotificationListScreen extends State<NotificationListScreen> {
  Future getNotification(BuildContext context) async {
    // ProcessDialog().showProgressDialog(context, "Please wait ...");

    var school_id = await SharedPreferencesClass.get(ApiContent.PREF_school_id);
    var facultyid = await SharedPreferencesClass.get(ApiContent.PREF_facultyid);

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    var uri = Uri.parse(ApiContent.PREF_POST_GET_NOTIFICATION +
        "?school_id=$school_id" +
        "&facultyid=$facultyid");
    var response = await http.get(uri, headers: headers);

    log.fine("message " + response.body);

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);

      _listNotifactionListModel.clear();
      for (var i = 0; i < list.length; i++) {
        NotifactionListModel fact = NotifactionListModel.fromJson(list[i]);
        _listNotifactionListModel.add(fact);
      }

      if (_listNotifactionListModel.length > 0) {
        setState(() {});
      }
    } else {
      CustomDialog(ApiContent.something_wrong, ApiContent.error_des);
    }
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Notifications"),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
          ),
          body: ConnectivityWidget(
            builder: (context, isOnline) => Center(
              child: RefreshIndicator(
                onRefresh: () => getNotification(context),
                child: Container(
                  color: Colors.blue,
                  child: ListView(
                    children: <Widget>[_imagesGridWidget(context)],
                  ),
                ),
              ),
            ),
          ));
    });
  }

  @override
  Future<void> initState() {
    super.initState();
    getNotification(context);
  }

  Widget _imagesGridWidget(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _listNotifactionListModel.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Card(
            elevation: 4,
            margin: EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 4.0),
            color: Colors.white70,
            child: Stack(children: <Widget>[
              Center(
                child: index < 5
                    ? Icon(Icons.notifications_active_rounded,
                        color: Colors.blue)
                    : Icon(Icons.notifications_sharp, color: Colors.blueGrey),
              ),
              Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    child: Text(
                  _listNotifactionListModel[index].title,
                  maxLines: 5,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 16,
                      fontFamily: "intel",
                      fontWeight: FontWeight.bold),
                )),
              ]),
            ]),
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.count(2, 1),
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
