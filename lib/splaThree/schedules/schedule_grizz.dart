import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:splat_news/functions/functions.dart';

class SchedulesGrizz extends StatefulWidget {
  final Map<String, dynamic> content;
  final List<List<String>> change;
  final bool bigrun;

  const SchedulesGrizz(
      {super.key,
      required this.content,
      required this.change,
      required this.bigrun});
  State<SchedulesGrizz> createState() =>
      SchedulesGrizzState(content, change, bigrun);
}

class SchedulesGrizzState extends State<SchedulesGrizz> {
  Map<String, dynamic> content;
  List<List<String>> change;
  bool bigrun;
  int position = 0;

  SchedulesGrizzState(this.content, this.change, this.bigrun);

  String dateFormat(String value, bool loop) {
    String date = value.substring(0, 10).replaceAll(RegExp('-'), '/');
    return '${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}' +
        ' at ' +
        timeConvertLoop(value.substring(11, 13), loop);
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

    return '$time $tz';
  }

  @override
  Widget build(BuildContext context) {
    position = 0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Splatoon 3 - Salmon Run"),
        backgroundColor: Colors.grey.shade900,
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
                      color: const Color.fromARGB(255, 201, 77, 15),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Text('', style: TextStyle(fontSize: 5)),
                            if (position < 2)
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  const Image(
                                      image: AssetImage(
                                          'assets/logo/SalmonRun.png'),
                                      width: 50,
                                      height: 50),
                                  if (bigrun && position == 0)
                                    Text(
                                      "Coming soon",
                                      style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontSize: 30),
                                    )
                                  else
                                    Text(
                                      occurence(position, true),
                                      style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontSize: 30),
                                    ),
                                  const Image(
                                      image: AssetImage(
                                          'assets/logo/SalmonRun.png'),
                                      width: 50,
                                      height: 50)
                                ],
                              ),
                            Text(
                              'From ${dateFormat(change[position][0], false)} to ${dateFormat(change[position][1], true)}',
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 14),
                            ),
                            Card(
                                elevation: 10,
                                color: Colors.grey.shade800,
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      salmon['setting']['coopStage']['name'],
                                      style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontSize: 22),
                                    ),
                                    CachedNetworkImage(
                                      imageUrl: salmon['setting']['coopStage']
                                          ['image']['url'],
                                    ),
                                  ],
                                )),
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
                                        const Text("                   "),
                                        CachedNetworkImage(
                                          imageUrl: elements['image']['url'],
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
              disclaimer()
            ],
          ),
        ),
      ),
    );
  }
}
