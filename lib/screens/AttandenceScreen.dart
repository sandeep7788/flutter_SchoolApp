import 'dart:convert';
import 'dart:io';

import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_applicationdemo08/APIContent.dart';
import 'package:flutter_applicationdemo08/common_widget/CustomDialog.dart';
import 'package:flutter_applicationdemo08/common_widget/ListItemWidgets.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/common_widget/widgetCustomButton.dart';
import 'package:flutter_applicationdemo08/helper/CustomToast.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/models/ClassModel.dart';
import 'package:flutter_applicationdemo08/models/SectionModel.dart';
import 'package:flutter_applicationdemo08/models/StudentAttandanceModel.dart';
import 'package:http/http.dart' as http;

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";
var TAG = "@@@@HOMEWORK";
File _image;
List<ClassModel> listClasses = List();
List<StudentAttandanceModel> listAttandance = List();
List<SectionModel> listSection = List();

List<String> listAbsentStudent = List();
List<String> listLeaveStudent = List();

List<int> groupValue = [];
List<List<int>> value = [];
var class_id = "";
var section_id = "";
var _classSelected = "Classes";
var _sectionSelected = "Section";

class AttandenceScreen extends StatefulWidget {
  _AddHomeworkScreen createState() => _AddHomeworkScreen();
}

class _AddHomeworkScreen extends State<AttandenceScreen> {

  Future StudentsAttendance(BuildContext context) async {
    ProcessDialog().showProgressDialog(context, "Please wait ...");

    final body = {
      "schoolid": await SharedPreferencesClass.get(ApiContent.PREF_school_id),
      "faculty": await SharedPreferencesClass.get(ApiContent.PREF_facultyid),
      "subdate": await SharedPreferencesClass.get(ApiContent.PREF_school_id),
      "classid": class_id,
      "sectionid": section_id,
      "stid": listAbsentStudent.toString(),
      "stid1": listLeaveStudent.toString(),
      "school_session":
          await SharedPreferencesClass.get(ApiContent.PREF_school_session)
    };
    log.fine("message "+json.encode(body));

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var uri = Uri.https(ApiContent.PREF_BASE_URL, ApiContent.PREF_GET_STUDENT_ATTENDANCE, body);

    var response = await http.post(uri, headers: headers);
    Navigator.pop(context);

    log.fine("message"+" "+response.body);

    if (response.statusCode == 200) {
      CustomDialog(
          "Submitted Sussfully", "Submitted Sussfully Submitted Sussfully");
    } else {
      CustomDialog("Somethong wrong", "Somethong wrong Somethong wrong");
    }
  }

