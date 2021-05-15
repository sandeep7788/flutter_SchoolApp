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

import 'AddMomentsScreen.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";
String str_teachername = "Teacher name";
String str_teacherDes = "d";
List<MomentListModel> _listMomentListModel = List();

class MomentsListScreen extends StatefulWidget {
  _MomentsListScreen createState() => _MomentsListScreen();
}

class _MomentsListScreen extends State<MomentsListScreen> {
  Future getMomentsList(BuildContext context, bool showDialog) async {
    // ProcessDialog().showProgressDialog(context, "Please wait ...");

    var school_id = await SharedPreferencesClass.get(ApiContent.PREF_school_id);
    var facultyid = await SharedPreferencesClass.get(ApiContent.PREF_facultyid);

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};

    var uri = Uri.parse(ApiContent.PREF_GET_MOMENTS +
        "?school_id=$school_id" +
        "&facultyid=$facultyid");
    var response = await http.get(uri, headers: headers);

    log.fine("message " + response.body);

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);

      _listMomentListModel.clear();
      for (var i = 0; i < list.length; i++) {
        MomentListModel fact = MomentListModel.fromJson(list[i]);
        _listMomentListModel.add(fact);
      }

      if (_listMomentListModel.length > 0) {
        setState(() {});
      }
    } else {
      CustomDialog("Somethong wrong", "Somethong wrong Somethong wrong");
    }
    // Navigator.pop(context);
  }

  void openDialogImageDetails(
      String image_url, String image_title, String image_description) {
    Navigator.of(context).push(new MaterialPageRoute<Null>(
        builder: (BuildContext context) {
          return Container(
            color: Colors.white,
            child: Stack(children: <Widget>[
              Center(
                child: InteractiveViewer(
                  panEnabled: false,
                  // Set it to false
                  boundaryMargin: EdgeInsets.all(100),
                  minScale: 0.5,
                  maxScale: 2,
                  child: Image(
                    image: NetworkImage(image_url),
                  ),
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                  height: 6,
                  color: Colors.blue,
                  width: double.infinity,
                ),
                Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    child: Text(
                      image_title,
                      maxLines: 5,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.none,
                          fontSize: 16,
                          fontFamily: "intel",
                          fontWeight: FontWeight.bold),
                    )),
                Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 12.0),
                    child: Text(
                      image_description+"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 12,
                        fontFamily: "intel",
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                      ),
                    )),
              ]),
            ]),
          );
        },
        fullscreenDialog: true));
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
        body: RefreshIndicator(
          onRefresh: () => getMomentsList(context, true),
          child: Container(
            color: Colors.blue,
            child: ListView(
              children: <Widget>[_imagesGridWidget(context)],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Util().navigateToNextScreen(context, AddMomentsScreen());
          },
          child: Icon(
            Icons.camera,
            color: Colors.white,
            size: 29,
          ),
          backgroundColor: Colors.blueAccent,
          tooltip: 'Capture Picture',
          elevation: 4,
          splashColor: Colors.grey,
        ),
      );
    });
  }

  @override
  Future<void> initState() {
    super.initState();
    getMomentsList(context, true);
  }

  Widget _imagesGridWidget(BuildContext context) {
    return StaggeredGridView.countBuilder(
      padding: const EdgeInsets.all(8.0),
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _listMomentListModel.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => {
            openDialogImageDetails(
                ApiContent.PREF_IMAGES_PATH +
                    _listMomentListModel[index].filePath,
                _listMomentListModel[index].title,
                _listMomentListModel[index].description)
          },
          child: Card(
            elevation: 4,
            margin: EdgeInsets.fromLTRB(0.0, 4.0, 4.0, 4.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            shadowColor: Colors.white,
            color: Colors.white70,
            child: Stack(children: <Widget>[
              Center(
                child: Image(
                  image: NetworkImage(ApiContent.PREF_IMAGES_PATH +
                      _listMomentListModel[index].filePath),
                ),
              ),
              Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                Container(
                    width: double.infinity,
                    color: Colors.white,
                    padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
                    child: Text(
                      _listMomentListModel[index].title,
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
