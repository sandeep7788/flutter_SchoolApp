import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/Dashboard.dart';
import 'package:flutter_applicationdemo08/models/HomeWorkListModel.dart';

class HomeWorkListCard extends StatelessWidget {
  const HomeWorkListCard({Key key, this.mHomework_model}) : super(key: key);
  final HomeWorkListModel mHomework_model;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 1,
            childAspectRatio: 1,
            mainAxisSpacing: 1,
            crossAxisSpacing: 1),
        itemBuilder: (contxt, indx) {
          return GestureDetector(
            child: Card(
              elevation: 4,
              margin: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 8.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(0.0),
              ),
              shadowColor: Colors.blueAccent,
              color: Colors.white70,
              child: Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Container(
                  width: 4,
                  child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        new Expanded(
                          child: new Container(
                              child: new Image(image: NetworkImage(url))),
                          flex: 2,
                        ),
                        new Expanded(
                          child: new Container(
                              margin: EdgeInsets.only(top: 12),
                              child: new Text(
                                mHomework_model.title,
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              )),
                          flex: 1,
                        ),
                      ]),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
