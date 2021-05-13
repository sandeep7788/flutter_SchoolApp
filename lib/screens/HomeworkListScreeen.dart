import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/APIContent.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/list_item_widget/HomeWorkListCard.dart';
import 'package:flutter_applicationdemo08/models/HomeWorkListModel.dart';
import 'package:http/http.dart' as http;

import 'AddHomeworkScreen.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";
var TAG = "@@@@HOMEWORK";

class HomeworkListScreeen extends StatefulWidget {
  _AddHomeworkScreen createState() => _AddHomeworkScreen();
}

class _AddHomeworkScreen extends State<HomeworkListScreeen> {
  List<HomeWorkListModel> listHomeWork = List();

  @override
  void initState() {
    getHomeWorkList(context);
    super.initState();
  }

  Future getHomeWorkList(BuildContext context) async {
    ProcessDialog().showProgressDialog(context, "Please wait ...");

     final body = {
      ApiContent.PREF_KEY_SCHOOL_ID: (await SharedPreferencesClass.get(ApiContent.PREF_school_id)).toString(),
      ApiContent.PREF_KEY_FACULTY_ID: (await SharedPreferencesClass.get(ApiContent.PREF_facultyid)).toString(),
    };

  /*  final body = {
      ApiContent.PREF_KEY_SCHOOL_ID: '32',
      ApiContent.PREF_KEY_FACULTY_ID: '480',
    };*/

    log.error("message1 "+await SharedPreferencesClass.get(ApiContent.PREF_school_id));
    log.error("message2 "+await SharedPreferencesClass.get(ApiContent.PREF_facultyid));
    log.error("message3 " + ApiContent.PREF_BASE_URL + ApiContent.PREF_GET_HOMEWORK_LIST);

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var uri = Uri.https(ApiContent.PREF_BASE_URL,
        ApiContent.PREF_GET_HOMEWORK_LIST, body);

    var response = await http.get(uri, headers: headers);


    log.error(TAG + response.body);
    log.error(TAG + response.statusCode.toString());

    if (response.statusCode == 200 && response.body.length > 0) {
      List<dynamic> list = json.decode(response.body);

      listHomeWork.clear();
      for (var i = 0; i < 10; i++) {
        HomeWorkListModel fact = HomeWorkListModel.fromJson(list[i]);
        print(TAG + fact.title);
        listHomeWork.add(fact);
      }
      setState(() {

      });
    } else {
      Util().showMessageDialog(
          context, ApiContent.something_wrong, ApiContent.try_later,false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return _menuList(context);
    });
  }

  Widget _menuList(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Work"),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
      ),
      body: _homeWorkLisWidget(context),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add_to_photos, color: Colors.white),
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => AddHomeworkScreen()));
          }),
    );
  }

  _homeWorkLisWidget(BuildContext context) {
    return Container(
        color: Colors.white,
        child: GridView.count(
          crossAxisCount: 1,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          children: List.generate(listHomeWork.length, (index) {
            return HomeWorkListCard(mHomework_model: listHomeWork[index]);
          }),
        ));
  }
}