  Future getClassList(BuildContext context) async {
    ProcessDialog().showProgressDialog(context, "Please wait ...");

    var uri = Uri.parse(ApiContent.PREF_GET_CLASSES +
        await SharedPreferencesClass.get(ApiContent.PREF_school_id));
    var response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200 && response.body.length > 0) {
      List<dynamic> list = json.decode(response.body);

      listClasses.clear();
      for (var i = 0; i < list.length; i++) {
        ClassModel fact = ClassModel.fromJson(list[i]);
        listClasses.add(fact);
      }
      Navigator.pop(context);
      if (list.length > 0) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Classes",
                  style: TextStyle(
                      fontSize: 24, color: Colors.black, fontFamily: 'intel'),
                ),
                content: _setupAlertDialoadClassList(
                    context, listClasses, Icons.class__outlined, 0),
              );
            });
      }
    } else {
      Navigator.pop(context);
    }
  }

  Future getstudents(BuildContext context) async {
    ProcessDialog().showProgressDialog(context, "Please wait ...");

    try {
      var uri = Uri.parse(ApiContent.PREF_GET_STUDENT +
          "school_id=" +
          await SharedPreferencesClass.get(ApiContent.PREF_school_id) +
          "&class_id=" +
          class_id.toString() +
          "&section_id=" +
          section_id.toString() +
          "&school_session=" +
          "2020-2021");

      log.fine(ApiContent.PREF_GET_STUDENT +
          "school_id=" +
          await SharedPreferencesClass.get(ApiContent.PREF_school_id) +
          "&class_id=" +
          class_id.toString() +
          "&section_id=" +
          section_id.toString() +
          "&school_session=" +
          "2020-2021");
      var response = await http.get(
        uri,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
      );
      log.fine(response.body.toString());

      if (response.statusCode == 200 && response.body.length > 0) {
        List<dynamic> list = json.decode(response.body);

        value.clear();
        listAttandance.clear();
        groupValue.clear();

        for (var i = 0; i < list.length; i++) {
          StudentAttandanceModel fact =
              StudentAttandanceModel.fromJson(list[i]);
          listAttandance.add(fact);
          // value.add([i, int.parse("99999199$i"), int.parse("99199999$i")]);
          value.add([0, 1, 2]);
          groupValue.add(i);
        }
        setState(() {});
        Navigator.pop(context);
      } else {
        Navigator.pop(context);
      }
    } catch (e) {
      log.error(e);
    }
  }

  Future getSectionList(BuildContext context) async {
    ProcessDialog().showProgressDialog(context, "Please wait ...");

    var uri = Uri.parse(ApiContent.PREF_GET_SECTION);
    var response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    print("@@@@" + response.body);
    Navigator.pop(context);
    listSection.clear();
    if (response.statusCode == 200 && response.body.length > 0) {
      List<dynamic> list = json.decode(response.body);

      for (var i = 0; i < list.length; i++) {
        SectionModel fact = SectionModel.fromJson(list[i]);
        listSection.add(fact);
      }

      if (list.length > 0) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Section",
                  style: TextStyle(
                      fontSize: 24, color: Colors.black, fontFamily: 'intel'),
                ),
                content: _setupAlertDialoadClassList(
                    context, listSection, Icons.people_outline_outlined, 1),
              );
            });
      }
    }
  }

  Widget _setupAlertDialoadClassList(
      BuildContext context, List<dynamic> mList, IconData mIconData, int type) {
    return Container(
      height: 500.0, // Change as per your requirement
      width: 300.0,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mList.length,
        itemBuilder: (BuildContext context, int index) {
          return Expanded(
              child: InkWell(
            onTap: () {
              setState(() async {
                if (type == 0) {
                  _classSelected = mList[index].classes;
                  class_id = mList[index].id;
                  await getstudents(context);
                } else if (type == 1) {
                  _sectionSelected = mList[index].section;
                  section_id = mList[index].id;
                  getstudents(context);
                } else {}
                Navigator.of(context, rootNavigator: true).pop();
              });
            },
            child: Builder(builder: (context) {
              return type == 0
                  ? ListButton(0, mIconData, mList[index].classes, context)
                  : type == 1
                      ? ListButton(0, mIconData, mList[index].section, context)
                      : ListButton(0, mIconData, mList[index].subject, context);
            }),
          ));
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
          bottomNavigationBar: BottomAppBar(
            color: Colors.transparent,
            child: GestureDetector(
              onTap: () {
                listAbsentStudent.clear();
                listLeaveStudent.clear();
                for (var i = 0; i < listAttandance.length; i++) {
                  if (groupValue[i] == 0) {
                    listAbsentStudent.add(listAttandance[i].id);
                  } else if (groupValue[i] == 1) {
                    listLeaveStudent.add(listAttandance[i].id);
                  }
                }
                log.fine(listAbsentStudent.toString());
                log.fine(listLeaveStudent.toString());
                StudentsAttendance(context);
              },
              child: widgetCustomButton("Submit Attendants", context),
            ),
            elevation: 0,
          ),
          appBar: AppBar(
            title: Text("Attendances"),
            iconTheme: IconThemeData(
              color: Colors.white, //change your color here
            ),
            centerTitle: true,
          ),
          body: ConnectivityWidget(
            builder: (context, isOnline) => Center(
              child: Container(
                color: Colors.white,
                margin: EdgeInsets.only(left: 8, right: 8, top: 16),
                child: Column(
                  children: [
                    widgetClassSectionButton(),
                    listAttandance.isNotEmpty
                        ? headLineContainer()
                        : msgNothingToShow(),
                    listAttandance.isNotEmpty
                        ? widgetStudentList()
                        : widgetMsgEmpty(),
                  ],
                ),
              ),
            ),
          )
        );
    });
  }

  widgetMsgEmpty() {
    return Center(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 8, right: 8, top: 64),
              child: new Icon(
                Icons.youtube_searched_for_sharp,
                color: Colors.blueAccent,
                size: 150,
              ),
            ),
            Center(
                child: Text(
              "Please Select Students",
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: Colors.blueAccent,
                  fontSize: 16,
                  fontFamily: "intel",
                  fontWeight: FontWeight.w100),
            )),
          ]),
    );
  }

  widgetClassSectionButton() {
    return Container(
        height: 52,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
                child: InkWell(
              onTap: () {
                section_id = "";
                _sectionSelected = "Section";
                getClassList(context);
              },
              child: customButton(0, Icons.class_, _classSelected, context),
            )),
            Expanded(
                child: InkWell(
              onTap: () {
                if (listClasses.length > 0) {
                  getSectionList(context);
                } else {
                  CustomToast.show("Please first select Class", context);
                }
              },
              child: customButton(
                  1, Icons.people_outline_outlined, _sectionSelected, context),
            )),
          ],
        ));
  }

  headLineContainer() {
    return Container(
      child: Card(
        margin: EdgeInsets.only(top: 16),
        elevation: 4,
        shadowColor: Colors.blueAccent,
        child: Container(
          margin: EdgeInsets.only(top: 4, bottom: 4),
          padding: EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 8.0),
          color: Colors.blueAccent,
          height: 50,
          child: new Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  width: 120,
                  child: Text(
                    "St name",
                    style: new TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontFamily: "intel",
                        fontWeight: FontWeight.w700),
                  ),
                ),
                Text(
                  "Absent",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "intel",
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "Leave",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "intel",
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  "Clear",
                  style: new TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontFamily: "intel",
                      fontWeight: FontWeight.w700),
                ),
              ]),
        ),
      ),
    );
  }

  msgNothingToShow() {
    return Container(
      margin: EdgeInsets.only(top: 41),
      child: Text(
        "Nothing to Show \n from this class or section",
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.blueAccent,
            fontSize: 16,
            fontFamily: "intel",
            fontWeight: FontWeight.w100),
      ),
    );
  }

  widgetStudentList() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 8),
        child: ListView.builder(
          itemCount: listAttandance.length,
          itemBuilder: (BuildContext context, int index) {
            return new Container(
              padding: EdgeInsets.fromLTRB(4.0, 4.0, 4.0, 8.0),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.black87,
                ),
                borderRadius: BorderRadius.circular(4),
              ),
              margin: new EdgeInsets.all(4.0),
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    width: 120,
                    child: Text(
                      listAttandance[index].student,
                      style: new TextStyle(
                          color: Colors.blueAccent,
                          fontSize: 17,
                          fontFamily: "intel",
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.fromLTRB(16.0, 4.0, 4.0, 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    shadowColor: Colors.blueAccent,
                    color: Colors.white,
                    child: Radio(
                      activeColor: Colors.red,
                      value: value[index][0],
                      groupValue: groupValue[index],
                      onChanged: (val) {
                        setState(() {
                          setState(() => groupValue[index] = val);
                        });
                      },
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    shadowColor: Colors.blueAccent,
                    color: Colors.white,
                    child: Radio(
                      activeColor: Colors.red,
                      value: value[index][1],
                      groupValue: groupValue[index],
                      onChanged: (val) {
                        setState(() {
                          setState(() => groupValue[index] = val);
                          log.fine(groupValue.toString());
                        });
                      },
                    ),
                  ),
                  Card(
                    elevation: 4,
                    margin: EdgeInsets.fromLTRB(8.0, 4.0, 4.0, 4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    shadowColor: Colors.blueAccent,
                    color: Colors.white,
                    child: Radio(
                      activeColor: Colors.black12,
                      value: value[index][2],
                      groupValue: groupValue[index],
                      onChanged: (val) {
                        setState(() {
                          setState(() => groupValue[index] = val);
                          log.fine(groupValue.toString());
                        });
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
