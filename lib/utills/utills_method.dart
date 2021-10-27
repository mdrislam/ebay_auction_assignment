import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class UtillsMethod{
 static String getEndDate(String date) {
    var returnString = '';
    final DateTime now = DateTime.now();
    final DateFormat formatter = DateFormat('yyyy-MM-dd kk:mm aa');
    final today = formatter.format(now);
    final fromDate = formatter.parse(date);
    final toDate = formatter.parse(today);

    var days = fromDate.difference(toDate).inDays;
    var hour = fromDate.difference(toDate).inHours % 24;
    var minute = fromDate.difference(toDate).inMinutes % 60;

    if (now.day == fromDate.day) {
      if (now.hour >= fromDate.hour && now.minute >= fromDate.minute) {
        print('Complete Over');
        returnString = 'Complete';
      } else {
        var run = " Hour: $hour Minute: $minute";
        print(run);
        returnString =run;
      }
    } else if (now.day > fromDate.day) {
      print('Complete Day is');
      returnString = 'Complete';
    } else {
      var str = "Days: $days Hour: $hour Minute: $minute";
      print('Running: $str');
      returnString = str;
    }

    return returnString;
  }

  static void showToast(Color color,msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}