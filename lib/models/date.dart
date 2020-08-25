import 'package:date_time_format/date_time_format.dart';

String readTimestamp(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var time = '';
  print(DateTimeFormat.format(date, format: 'Y-m-d H:i:s'));

  return time;
}

String getNowDate() {
  var date = DateTime.now();
  return DateTimeFormat.format(date, format: 'Y-m-d H:i');
}

String getDay(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return DateTimeFormat.format(date, format: 'l');
}

String getHourAndMinutes(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return DateTimeFormat.format(date, format: 'H:i');
}

String getDate(int timestamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  return DateTimeFormat.format(date, format: 'Y-m-d');
}

int getHour(int timeStamp) {
  var date = new DateTime.fromMillisecondsSinceEpoch(timeStamp * 1000);
  return int.parse(DateTimeFormat.format(date, format: 'H'));
}
