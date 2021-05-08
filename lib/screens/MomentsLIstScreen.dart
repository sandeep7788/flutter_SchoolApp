import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/common_widget/CustomDialog.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/list_item_widget/MainMenuCard.dart';
import 'package:flutter_applicationdemo08/models/MomentListModel.dart';
import 'package:flutter_applicationdemo08/screens/AttandenceScreen.dart';
import 'package:flutter_applicationdemo08/screens/HolidayScreen.dart';
import 'package:flutter_applicationdemo08/screens/HomeworkListScreeen.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import '../APIContent.dart';
import 'package:http/http.dart' as http;

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";
String str_teachername = "Teacher name";
String str_teacherDes = "d";
List<MomentListModel> _listMomentListModel = List();

class MomentsListScreen extends StatefulWidget {
  _MomentsListScreen createState() => _MomentsListScreen();
}
class _MomentsListScreen extends State<MomentsListScreen> {

  Future getMomentsList(BuildContext context) async {

    ProcessDialog().showProgressDialog(context, "Please wait ...");


    var school_id=await SharedPreferencesClass.get(ApiContent.PREF_school_id);
    var facultyid=await SharedPreferencesClass.get(ApiContent.PREF_facultyid);

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    var uri = Uri.parse(ApiContent.PREF_GET_MOMENTS+"?school_id=$school_id"+"&facultyid=$facultyid");
    var response = await http.get(uri, headers: headers);

    log.fine("message "+response.body);
    // Navigator.pop(context);
    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);

      listClasses.clear();
      for (var i = 0; i < list.length; i++) {
        MomentListModel fact = MomentListModel.fromJson(list[i]);
        _listMomentListModel.add(fact);
      }

      if (_listMomentListModel.length > 0) {
        setState(() {

        });
      }
    } else {
      CustomDialog("Somethong wrong", "Somethong wrong Somethong wrong");
    }
  }


  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Moments"),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
          ),
          body: Container(
            color: Colors.blue,
            child: ListView(
              children: <Widget>[
                sliverGridWidget(context)
              ],
            ),
          ));
    });
  }

  @override
  Future<void> initState() {
    super.initState();
    getMomentsList(context);
  }

  Widget sliverGridWidget(BuildContext context){
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _listMomentListModel.length,
      itemBuilder: (context, index){
        return Card(
          elevation: 4,
          margin: EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 4.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.0),
          ),
          shadowColor: Colors.blueAccent,
          color: Colors.white70,
          child: Image(
            image: NetworkImage(ApiContent.PREF_IMAGES_PATH+_listMomentListModel[index].filePath),
          ),
        );
      },
      staggeredTileBuilder: (index) => StaggeredTile.count(2,2.5), //Make size as you want.
      mainAxisSpacing: 1.0,
      crossAxisSpacing:1.0,
    );
  }

  navigateToNextScreen(BuildContext context, StatefulWidget homeworkListScreeen) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => homeworkListScreeen));
  }
}

