import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_applicationdemo08/APIContent.dart';
import 'package:flutter_applicationdemo08/common_widget/CustomButton.dart';
import 'package:flutter_applicationdemo08/common_widget/ListItemWidgets.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/common_widget/widgetCustomButton.dart';
import 'package:flutter_applicationdemo08/helper/CustomToast.dart';
import 'package:flutter_applicationdemo08/helper/FormValidator.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/models/AccountDetailsModel.dart';
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

GlobalKey<FormState> _key = new GlobalKey();
bool _validate = false;
File _image;
String userName = "user name";
String emailID = "user@gmail.com";
String phoneNo = "1234567890";
String address = "jaipur rajasthan";
String profileImage = "";
bool isEditable = false;

TextEditingController _teacherName = TextEditingController();
TextEditingController _teacher_mail = TextEditingController();
TextEditingController _teacherAddress = TextEditingController();
TextEditingController _teacherMobileNo = TextEditingController();

class AccountSetting extends StatefulWidget {
  AccountSetting({Key key}) : super(key: key);

  @override
  _AccountSetting createState() => _AccountSetting();
}

class _AccountSetting extends State<AccountSetting> {
  updateProfile(BuildContext context) async {
    ProcessDialog().showProgressDialog(context, "Please wait ...");
    log.fine("res.body");
    var request = http.MultipartRequest(
        'POST', Uri.parse(ApiContent.PREF_POST_INSERT_MOMENT));

    request.fields['school_id'] =
        await SharedPreferencesClass.get(ApiContent.PREF_school_id);
    request.fields['userid'] =
        await SharedPreferencesClass.get(ApiContent.PREF_userid);
    request.fields['address'] = _teacherAddress.text;

    request.files.add(await http.MultipartFile.fromPath('file', _image.path));
    var response = await request.send();
    log.fine(response.stream.toString());
    log.fine(response.statusCode.toString());
    final res = await http.Response.fromStream(response);
    log.fine(res.body);

    var json = jsonDecode(res.body.toString());
    var nameJson = json['status'];
    String nameString = jsonEncode(nameJson);
    print(nameString);

    Navigator.pop(context);

    if (nameJson == "Success") {
      Util().showMessageDialog(
          context, "Updated", "Profile updated successfully", false);
    } else {
      Util().showMessageDialog(context, ApiContent.something_wrong,
          ApiContent.something_wrong, false);
    }
  }

  getProfile(BuildContext context) async {
    // ProcessDialog().showProgressDialog(context, "Please wait ...");

    final body = {
      ApiContent.PREF_school_id:
          await SharedPreferencesClass.get(ApiContent.PREF_school_id),
      ApiContent.PREF_userid:
          await SharedPreferencesClass.get(ApiContent.PREF_userid),
    };

    var schoolId=await SharedPreferencesClass.get(ApiContent.PREF_school_id);
    var userId=await SharedPreferencesClass.get(ApiContent.PREF_userid);
    userName=await SharedPreferencesClass.get(ApiContent.PREF_name);

    log.fine(ApiContent.PREF_GET_TEACHER_PROFILE+"?"+ApiContent.PREF_school_id+"=$schoolId"+"&"+ApiContent.PREF_userid+"=$userId");
    var uri = Uri.parse(ApiContent.PREF_GET_TEACHER_PROFILE+"?"+ApiContent.PREF_school_id+"=$schoolId"+"&"+ApiContent.PREF_userid+"=$userId");

    var response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
    );

    log.fine("message"+response.body);

