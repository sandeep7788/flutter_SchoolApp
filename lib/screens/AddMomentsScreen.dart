import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/APIContent.dart';
import 'package:flutter_applicationdemo08/common_widget/ListItemWidgets.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/common_widget/widgetCustomButton.dart';
import 'package:flutter_applicationdemo08/helper/CustomToast.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/models/ClassModel.dart';
import 'package:flutter_applicationdemo08/models/SectionModel.dart';
import 'package:flutter_applicationdemo08/models/SubjectModel.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io';
import 'package:http/http.dart' as http;

import '../Dashboard.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";

get borderRadius => BorderRadius.circular(8.0);
TextEditingController controllerTitle = TextEditingController();
TextEditingController controllerDescription = TextEditingController();
File _image;

class AddMomentsScreen extends StatefulWidget {
  _AddMomentsScreen createState() => _AddMomentsScreen();
}

class _AddMomentsScreen extends State<AddMomentsScreen> {
  Upload(BuildContext context) async {
    ProcessDialog().showProgressDialog(context, "Please wait ...");
    log.fine("res.body");
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiContent.PREF_POST_INSERT_HOMEWORK));

    request.fields['school_id'] =
        await SharedPreferencesClass.get(ApiContent.PREF_school_id);
    request.fields['title'] = controllerTitle.text;
    request.fields['description'] = controllerDescription.text;
    request.fields['date'] = Util().getCurrentDate();
    request.fields['faculty'] =
        await SharedPreferencesClass.get(ApiContent.PREF_facultyid);
    request.files.add(await http.MultipartFile.fromPath('file', _image.path));
    var response = await request.send();
    log.fine(response.stream.toString());
    log.fine(response.statusCode.toString());
    final res = await http.Response.fromStream(response);
    log.fine(res.body);

    String myJSON =
        '{"name":{"first":"foo","last":"bar"}, "age":31, "city":"New York"}';
    var json = jsonDecode(res.body.toString());
    var nameJson = json['status'];
    String nameString = jsonEncode(nameJson);
    print(nameString);

    Navigator.pop(context);

    if (nameJson == "Success") {
      Util()
          .showMessageDialog(context, "Uploaded Succesfully", "uplaoded", true);
    } else {
      Util().showMessageDialog(context, ApiContent.something_wrong,
          ApiContent.something_wrong, false);
    }
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

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: GestureDetector(
            onTap: () {
              if (_image == null) {
                CustomToast.show(ApiContent.select_image, context);
              } else {
                Upload(context);
              }
            },
            child: widgetCustomButton("Add Moment", context),
          ),
          elevation: 0,
        ),
        appBar: AppBar(
          title: Text("Home Work"),
          iconTheme: IconThemeData(
            color: Colors.white, //change your color here
          ),
          centerTitle: true,
        ),
        body: ConnectivityWidget(
          builder: (context, isOnline) => Center(
            child: Container(
              child: ListView(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 12, right: 12, top: 24),
                    child: new Theme(
                      data: new ThemeData(
                        primaryColor: Colors.blue,
                        primaryColorDark: Colors.blueAccent,
                      ),
                      child: new TextField(
                        controller: controllerTitle,
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            hintText: 'Moment Title',
                            helperText: 'please enter min 10 characters',
                            labelText: 'Title',
                            prefixIcon: const Icon(
                              Icons.work,
                              color: Colors.blueAccent,
                            ),
                            prefixText: ' ',
                            suffixText: 'Eng',
                            suffixStyle:
                                const TextStyle(color: Colors.black87)),
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
                        controller: controllerDescription,
                        keyboardType: TextInputType.multiline,
                        decoration: new InputDecoration(
                            border: new OutlineInputBorder(
                                borderSide: new BorderSide(color: Colors.teal)),
                            hintText: 'Moment Description',
                            helperText: 'please enter min 25 characters',
                            labelText: 'Description',
                            prefixIcon: const Icon(
                              Icons.description,
                              color: Colors.blueAccent,
                            ),
                            prefixText: ' ',
                            suffixText: 'Des',
                            suffixStyle:
                                const TextStyle(color: Colors.black87)),
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
                            margin:
                                EdgeInsets.only(top: 16, right: 12, left: 12),
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
          ),
        ),
      );
    });
  }
}
