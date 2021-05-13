import 'dart:math' as Math;
import 'dart:ui';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

const _TAG = 'Util';

typedef void VoidCallback();
typedef void SafeCastCallback<T>(T t);
class StringUtil {
  static bool equalIgnoreCase(String s1, String s2) => (s1?.toLowerCase() == s2?.toLowerCase());
  static bool isNullOrEmpty(String s) => s == null || s.isEmpty;
  static bool notNullOrEmpty(String s) => !isNullOrEmpty(s);
}

measure(fn, [Function(Duration) show]) {
  Stopwatch sw = new Stopwatch()..start();
  fn();
  sw..stop();
  final duration = sw.elapsed;
  if (show != null) show(duration);
  return duration;
}

T checkNotNull<T> (T t, [String message]) {
  assert(t != null, message);
  return t;
}



bool compare(double v1, double v2, [int fractionDigits]) {
  if (v1 == v2) return true;
  if (fractionDigits != null && v1 != null && v2 != null) {
    return v1.toStringAsFixed(fractionDigits) == v2.toStringAsFixed(fractionDigits);
  }
  return false;
}

bool compareDuration(Duration v1, Duration v2, [int fractionInMilliseconds]) {
  if (v1 == v2) return true;
  if (fractionInMilliseconds != null && v1 != null && v2 != null) {
    return v1.inMilliseconds / fractionInMilliseconds == v2.inMilliseconds / fractionInMilliseconds;
  }
  return false;
}

class Util {

  getCurrentDate() {
    return DateFormat('yyyy-MM-dd – kk:mm').format(DateTime.now());
  }

  getFormatedDate(_date) {
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    var inputDate = inputFormat.parse(_date);
    var outputFormat = DateFormat('dd/MM/yyyy');
    return outputFormat.format(inputDate);
  }

  showMessageDialog(BuildContext context, String title, String description,bool goBack) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              title,
              textAlign: TextAlign.center,style: TextStyle(
                fontSize: 21,
                fontFamily: 'intel'
            ),
            ),
            content: SingleChildScrollView(
              child: Text(
                description,
                style: Theme.of(context).textTheme.bodyText1,
                textAlign: TextAlign.left,
              ),
            ),
            actions: [
              FlatButton(
                child: Text(
                  'ok',
                  style: Theme.of(context).textTheme.bodyText2.copyWith(
                    color: Theme.of(context).accentColor,
                    fontFamily: 'intel'
                  ),
                ),
                onPressed: () => {
                  Navigator.pop(context)
                },
              ),
            ],
            actionsPadding: EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 5,
            ),
          );
        });
    if(goBack) {
      Navigator.pop(context);
    }
  }

  navigateToNextScreen(BuildContext context, StatefulWidget _StatefulWidget) {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => _StatefulWidget));
  }
  navigateToBack(BuildContext context) {
    Navigator.pop(context);
  }
  /// converter (to/from String)
  static String dateTimeToString(DateTime t) => t.toUtc().toIso8601String();
  static DateTime stringToDateTime(String s) => DateTime.parse(s).toUtc();

  static String durationToString(Duration d) => d?.inMicroseconds?.toString();
  static Duration stringToDuration(String s) => Duration(microseconds: int.parse(s));

  static String enumToString(Object e) {
    var result;
    if (e == null) {
      assert(false, '$_TAG:enumToString enum is null');
    } else {
      result = describeEnum(e);
      assert(result != null, '$_TAG:enumToString unable to parse enum obj: $e');
    }
    return result;
  }

  /// direct copy of 'package:flutter/foundation.dart' so that no need to import it
  static String describeEnum(Object enumEntry) {
    final String description = enumEntry.toString();
    final int indexOfDot = description.indexOf('.');
    assert(indexOfDot != -1 && indexOfDot < description.length - 1);
    return description.substring(indexOfDot + 1);
  }

  @deprecated
  static Map<String, String> stringifiedMap(Map<dynamic, dynamic> map) => map.map(stringifiedMapping);

  static void log() {}

}

