import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/common_widget/ListItemWidgets.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";
var getClassUrl =
    "http://vidhyalaya.co.in/sspanel/API/holiday/getclasses?school_id=32";

get borderRadius => BorderRadius.circular(8.0);
TextEditingController str_homework_title = TextEditingController();
TextEditingController str_homework_description = TextEditingController();
File _image;

Future getClassList() async {
  var uri = Uri.parse(getClassUrl);
  var response = await http.get(
    uri,
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'
    },
  );

          String arrayText = '[{"name": "dart1","quantity": 12 },{"name": "flutter2","quantity": 25 }]';

          var tagsJson = jsonDecode(arrayText);
          List<dynamic> tags = tagsJson != null ? List.from(tagsJson) : null;

          print(">> " + tags[0]["name"]);
          print(">> " + tags[1]["name"]);
          print(">> " + tags[0]["quantity"].toString());
          print(">> " + tags[1]["quantity"].toString());
}

class AddHomeworkScreen extends StatefulWidget {
  _AddHomeworkScreen createState() => _AddHomeworkScreen();
}

class _AddHomeworkScreen extends State<AddHomeworkScreen> {
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
    return Expanded(
      child: Container(
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
      ),
    );
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
                  margin: EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                          child: InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: Text("Classes"),
                                  content: setupAlertDialoadContainer(),
                                );
                              });
                        },
                        child: _Button(0, Icons.class_, "Class", context),
                      )),
                      _Button(
                          1, Icons.people_outline_outlined, "Section", context),
                    ],
                  )),
              Container(
                margin: EdgeInsets.only(top: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _Button(2, Icons.subject, "Subject", context),
                    _Button(3, Icons.date_range, "Submission Date", context),
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
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        padding: EdgeInsets.all(16),
                        margin: EdgeInsets.only(top: 16, right: 12, left: 12),
                        height: 200,
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

  Widget setupAlertDialoadContainer() {
    return Container(
      height: 300.0, // Change as per your requirement
      width: 300.0, // Change as per your requirement
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: 5,
        itemBuilder: (BuildContext context, int index) {
          return Expanded(
              child: InkWell(
            onTap: () {
              getClassList();
              print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@1");
            },
            child: ListButton(0, Icons.class_, "Class", context),
          ));
        },
      ),
    );
  }
}

class Post {
  final String temperature, rain, humidity, sunrise, sunset, updateDate;

  Post({
    this.temperature,
    this.rain,
    this.humidity,
    this.sunrise,
    this.sunset,
    this.updateDate,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return new Post(
      temperature: json['temperature'].toString(),
      rain: json['rain'].toString(),
      humidity: json['humidity'].toString(),
      sunrise: json['sunrise'].toString(),
      sunset: json['sunset'].toString(),
      updateDate: json['utcTime'].toString(),
    );
  }
}
