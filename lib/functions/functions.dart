import 'package:flutter/material.dart';

String timeConvert(String value) {
  int time = int.parse(value) % 12;
  String tz = 'AM';

  if (time == 0) {
    time = 12;
  }

  if (int.parse(value) >= 12) {
    tz = 'PM';
  }

  return '$time $tz';
}

String dateFormat(String value) {
  String date = value.substring(0, 10).replaceAll(RegExp('-'), '/');
  return '${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}' +
      ' at ' +
      timeConvert(value.substring(11, 13));
}

String occurence(int index, bool grizz) {
  switch (index) {
    case 0:
      return 'Actual';
    case 1:
      if (!grizz) return 'Next';
      return 'Future';
    default:
      return 'Future';
  }
}

Widget disclaimer() {
  return Card(
      color: Colors.black,
      child: Column(
        children: [
          Text(
            "Splat News is not affiliated with Nintendo.",
            style: TextStyle(color: Colors.grey.shade200, fontSize: 14),
          ),
          Text(
            "All product names, logos, and brands are property of their",
            style: TextStyle(color: Colors.grey.shade200, fontSize: 14),
          ),
          Text(
            "respective owners.",
            style: TextStyle(color: Colors.grey.shade200, fontSize: 14),
          ),
        ],
      ));
}