    // Navigator.pop(context);

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);

      if (list.length > 0) {
        AccountDetailsModel _AccountDetailsModel =
            AccountDetailsModel.fromJson(list[0]);

        setState(() {
          emailID = _AccountDetailsModel.email;
          address = _AccountDetailsModel.address;
          phoneNo = _AccountDetailsModel.phonenumber;
          profileImage = _AccountDetailsModel.profileimage;
        });
      } else {
        CustomToast.show(ApiContent.something_wrong, context);
        Util().showMessageDialog(
            context, ApiContent.something_wrong, ApiContent.try_later, true);
      }
    } else {
      CustomToast.show(ApiContent.something_wrong, context);
      Util().showMessageDialog(
          context, ApiContent.something_wrong, ApiContent.try_later, true);
    }
  }

  _imgFromCamera() async {
    File image = (await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 50));

    setState(() {
      _image = image;
    });
  }

  _imgFromGallery() async {
    File image = (await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 50));

    setState(() {
      _image = image;
    });
  }

  _showPicker(context) {
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
              leading: new Icon(Icons.photo_camera, color: Colors.blueAccent),
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
  }

  @override
  Widget build(BuildContext context) {

    getProfile(context);

    return MaterialApp(
        home: Scaffold(
            bottomNavigationBar: BottomAppBar(
              color: Colors.transparent,
              child: GestureDetector(
                onTap: () {
                  _sendToServer(context);
                },
                child: widgetCustomButton("Update profile", context),
              ),
              elevation: 0,
            ),
            appBar: AppBar(
              title: Text("Teacher Profile"),
              leading: IconButton(
                icon: Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Util().navigateToBack(context);
                },
              ),
              actions: <Widget>[
                Visibility(
                  visible: !isEditable,
                  child: IconButton(
                      icon: Icon(Icons.edit),
                      onPressed: () {
                        setState(() {
                          isEditable = true;
                        });
                      }),
                )
              ],
              centerTitle: true,
            ),
            body: profileUi(context)));
  }

  Widget profileUi(BuildContext context) {
    return new Center(
      child: new SingleChildScrollView(
        child: new Container(
          margin: new EdgeInsets.all(20.0),
          child: Center(
            child: new Form(
              key: _key,
              autovalidate: _validate,
              child: _getFormUI(context),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Future<void> initState() {
    super.initState();
    // setProfileData();
  }

  setProfileData() async {
    _teacher_mail.text =
        await SharedPreferencesClass.get(ApiContent.PREF_school_id);
    _teacherAddress.text =
        await SharedPreferencesClass.get(ApiContent.PREF_school_id);
    _teacherName.text = await SharedPreferencesClass.get(ApiContent.PREF_name);
    _teacherMobileNo.text =
        await SharedPreferencesClass.get(ApiContent.PREF_school_id);
  }

  _showBottomSheet(BuildContext context) {
    showModalBottomSheet<void>(
        context: context,
        builder: (BuildContext context) {
          return _showPicker(context);
        });
  }

  Widget _userImage(BuildContext context) {
    return Stack(children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              width: double.infinity,
              margin: EdgeInsets.only(top: 48),
              height: 300,
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(16.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 60,
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontFamily: 'intel'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Email ID: " + emailID,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'intel'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Phone No: " + phoneNo,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'intel'),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "Address: " + address,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                        fontFamily: 'intel'),
                  ),
                  new Expanded(
                      child: new Align(
                          alignment: Alignment.bottomCenter,
                          child: Card(
                            margin: EdgeInsets.only(
                                bottom: 24, right: 80, left: 80),
                            shadowColor: Colors.white,
                            elevation: 4,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12.0, horizontal: 16),
                              child: Text(
                                "Edit Profile",
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.blue,
                                    fontFamily: 'intel'),
                              ),
                            ),
                          )))
                ],
              )),
        ],
      ),
      Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            child: CircleAvatar(
              radius: 50.0,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: CircleAvatar(
                    backgroundColor: Colors.blue,
                    radius: 12.0,
                    child: Icon(
                      Icons.camera_alt,
                      size: 15.0,
                      color: Color(0xFF404040),
                    ),
                  ),
                ),
                radius: 48.0,
                backgroundImage: AssetImage('assets/photo.png'),
              ),
            ),
          )),
    ]);
  }

  Widget _getFormUI(BuildContext context) {
    return Center(
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Center(
            child: _userImage(context),
          ),
          new SizedBox(height: 50.0),
          new TextFormField(
            controller: _teacherName,
            keyboardType: TextInputType.name,
            autofocus: true,
            enabled: isEditable,
            decoration: InputDecoration(
              hintText: 'Name',
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            validator: FormValidator().validName,
          ),
          new SizedBox(height: 20.0),
          new TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            controller: _teacher_mail,
            enabled: isEditable,
            decoration: InputDecoration(
              hintText: 'Email',
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            validator: FormValidator().validateEmail,
          ),
          new SizedBox(height: 20.0),
          new TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: false,
            controller: _teacherAddress,
            enabled: isEditable,
            decoration: InputDecoration(
              hintText: 'Address',
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            validator: FormValidator().validTextNotBeEmpty,
          ),
          new SizedBox(height: 20.0),
          new TextFormField(
            keyboardType: TextInputType.number,
            autofocus: false,
            controller: _teacherMobileNo,
            enabled: isEditable,
            decoration: InputDecoration(
              hintText: 'Number',
              contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
            ),
            validator: FormValidator().validateNumber,
          ),
        ],
      ),
    );
  }

  _sendToRegisterPage() {
    ///Go to register page
  }

  _sendToServer(BuildContext context) {
    if (_key.currentState.validate()) {
      _key.currentState.save();
      log.fine("valid");
      updateProfile(context);
    } else {
      log.fine("not valid");
      setState(() {
        _validate = true;
      });
    }
  }
}
/* add staff member
* '*' add all screen
* '*'
* upload clinic
* */
