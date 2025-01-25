import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:splat_news/functions/functions.dart';

class Schedules extends StatefulWidget {
  final String type;
  final Color background;
  final Map<String, dynamic> content;
  final String picLink;
  final List<List<String>> mapChange;
  final String typeCode;

  const Schedules({
    super.key,
    required this.type,
    required this.background,
    required this.content,
    required this.picLink,
    required this.mapChange,
    required this.typeCode,
  });

  @override
  State<Schedules> createState() =>
      SchedulesState(type, background, content, picLink, mapChange, typeCode);
}

class SchedulesState extends State<Schedules> {
  String type;
  String typeCode;
  Color background;
  Map<String, dynamic> content;
  String picLink;
  List<List<String>> mapChange;
  int position = 0;

  SchedulesState(this.type, this.background, this.content, this.picLink,
      this.mapChange, this.typeCode);

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
        title: Text("Splatoon 3 - $type",
            style: TextStyle(color: Colors.grey.shade200, fontSize: 20)),
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
                if (position <= 11 && battle['festMatchSettings'] == null)
                  Card(
                      elevation: 10,
                      color: background,
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text(""),
                            if (position < 3)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Image(
                                    image: AssetImage(picLink),
                                    width: 50,
                                    height: 50,
                                  ),
                                  Text(
                                    occurence(position, false),
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 30),
                                  ),
                                  Image(
                                      image: AssetImage(picLink),
                                      width: 50,
                                      height: 50)
                                ],
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/logo/S3/${battle[typeCode]['vsRule']['rule']}.png',
                                  width: 50,
                                  height: 50,
                                ),
                                Text(
                                  "${battle[typeCode]['vsRule']['name']}",
                                  style: TextStyle(
                                      color: Colors.grey.shade800,
                                      fontSize: 22),
                                ),
                                Image.asset(
                                  'assets/logo/S3/${battle[typeCode]['vsRule']['rule']}.png',
                                  width: 50,
                                  height: 50,
                                ),
                              ],
                            ),
                            Text("${timeConvertLoop(
                              mapChange[position][0].substring(11, 13),
                              false,
                            )} to ${timeConvertLoop(mapChange[position][1].substring(11, 13), true)}"),
                            Text("Map:",
                                style: TextStyle(
                                    color: Colors.grey.shade800, fontSize: 16)),
                            Card(
                              elevation: 10,
                              color: Colors.grey.shade800,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  for (var elements in battle[typeCode]
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
}
