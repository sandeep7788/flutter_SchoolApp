import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/APIContent.dart';
import 'package:flutter_applicationdemo08/Dashboard.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/common_widget/RaisedGradientButton.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/CustomToast.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/models/SignUppModel.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignUp();
  }
}

final GlobalKey<State> _keyLoader = new GlobalKey<State>();

Future<SignUppModel> doSignUp(
    BuildContext context, String number, String password) async {
  ProcessDialog().showProgressDialog(context, "Please wait ...");

  final body = {
    ApiContent.PREF_NUMBER: number.trim(),
    ApiContent.PREF_PASS: password.trimRight(),
    ApiContent.PREF_REMEMBER_TOKEN: " ",
  };
  final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
  var uri = Uri.https(ApiContent.PREF_BASE_URL, ApiContent.PREF_GET_LOGIN, body);
  var response = await http.post(uri, headers: headers);

  Navigator.pop(context);
  if (response.statusCode == 200) {
    List<dynamic> list = json.decode(response.body);

    if (list.length > 0) {

      SignUppModel _SignUppModel = SignUppModel.fromJson(list[0]);
      print("@@@@" + _SignUppModel.name);
      SharedPreferencesClass.save(ApiContent.PREF_userid,_SignUppModel.userid);
      SharedPreferencesClass.save(ApiContent.PREF_login,_SignUppModel.login);
      SharedPreferencesClass.save(ApiContent.PREF_name,_SignUppModel.name);
      SharedPreferencesClass.save(ApiContent.PREF_facultyid,_SignUppModel.facultyid);
      SharedPreferencesClass.save(ApiContent.PREF_image,_SignUppModel.image);
      SharedPreferencesClass.save(ApiContent.PREF_class_teacher,_SignUppModel.classTeacher);
      SharedPreferencesClass.save(ApiContent.PREF_school_id,_SignUppModel.schoolId);
      SharedPreferencesClass.save(ApiContent.PREF_school_name,_SignUppModel.schoolName);
      SharedPreferencesClass.save(ApiContent.PREF_school_session,_SignUppModel.schoolSession);
      SharedPreferencesClass.setLogin(true);

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Dashboard()));

    } else {
      CustomToast.show(ApiContent.something_wrong, context);
      Util().showMessageDialog(context,ApiContent.something_wrong,ApiContent.try_later,false);
    }
  } else {
    Util().showMessageDialog(context,ApiContent.something_wrong,ApiContent.try_later,false);
  }
}

class _SignUp extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.40,
                width: double.infinity,
                color: Colors.blue,
              ),
              Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 80),
                    child: Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 19),
                    ),
                  )),
              Positioned(
                top: 150,
                left: 10,
                right: 10,
                child: LoginFormWidget(),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class LoginFormWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _LoginFormWidgetState();
  }
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _formKey = GlobalKey<FormState>();
  var _userNumberController = TextEditingController(text: "");
  var _userPasswordController = TextEditingController(text: "");
  var _emailFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  bool _isPasswordVisible = true;
  bool _autoValidate = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      autovalidate: _autoValidate,
      child: Column(
        children: <Widget>[
          Card(
            elevation: 8,
            child: Column(
              children: <Widget>[
                _buildLogo(),
                _buildIntroText(),
                _buildNumberField(context),
                _buildPasswordField(context),
                _buildForgotPasswordWidget(context),
                _buildSignUpButton(context),
              ],
            ),
          ),
          _buildSignUp(),
        ],
      ),
    );
  }

  Widget _buildLoginOptionText() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        "Or sign up with social account",
        style: TextStyle(
            fontSize: 14, color: Colors.black54, fontWeight: FontWeight.w600),
      ),
    );
  }

  Widget _buildIntroText() {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 30),
          child: Text(
            "Login Panel",
            style: TextStyle(
                color: Colors.black54,
                fontSize: 18.0,
                fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildLogo() {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Icon(
        Icons.school,
        color: Colors.blueAccent,
        size: 50,
      ),
    );
  }

  String _userNameValidation(String value) {
    if (value.isEmpty) {
      return ApiContent.please_enter_number;
    } else {
      return null;
    }
  }

  Widget _buildNumberField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userNumberController,
        keyboardType: TextInputType.number,
        textInputAction: TextInputAction.next,
        maxLength: 13,
        decoration: InputDecoration(
          labelText: "Mobile Number",
          hintText: "Enter your mobile number",
          labelStyle: TextStyle(color: Colors.black),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_passwordFocusNode);
        },
        validator: (value) => _numberValidation(value),
        // decoration: CommonStyles.textFormFieldStyle("Email", ""),
      ),
    );
  }

  String _numberValidation(String value) {
    if (value.length < 9) {
      return "Enter valid number";
    } else {
      return null;
    }
  }

  Widget _buildPasswordField(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 5),
      child: TextFormField(
        controller: _userPasswordController,
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        maxLength: 15,
        onFieldSubmitted: (_) {
          FocusScope.of(context).requestFocus(_emailFocusNode);
        },
        validator: (value) => _userNameValidation(value),
        obscureText: _isPasswordVisible,
        decoration: InputDecoration(
          labelText: "Password",
          hintText: "Enter your secret password",
          labelStyle: TextStyle(color: Colors.black),
          alignLabelWithHint: true,
          contentPadding: EdgeInsets.symmetric(vertical: 5),
          suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              }),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(
              color: Colors.black,
            ),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildForgotPasswordWidget(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
            onPressed: () {},
            child: Text(
              'Forgot your password ?',
              style:
                  TextStyle(color: Colors.black54, fontWeight: FontWeight.w500),
            )),
      ),
    );
  }

  Widget _buildSignUpButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 30.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        width: double.infinity,
        child: RaisedGradientButton(
          child: Text(
            "Login",
            style: TextStyle(
                color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          onPressed: () {
            _signUpProcess(context);
          },
        ),
      ),
    );
  }

  void _signUpProcess(BuildContext context) {
    if (_userNumberController.text.length > 9) {
      doSignUp(
          context, _userNumberController.text, _userPasswordController.text);
    } else {
      setState(() {
        _autoValidate = true;
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(ApiContent.please_enter_number),
        ));
      });
    }
  }

  void _clearAllFields() {
    setState(() {
      _userNumberController = TextEditingController(text: "");
      _userPasswordController = TextEditingController(text: "");
    });
  }

  Widget _buildSignUp() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: RichText(
        text: TextSpan(
          style: DefaultTextStyle.of(context).style,
          children: <TextSpan>[
            TextSpan(
              text: "Don't have an Account ? ",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
            ),
            TextSpan(
              text: 'Register',
              style: TextStyle(
                  fontWeight: FontWeight.w800,
                  color: Colors.orange,
                  fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
