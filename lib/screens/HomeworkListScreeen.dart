import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/list_item_widget/HomeWorkListCard.dart';
import 'package:flutter_applicationdemo08/model/HomeWorkModel.dart';

import 'AddHomeworkScreen.dart';

var url = "https://miro.medium.com/max/2160/1*9JzKFil-Xsip742fdxDqZw.jpeg";

class HomeworkListScreeen extends StatefulWidget {
  _AddHomeworkScreen createState() => _AddHomeworkScreen();
}

class _AddHomeworkScreen extends State<HomeworkListScreeen> {
  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return _menuList(context);
    });
  }

  Widget _menuList(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Work"),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        centerTitle: true,
      ),
      body: _homeWorkLisWidget(context),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_to_photos,color: Colors.white),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddHomeworkScreen()));
          }
      ),
    );
  }

  _homeWorkLisWidget(BuildContext context) {
    return Container(
        color: Colors.white,
        child: GridView.count(
          crossAxisCount: 1,
          crossAxisSpacing: 2.0,
          mainAxisSpacing: 2.0,
          children: List.generate(arr_homeWork.length, (index) {
            return Center(
              child: new Column(
                children: [
                  new Expanded(
                    child:
                        HomeWorkListCard(mHomework_model: arr_homeWork[index]),
                  ),
                ],
              ),
            );
          }),
        ));
  }
}

const List<HomeWorkModel> arr_homeWork = const <HomeWorkModel>[
  const HomeWorkModel(title: 'Home', icon: Icons.home),
  const HomeWorkModel(title: 'Holiday', icon: Icons.weekend_sharp),
  const HomeWorkModel(title: 'Moment', icon: Icons.collections),
  const HomeWorkModel(title: 'Leave Request', icon: Icons.request_page),
  const HomeWorkModel(
      title: 'Answer Sheet', icon: Icons.question_answer_outlined),
  const HomeWorkModel(title: 'Help', icon: Icons.mobile_friendly),
  const HomeWorkModel(title: 'Attendances', icon: Icons.people_alt_outlined),
  const HomeWorkModel(
      title: 'Notification', icon: Icons.notifications_active_outlined),
  const HomeWorkModel(title: 'WiFi', icon: Icons.wifi),
];
