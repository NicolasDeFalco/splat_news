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

String occurence(int index) {
  switch (index) {
    case 0:
      return 'Actual';
    case 1:
      return 'Next';
    default:
      return 'Future';
  }
}
