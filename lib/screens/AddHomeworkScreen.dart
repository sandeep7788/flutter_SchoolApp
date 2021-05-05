import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/APIContent.dart';
import 'package:flutter_applicationdemo08/common_widget/ListItemWidgets.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/models/ClassModel.dart';
import 'package:flutter_applicationdemo08/models/SectionModel.dart';
import 'package:flutter_applicationdemo08/models/SubjectModel.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";

get borderRadius => BorderRadius.circular(8.0);
TextEditingController str_homework_title = TextEditingController();
TextEditingController str_homework_description = TextEditingController();
var classSelected = "Classes";
var sectionSelected = "Section";
var subjectSelected = "Subject";
var dateSelected = "Submission Date";
File _image;
List<ClassModel> listClasses = List();
List<SectionModel> listSection = List();
List<SubjectModel> listSubject = List();

final GlobalKey<NavigatorState> _keyLoader = new GlobalKey<NavigatorState>();

class AddHomeworkScreen extends StatefulWidget {
  _AddHomeworkScreen createState() => _AddHomeworkScreen();
}

class _AddHomeworkScreen extends State<AddHomeworkScreen> {

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

  Future getSubjectList(BuildContext context) async {
    var uri = Uri.parse(ApiContent.PREF_GET_SUBJECT);
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
        SubjectModel fact = SubjectModel.fromJson(list[i]);
        listSubject.add(fact);
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
                    context, listSubject, Icons.book_outlined, 2),
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

  _imgFromCamera() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50);

    setState(() {
      _image = image;
    });
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(
                        Icons.photo_library,
                        color: Colors.blueAccent,
                      ),
                      title: new Text('Photo Library'),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading:
                        new Icon(Icons.photo_camera, color: Colors.blueAccent),
                    title: new Text('Camera'),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _Button(
      int type, IconData my_icon, String str_title, BuildContext _context) {
    return Container(
      margin: EdgeInsets.only(left: 2, right: 2),
      child: Material(
        shadowColor: Colors.blueAccent,
        elevation: 10,
        borderRadius: borderRadius,
        child: Container(
          height: 50.0,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
          ),
          child: Row(
            children: <Widget>[
              LayoutBuilder(builder: (context, constraints) {
                print(constraints);
                return Container(
                  height: constraints.maxHeight,
                  width: constraints.maxHeight,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: borderRadius,
                  ),
                  child: Icon(
                    my_icon,
                    color: Colors.white,
                  ),
                );
              }),
              Expanded(
                child: Text(
                  str_title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(ctx) {
    showCupertinoModalPopup(
        context: ctx,
        builder: (_) => Container(
              height: 190,
              color: Color.fromARGB(255, 255, 255, 255),
              child: Column(
                children: [
                  Container(
                    height: 180,
                    child: CupertinoDatePicker(
                        initialDateTime: DateTime.now(),
                        onDateTimeChanged: (val) {
                          setState(() {
                            dateSelected = val.toString();
                          });
                        }),
                  ),
                ],
              ),
            ));
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
                        child: _Button(0, Icons.class_, classSelected, context),
                      )),
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          getSectionList(context);
                        },
                        child: _Button(1, Icons.people_outline_outlined,
                            sectionSelected, context),
                      )),
                    ],
                  )),
              Container(
                height: 52,
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        getSubjectList(context);
                      },
                      child:
                          _Button(2, Icons.subject, subjectSelected, context),
                    )),
                    Expanded(
                        child: InkWell(
                      onTap: () {
                        _showDatePicker(context);
                      },
                      child:
                          _Button(3, Icons.date_range, dateSelected, context),
                    )),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12, right: 12, top: 24),
                child: new Theme(
                  data: new ThemeData(
                    primaryColor: Colors.blue,
                    primaryColorDark: Colors.blueAccent,
                  ),
                  child: new TextField(
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        hintText: 'HomeWork Title',
                        helperText: 'please enter min 10 characters',
                        labelText: 'Title',
                        prefixIcon: const Icon(
                          Icons.work,
                          color: Colors.blueAccent,
                        ),
                        prefixText: ' ',
                        suffixText: 'Eng',
                        suffixStyle: const TextStyle(color: Colors.black87)),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 12, right: 12, top: 8),
                child: new Theme(
                  data: new ThemeData(
                    primaryColor: Colors.blue,
                    primaryColorDark: Colors.blueAccent,
                  ),
                  child: new TextField(
                    minLines: 2,
                    maxLines: 5,
                    keyboardType: TextInputType.multiline,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.teal)),
                        hintText: 'HomeWork Description',
                        helperText: 'please enter min 25 characters',
                        labelText: 'Description',
                        prefixIcon: const Icon(
                          Icons.description,
                          color: Colors.blueAccent,
                        ),
                        prefixText: ' ',
                        suffixText: 'Des',
                        suffixStyle: const TextStyle(color: Colors.black87)),
                  ),
                ),
              ),
              Container(
                height: 200,
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(top: 16, right: 12, left: 12),
                        alignment: Alignment.center,
                        child: _image == null
                            ? Text(
                                'No image selected.',
                                style: TextStyle(fontSize: 16),
                              )
                            : Image.file(
                                _image,
                                fit: BoxFit.fill,
                              ),
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              new BorderRadius.all(new Radius.circular(8)),
                          border: _image == null
                              ? new Border.all(
                                  color: Colors.grey,
                                  width: 2.0,
                                )
                              : new Border.all(
                                  color: Colors.blueAccent,
                                  width: 2.0,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                        bottom: 15,
                        right: 24,
                        //give the values according to your requirement
                        child: GestureDetector(
                          onTap: () {
                            _showPicker(context);
                          },
                          child: Container(
                              child: Icon(
                            Icons.add_photo_alternate_outlined,
                            color: Colors.blueAccent,
                            size: 60,
                          )),
                        )),
                  ],
                ),
              )
            ],
          ),
        ),
      );
    });
  }
}
