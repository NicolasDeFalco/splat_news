import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SchedulesTwo extends StatefulWidget {
  final Color background;
  final Map<String, dynamic> data;
  final List<List<String>> mapChange;
  final String picLink;
  final String type;
  final String typeLink;

  const SchedulesTwo(
      {super.key,
      required this.background,
      required this.data,
      required this.mapChange,
      required this.picLink,
      required this.type,
      required this.typeLink});
  @override
  State<SchedulesTwo> createState() =>
      SchedulesStateTwo(background, data, mapChange, picLink, type, typeLink);
}

class SchedulesStateTwo extends State<SchedulesTwo> {
  Color background;
  Map<String, dynamic> data;
  List<List<String>> mapChange;
  String picLink;
  String type;
  String typeLink;

  int position = 0;

  SchedulesStateTwo(this.background, this.data, this.mapChange, this.picLink,
      this.type, this.typeLink);

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
          title: Text("Splatoon 2 - $type"),
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
              color: Colors.grey.shade900,
            ),
            child: SingleChildScrollView(
                child: Column(children: [
              for (var battle in data[typeLink])
                Card(
                    color: background,
                    elevation: 10,
                    child: Container(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                          Text("         "),
                          if (position == 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                  image: AssetImage(picLink),
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  "Actual",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 30),
                                ),
                                Image(
                                  image: AssetImage(picLink),
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          if (position == 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                  image: AssetImage(picLink),
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  "Next",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 30),
                                ),
                                Image(
                                  image: AssetImage(picLink),
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          if (position == 2)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Image(
                                  image: AssetImage(picLink),
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  "Future",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 30),
                                ),
                                Image(
                                  image: AssetImage(picLink),
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo/S2/${battle['rule']['key']}.png',
                                width: 50,
                                height: 50,
                              ),
                              Text(
                                "(${battle['rule']['name'].toString()})",
                                style: TextStyle(
                                    color: Colors.grey.shade800, fontSize: 20),
                              ),
                              Image.asset(
                                'assets/logo/S2/${battle['rule']['key']}.png',
                                width: 50,
                                height: 50,
                              ),
                            ],
                          ),
                          Text(timeConvertLoop(
                                  mapChange[position][0].substring(11, 13),
                                  false) +
                              " to " +
                              timeConvertLoop(
                                  mapChange[position][1].substring(11, 13),
                                  true)),
                          Text("Actual rotation:"),
                          Card(
                            elevation: 10,
                            color: Colors.grey.shade800,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(battle['stage_a']['name'],
                                        style: TextStyle(
                                            color: Colors.grey.shade200,
                                            fontSize: 15)),
                                    CachedNetworkImage(
                                      imageUrl:
                                          "https://splatoon2.ink/assets/splatnet/${battle['stage_a']['image']}",
                                      width: 180,
                                      height: 110,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(battle['stage_b']['name'],
                                        style: TextStyle(
                                            color: Colors.grey.shade200,
                                            fontSize: 15)),
                                    CachedNetworkImage(
                                      imageUrl:
                                          "https://splatoon2.ink/assets/splatnet/${battle['stage_b']['image']}",
                                      width: 180,
                                      height: 110,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ]))),
              Text(
                "Source: splatoon2.ink",
                style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
              ),
            ]))));
  }
}
