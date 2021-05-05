import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/APIContent.dart';
import 'package:flutter_applicationdemo08/common_widget/ListItemWidgets.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/models/ClassModel.dart';
import 'package:flutter_applicationdemo08/models/SectionModel.dart';
import 'package:flutter_applicationdemo08/models/StudentAttandanceModel.dart';
import 'package:http/http.dart' as http;

import 'AddHomeworkScreen.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";
var TAG = "@@@@HOMEWORK";
File _image;
List<ClassModel> listClasses = List();
List<StudentAttandanceModel> listAttandance = List();
List<SectionModel> listSection = List();

List<YourObject> radioButtonId = new List();

class AttandenceScreen extends StatefulWidget {
  _AddHomeworkScreen createState() => _AddHomeworkScreen();
}

class _AddHomeworkScreen extends State<AttandenceScreen> {
  int _selectedItem = 0;




  Future getClassList(BuildContext context) async {
    ProcessDialog().showProgressDialog(context, "Please wait ...");

    var uri = Uri.parse(ApiContent.PREF_GET_CLASSES);
    var response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200 && response.body.length > 0) {
      List<dynamic> list = json.decode(response.body);

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
                content: setupAlertDialoadClassList(
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

    var uri = Uri.parse(ApiContent.PREF_GET_STUDENT);
    var response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    if (response.statusCode == 200 && response.body.length > 0) {
      List<dynamic> list = json.decode(response.body);

      for (var i = 0; i < list.length; i++) {
        StudentAttandanceModel fact = StudentAttandanceModel.fromJson(list[i]);
        listAttandance.add(fact);

        for (var j = 0; j < 4; j++)
        radioButtonId.add(YourObject(index0: i,index1: j));

      }
      setState(() {});
    } else {
      Navigator.pop(context);
    }
  }

  Future getSectionList(BuildContext context) async {
    var uri = Uri.parse(ApiContent.PREF_GET_SECTION);
    var response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );
    print("@@@@" + response.body);

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
                content: setupAlertDialoadClassList(
                    context, listSection, Icons.people_outline_outlined, 1),
              );
            });
      }
    }
  }

  Widget setupAlertDialoadClassList(
      BuildContext context, List<dynamic> mList, IconData mIconData, int type) {
    return Container(
      height: 500.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: mList.length,
        itemBuilder: (BuildContext context, int index) {
          return Expanded(
              child: InkWell(
            onTap: () {
              setState(() {
                if (type == 0) {
                  classSelected = mList[index].classes;
                } else if (type == 1) {
                  sectionSelected = mList[index].section;
                } else {
                  subjectSelected = mList[index].subject;
                }
                Navigator.pop(context);
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



  String radioButtonItem = 'ONE';

  @override
  void initState() {
    super.initState();
    getstudents(context);
  }

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Home Work"),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
        ),
        body: Container(
          margin: EdgeInsets.only(left: 8, right: 8),
          child: ListView(
            children: [
              Container(
                  height: 52,
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          getClassList(context);
                        },
                        child: customButton(
                            0, Icons.class_, classSelected, context),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          getSectionList(context);
                        },
                        child: customButton(1, Icons.people_outline_outlined,
                            sectionSelected, context),
                      )),
                    ],
                  )),
/*
              Container(
                child: Expanded(
                    child: Container(
                  height: 350.0,
                  child: ListView.builder(
                    itemCount: listAttandance.length,
                    itemBuilder: (BuildContext context, int index) {
                      return  new Container(
                        margin: new EdgeInsets.all(15.0),
                        child: new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Radio(
                              value: radioButtonId[index].index1,
                              groupValue: index,
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = 'TWO';
                                  radioButtonId[index].index1 = index;
                                });
                              },
                            ),
                            Text(
                              'TWO',
                              style: new TextStyle(
                                fontSize: 12.0,
                              ),
                            ),

                            Radio(
                              value: id,
                              groupValue: index,
                              onChanged: (val) {
                                setState(() {
                                  radioButtonItem = 'THREE';
                                  id = index;
                                });
                              },
                            ),
                            Text(
                              'THREE',
                              style: new TextStyle(fontSize: 12.0),
                            ),
                            new Container(
                              margin: new EdgeInsets.only(left: 10.0),
                              child: new Text(listAttandance[index].student),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )),
              )
*/
            ],
          ),
        ),
      );
    });
  }
}


class YourObject {
  final int index0;
  final int index1;

  YourObject({this.index0, this.index1});
}