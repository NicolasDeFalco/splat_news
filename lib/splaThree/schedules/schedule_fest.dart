import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:splat_news/functions/functions.dart';

class SchedulesFest extends StatefulWidget {
  final Map<String, dynamic> content;
  final String picLink;
  final List<List<String>> mapChange;
  final int index;

  const SchedulesFest(
      {super.key,
      required this.content,
      required this.picLink,
      required this.mapChange,
      required this.index});

  @override
  State<SchedulesFest> createState() =>
      SchedulesFestState(content, picLink, mapChange, index);
}

class SchedulesFestState extends State<SchedulesFest> {
  Map<String, dynamic> content;
  String picLink;
  List<List<String>> mapChange;
  int position = 0;
  int index;

  SchedulesFestState(this.content, this.picLink, this.mapChange, this.index);

  String timeConvertLoop(
    String value,
    bool loop,
  ) {
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

    return '$time $tz';
  }

  @override
  Widget build(BuildContext context) {
    position = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text("Splatoon 3 - Fest Battle ${type(index)}"),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade900,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              for (var battle in content['nodes'])
                if (battle['festMatchSettings'] != null && position < 12)
                  Card(
                      elevation: 10,
                      color: Colors.black,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text('', style: TextStyle(fontSize: 5)),
                            if (position < 3)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const Image(
                                    image: AssetImage(
                                        'assets/logo/S3/Tricolor.png'),
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text(
                                    occurence(position, false),
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 30),
                                  ),
                                  const Image(
                                      image: AssetImage(
                                          'assets/logo/S3/Tricolor.png'),
                                      width: 50,
                                      height: 50)
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/logo/S3/${battle['festMatchSettings'][index]['vsRule']['rule']}.png',
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  battle['festMatchSettings'][index]['vsRule']
                                      ['name'],
                                  style: TextStyle(
                                      color: Colors.grey.shade400,
                                      fontSize: 20),
                                ),
                                Image.asset(
                                  'assets/logo/S3/${battle['festMatchSettings'][index]['vsRule']['rule']}.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                            /*Text(
                        "(${turf['vsRule']['name'].toString()})",
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 20),
                      ),*/

                            Text(
                                "${timeConvertLoop(mapChange[position][0].substring(11, 13), false)} to ${timeConvertLoop(mapChange[position][1].substring(11, 13), true)}",
                                style: TextStyle(color: Colors.grey.shade200)),
                            Text("Map:",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 16)),
                            Card(
                              elevation: 10,
                              color: Colors.grey.shade800,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (var elements
                                      in battle['festMatchSettings'][index]
                                          ['vsStages'])
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
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
              disclaimer()
            ],
          ),
        ),
      ),
    );
  }

  String type(int index) {
    if (index == 1) return "(Open)";
    return "(Pro)";
  }
}
