import 'dart:convert';
import 'dart:io';

import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_applicationdemo08/APIContent.dart';
import 'package:flutter_applicationdemo08/Dashboard.dart';
import 'package:flutter_applicationdemo08/common_widget/ProcessDialog.dart';
import 'package:flutter_applicationdemo08/helper/SharedPreferencesClass.dart';
import 'package:flutter_applicationdemo08/helper/CustomToast.dart';
import 'package:flutter_applicationdemo08/helper/Util.dart';
import 'package:flutter_applicationdemo08/models/HolidayListModel.dart';
import 'package:flutter_calendar_carousel/classes/event.dart';
import 'package:flutter_calendar_carousel/classes/event_list.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart'
    show CalendarCarousel;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HolidayScreem extends StatefulWidget {
  @override
  _ScreenCalendarState createState() => new _ScreenCalendarState();
}

class _ScreenCalendarState extends State<HolidayScreem> {
  static String noEventText = "No event here";
  String calendarText = noEventText;
  List<HolidayListModel> listHoliday = List();

  Future<void> getHolidayList(BuildContext context) async {
    ProcessDialog().showProgressDialog(context, "Please wait ...");

    final body = {
      ApiContent.PREF_KEY_school_id:
          (await SharedPreferencesClass.get(ApiContent.PREF_school_id))
              .toString()
    };

    final headers = {HttpHeaders.contentTypeHeader: 'application/json'};
    var uri = Uri.https(
        ApiContent.PREF_BASE_URL, ApiContent.PREF_GET_HOLIDAY_LIST, body);

    var response = await http.post(uri, headers: headers);
    log.fine(response.body);
    // Navigator.pop(context);

    if (response.statusCode == 200) {
      List<dynamic> list = json.decode(response.body);

      if (list.length > 0) {
        for (var i = 0; i < list.length; i++) {
          HolidayListModel _HolidayListModel =
              HolidayListModel.fromJson(list[i]);
          listHoliday.add(_HolidayListModel);

          log.fine(" $i >> " + _HolidayListModel.startDate.toString());
          log.fine(
              int.parse(_HolidayListModel.startDate.toString().substring(0, 2))
                      .toString() +
                  " , " +
                  _HolidayListModel
                      .startDate
                      .toString()
                      .substring(3, 5)
                      .toString() +
                  " , " +
                  _HolidayListModel.startDate
                      .toString()
                      .substring(6, 10)
                      .toString());

          _markedDateMap.add(
              DateTime(
                  int.parse(
                      _HolidayListModel.startDate.toString().substring(6, 10)),
                  int.parse(
                      _HolidayListModel.startDate.toString().substring(3, 5)),
                  int.parse(
                      _HolidayListModel.startDate.toString().substring(0, 2))),
              new Event(
                date: DateTime(
                    int.parse(_HolidayListModel.startDate
                        .toString()
                        .substring(6, 10)),
                    int.parse(
                        _HolidayListModel.startDate.toString().substring(3, 5)),
                    int.parse(_HolidayListModel.startDate
                        .toString()
                        .substring(0, 2))),
                title: _HolidayListModel.title,
                icon: _eventIcon,
              ));

          setState(() {});
        }
      } else {
        CustomToast.show(ApiContent.something_wrong, context);
        Util().showMessageDialog(
            context, ApiContent.something_wrong, ApiContent.try_later, false);
      }
    } else {
      Util().showMessageDialog(
          context, ApiContent.something_wrong, ApiContent.try_later, false);
    }
  }

  @override
  void initState() {
    super.initState();

    asyncMethod();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Holidays'),
        ),
        body: ConnectivityWidget(
          builder: (context, isOnline) => Center(
            child: SingleChildScrollView(
                child: Column(children: <Widget>[
                  Card(
                      child: CalendarCarousel(
                        weekendTextStyle: TextStyle(
                          color: Colors.red,
                        ),
                        weekFormat: false,
                        selectedDayBorderColor: Colors.green,
                        markedDatesMap: _markedDateMap,
                        selectedDayButtonColor: Colors.green,
                        selectedDayTextStyle: TextStyle(color: Colors.green),
                        todayBorderColor: Colors.transparent,
                        weekdayTextStyle: TextStyle(color: Colors.black),
                        height: 420.0,
                        daysHaveCircularBorder: true,
                        todayButtonColor: Colors.indigo,
                        onDayPressed: (DateTime date, List<Event> events) {
                          this.setState(() => refresh(date));
                        },
                      )),
                  Card(
                      child: Container(
                          child: Padding(
                              padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 16.0),
                              child: Center(
                                  child: Text(
                                    calendarText,
                                    style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 24,
                                        fontFamily: "intel",
                                        fontWeight: FontWeight.w700),
                                  )))))
                ])),
          ),
        )
      );
  }

  void refresh(DateTime date) {
    print('@@selected date ' +
        date.day.toString() +
        date.month.toString() +
        date.year.toString() +
        ' ' +
        date.toString());

    if (_markedDateMap
            .getEvents(new DateTime(date.year, date.month, date.day))
            .length >
        0) {
      calendarText = _markedDateMap
          .getEvents(new DateTime(date.year, date.month, date.day))[0]
          .title;
    } else {
      calendarText = noEventText;
    }
  }

  void asyncMethod() async {
    await getHolidayList(context);
  }
}

EventList<Event> _markedDateMap = new EventList<Event>();

Widget _eventIcon = new Container(
  decoration: new BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.all(Radius.circular(1000)),
      border: Border.all(color: Colors.blue, width: 2.0)),
  child: new Icon(
    Icons.person,
    color: Colors.amber,
  ),
);
