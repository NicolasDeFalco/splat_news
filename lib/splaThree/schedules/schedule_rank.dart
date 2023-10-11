import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SchedulesRank extends StatefulWidget {
  final String type;
  final Map<String, dynamic> content;
  final List<List<String>> mapChange;
  final int rankType;

  const SchedulesRank(
      {super.key,
      required this.content,
      required this.mapChange,
      required this.type,
      required this.rankType});
  @override
  State<SchedulesRank> createState() =>
      SchedulesRankState(type, content, mapChange, rankType);
}

class SchedulesRankState extends State<SchedulesRank> {
  String type;
  Map<String, dynamic> content;
  List<List<String>> mapChange;
  int rankType;
  int position = 0;

  SchedulesRankState(this.type, this.content, this.mapChange, this.rankType);

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
          title: Text("Splatoon 3 - $type"),
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
            child: Column(
              children: [
                for (var battle in content['nodes'])
                  if (position <= 11 && battle['festMatchSetting'] == null)
                    Card(
                        elevation: 10,
                        color: Color.fromARGB(255, 224, 67, 18),
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text("         "),
                              if (position == 0)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image(
                                      image:
                                          AssetImage('assets/logo/Ranked.png'),
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
                                      image:
                                          AssetImage('assets/logo/Ranked.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ],
                                ),
                              if (position == 1)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image(
                                      image:
                                          AssetImage('assets/logo/Ranked.png'),
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
                                      image:
                                          AssetImage('assets/logo/Ranked.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                  ],
                                ),
                              if (position == 2)
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Image(
                                      image:
                                          AssetImage('assets/logo/Ranked.png'),
                                      width: 50,
                                      height: 50,
                                    ),
                                    Text(
                                      'Future',
                                      style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontSize: 30),
                                    ),
                                    Image(
                                        image: AssetImage(
                                            'assets/logo/Ranked.png'),
                                        width: 50,
                                        height: 50)
                                  ],
                                ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'assets/logo/S3/${battle['bankaraMatchSettings'][rankType]['vsRule']['rule']}.png',
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text(
                                    "(${battle['bankaraMatchSettings'][rankType]['vsRule']['name'].toString()})",
                                    style: TextStyle(
                                        color: Colors.grey.shade800,
                                        fontSize: 20),
                                  ),
                                  Image.asset(
                                    'assets/logo/S3/${battle['bankaraMatchSettings'][rankType]['vsRule']['rule']}.png',
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
                              Text("Map:",
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 16)),
                              Card(
                                elevation: 10,
                                color: Colors.grey.shade800,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    for (var elements
                                        in battle['bankaraMatchSettings']
                                            [rankType]['vsStages'])
                                      Column(
                                        children: [
                                          Text(elements['name'],
                                              style: TextStyle(
                                                  color: Colors.grey.shade200,
                                                  fontSize: 15)),
                                          CachedNetworkImage(
                                            imageUrl: elements['image']['url'],
                                            width: 180,
                                            height: 110,
                                          ),
                                        ],
                                      )
                                  ],
                                ),
                              ),
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
        ));
  }
}