/// ignoreNull = true will not throw error when input obj is null
/// assertResult = true will throw error when obj is not null and is not of given type T
T safeCast<T>(dynamic obj, {bool ignoreNull = true, bool assertResult = false,
  SafeCastCallback<T> onSuccess, VoidCallback onError}) {

  T result;
  if (obj == null) {
    if (!ignoreNull) {
      final error = "$_TAG:safeCast passed in obj is null";
      log.warning(error);
      assert(false, error);
    }
    result = null;
  }

  result = (obj is T) ? obj : null;
  if (result == null && obj != null) { // obj will never be null, but this looks more clear
    final error = "$_TAG:safeCast obj:$obj is not of type:${T.runtimeType}";
    log.severe(error);
    if (assertResult) assert(false, error);
  }
  if (result == null) {
    if (onError != null) onError();
  } else {
    if (onSuccess != null) onSuccess(result);
  }
  return result;
}


/// assert condition is true, otherwise throw exception with [message]
/// return assertion result;
/// typical usage:
///   if (! assertTrue(someImportantVar != null, "error")) return null;
///
bool assertTrue(bool condition, {String error, VoidCallback onSuccess, VoidCallback onError}) {
  assert(condition, error);
  if (!condition && onError != null) {
    onError();
  }
  return condition;
}
bool assertFalse(bool condition, {String error, VoidCallback onSuccess, VoidCallback onError})
=> assertTrue(!condition, error: error, onSuccess: onSuccess, onError: onError);

@deprecated
typedef MapEntry<String, String> StringifiedMappingType(dynamic key, dynamic value);
@deprecated
final StringifiedMappingType stringifiedMapping = (dynamic key, dynamic value) {
  assert(key is String, "key:$key is not of type String: ${key.runtimeType}");
  if (value == null) {
    log.fine('$_TAG stringifiedMap value is null, key: $key');
    return MapEntry<String, String>(key, value);
  }
  var v = value is String ? value : null; // skip conversion if it's already a string

  if (value is DateTime) {
    v ??= Util.dateTimeToString(value);
  }
  if (value is Duration) {
    v ??= Util.durationToString(value);
  }
  if (value is DateTime) {
    v ??= Util.dateTimeToString(value);
  }
  // todo: properly handle enum type
  // try {
  //   v ??= Util.enumToString(value);
  // } catch (e) {
  //   log.warning('$_TAG - error trying to cast $value as enum to String, $e');
  // }
  v ??= value.toString();

  if (value is String || value is DateTime || value is num || value is Duration) {
    // pretty sure we don't need to worry about these
  } else {
    // double check our conversion
    log.fine('_TAG - mapping $key:$value => $v, type: ${value.runtimeType}');
  }
  return MapEntry<String, String>(key, v);
};


/// generators
///
///
final Math.Random _random = new Math.Random();
Color generateRandomColor() => Color(0xFF000000 + _random.nextInt(0x00FFFFFF));

const GENERATE_ID_DIVIDER = '|';
/*String generateRandomId({String tag, DateTime time}) {
  String result = '';
  if (tag != null) {
    result += tag + GENERATE_ID_DIVIDER;
  }
  time ??= DateTime.now().toUtc();
  if (time != null) {
    result += Util.dateTimeToString(time) + GENERATE_ID_DIVIDER;
  }
  return result += Uuid().v4().toString();
}*/

String generateImagePlaceHolderUrl({int width = 200, int height = 80}) {
  return 'https://via.placeholder.com/${width}x${height}';
}

/// I actually use import 'package:logging/logging.dart';
class log{
  static fine(String message) => print("@@@@ fine: $message");
  static warning(String message) => print("@@@@ warning: $message");
  static error(String message) => print("@@@@ error: $message");
  static severe(String message) => print("@@@@ severe: $message");
}