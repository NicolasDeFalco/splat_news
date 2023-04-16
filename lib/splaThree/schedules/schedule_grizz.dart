import 'package:flutter/material.dart';

class SchedulesGrizz extends StatefulWidget {
  Map<String, dynamic> content;
  List<List<String>> change;

  SchedulesGrizz({super.key, required this.content, required this.change});
  State<SchedulesGrizz> createState() => SchedulesGrizzState(content, change);
}

class SchedulesGrizzState extends State<SchedulesGrizz> {
  Map<String, dynamic> content;
  List<List<String>> change;
  int position = 0;

  SchedulesGrizzState(this.content, this.change);

  String dateFormat(String value, bool loop) {
    String date = value.substring(0, 10).replaceAll(RegExp('-'), '/');
    return date + ' at ' + timeConvertLoop(value.substring(11, 13), loop);
  }

  String timeConvertLoop(String value, bool loop) {
    int time = int.parse(value) % 12;
    String tz = 'AM';

    if (time == 0) {
      time = 12;
    }

    if (int.parse(value) >= 12) {
      tz = 'PM';
    }

    if (loop) {
      position++;
    }

    return time.toString() + ' ' + tz;
  }

  @override
  Widget build(BuildContext context) {
    position = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Splatoon 3 - Salmon Run"),
        backgroundColor: Colors.grey.shade900,
        /*flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Color.fromARGB(255, 229, 255, 0), Color.fromARGB(255, 100, 48, 254)]),
            ),
          ),*/
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var salmon in content['nodes'])
                if (position <= 5)
                  Card(
                      elevation: 10,
                      color: Color.fromARGB(255, 225, 65, 10),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('', style: TextStyle(fontSize: 5)),
                            if (position == 0)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/logo/SalmonRun.png'),
                                      width: 50,
                                      height: 50),
                                  Text(
                                    "Actual",
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 30),
                                  ),
                                  Image(
                                      image: AssetImage(
                                          'assets/logo/SalmonRun.png'),
                                      width: 50,
                                      height: 50)
                                ],
                              ),
                            if (position == 1)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Image(
                                      image: AssetImage(
                                          'assets/logo/SalmonRun.png'),
                                      width: 50,
                                      height: 50),
                                  Text(
                                    "Future",
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 30),
                                  ),
                                  Image(
                                      image: AssetImage(
                                          'assets/logo/SalmonRun.png'),
                                      width: 50,
                                      height: 50)
                                ],
                              ),
                            Text(
                              salmon['setting']['coopStage']['name'],
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 22),
                            ),
                            Text(
                              'From ' +
                                  dateFormat(change[position][0], false) +
                                  ' to ' +
                                  dateFormat(change[position][1], true),
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 14),
                            ),
                            Image.network(
                              salmon['setting']['coopStage']['image']['url'],
                              width: 360,
                              height: 210,
                            ),
                            Card(
                              elevation: 10,
                              color: Colors.grey.shade800,
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                    "Supplied weapons:",
                                    style: TextStyle(
                                        color: Colors.grey.shade400,
                                        fontSize: 20),
                                  ),
                                  for (var elements in salmon['setting']
                                      ['weapons'])
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(" ${elements['name']}",
                                            style: TextStyle(
                                                color: Colors.grey.shade200,
                                                fontSize: 20)),
                                        Text("                   "),
                                        Image.network(
                                          elements['image']['url'],
                                          width: 90,
                                          height: 90,
                                        ),
                                      ],
                                    )
                                ],
                              ),
                            )
                          ],
                        ),
                      )),
              Text(
                "Source: splatoon3.ink",
                style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
