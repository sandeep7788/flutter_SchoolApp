
import 'dart:ui';

import 'package:flutter/material.dart';

import 'helper/FormValidator.dart';
// import 'package:flutter_applicationdemo08/Dashboard.dart';
var url="https://mobikul.com/wp-content/uploads/2019/02/Login-Page.jpg";

class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
 
  @override
  State<StatefulWidget> createState() {
    return new _LoginPageState();
  }
}
 
class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _key = new GlobalKey();
  bool _validate = false;
  LoginRequestData _loginData = LoginRequestData();
  bool _obscureText = true;
 
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new SingleChildScrollView(
          child: new Container(
            margin: new EdgeInsets.all(20.0),
            child: Center(
              child: new Form(
                key: _key,
                autovalidate: _validate,
                child: _getFormUI(),
              ),
            ),
          ),
        ),
      ),
    );
  }
 
  Widget _getFormUI() {
    return new Column(
      children: <Widget>[
        Icon(
          Icons.person,
          color: Colors.lightBlue,
          size: 100.0,
        ),
        new SizedBox(height: 50.0),
        new TextFormField(
          keyboardType: TextInputType.emailAddress,
          autofocus: false,
          decoration: InputDecoration(
            hintText: 'Email',
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
          ),
          validator: FormValidator().validateEmail,
          onSaved: (String value) {
            _loginData.email = value;
          },
        ),
        new SizedBox(height: 20.0),
        new TextFormField(
            autofocus: false,
            obscureText: _obscureText,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              hintText: 'Password',
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(32.0)),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                  semanticLabel:
                      _obscureText ? 'show password' : 'hide password',
                ),
              ),
            ),
            validator: FormValidator().validatePassword,
            onSaved: (String value) {
              _loginData.password = value;
            }),
        new SizedBox(height: 15.0),
        new Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: _sendToServer,
            padding: EdgeInsets.all(12),
            color: Colors.lightBlueAccent,
            child: Text('Log In', style: TextStyle(color: Colors.white)),
          ),
        ),
        new FlatButton(
          child: Text(
            'Forgot password?',
            style: TextStyle(color: Colors.black54),
          ),
          onPressed: _showForgotPasswordDialog,
        ),
        new FlatButton(
          onPressed: _sendToRegisterPage,
          child: Text('Not a member? Sign up now',
              style: TextStyle(color: Colors.black54)),
        ),
      ],
    );
  }
 
  _sendToRegisterPage() {
  ///Go to register page
  }
 
  _sendToServer() {
    if (_key.currentState.validate()) {
      /// No any error in validation
      _key.currentState.save();
      print("Email ${_loginData.email}");
      print("Password ${_loginData.password}");
    } else {
      ///validation error
      setState(() {
        _validate = true;
      });
    }
  }
 
  Future<Null> _showForgotPasswordDialog() async {
    await showDialog<String>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: const Text('Please enter your eEmail'),
            contentPadding: EdgeInsets.all(5.0),
            content: new TextField(
              decoration: new InputDecoration(hintText: "Email"),
              onChanged: (String value) {
                _loginData.email = value;
              },
            ),
            actions: <Widget>[
              new FlatButton(
                child: new Text("Ok"),
                onPressed: () async {
                  _loginData.email = "";
                  Navigator.pop(context);
                },
              ),
              new FlatButton(
                child: new Text("Cancel"),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }
}
 

class LoginRequestData {
  String email = '';
  String password = '';
}


