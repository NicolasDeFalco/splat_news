import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:ui';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:splat_news/splaTwo/schedules/schedules.dart';

class SplatoonDeux {
  Map<String, dynamic> data = new Map();
  Map<String, dynamic> grizz = new Map();

  List<List<String>> mapChange =
      List.generate(12, (i) => List.generate(2, (j) => ''));

  List<List<String>> mapChangeGrizz =
      List.generate(2, (i) => List.generate(2, (j) => ''));

  int position = 0;

  Future<int> test() async {
    final prefs = await SharedPreferences.getInstance();
    final nextUpdate = prefs.getInt('nextUpdateS2') ?? 0;
    final double actualTime = DateTime.now().millisecondsSinceEpoch / 1000;
    if (actualTime > nextUpdate) {
      const String urlBattle = "https://splatoon2.ink/data/schedules.json";
      const String urlGrizz = "https://splatoon2.ink/data/coop-schedules.json";
      try {
        final responseBattle = await http.get(Uri.parse(urlBattle), headers: {
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8',
          'User-Agent': 'SplatNews/dev (nicolasdefalco.9@gmail.com)'
        });
        final responseGrizz = await http.get(Uri.parse(urlGrizz), headers: {
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8',
          'User-Agent': 'SplatNews/dev (nicolasdefalco.9@gmail.com)'
        });
        if (responseBattle.statusCode == 200 &&
            responseGrizz.statusCode == 200) {
          data = convert.jsonDecode(responseBattle.body);
          grizz = convert.jsonDecode(responseGrizz.body);

          for (int x = 0; x < 2; x++) {
            mapChangeGrizz[x][0] = DateTime.fromMillisecondsSinceEpoch(
                    grizz['details'][x]['start_time'] * 1000)
                .toString();
            mapChangeGrizz[x][1] = DateTime.fromMillisecondsSinceEpoch(
                    grizz['details'][x]['end_time'] * 1000)
                .toString();
          }

          for (int x = 0; x < 12; x++) {
            mapChange[x][0] = DateTime.fromMillisecondsSinceEpoch(
                    data['regular'][x]['start_time'] * 1000)
                .toString();
            mapChange[x][1] = DateTime.fromMillisecondsSinceEpoch(
                    data['regular'][x]['end_time'] * 1000)
                .toString();
          }
        }

        await prefs.setInt('nextUpdateS2', data['regular'][0]['end_time']);
        await prefs.setString('dataS2', convert.jsonEncode(data));
        await prefs.setString('grizzS2', convert.jsonEncode(grizz));
        return responseGrizz.statusCode;
      } catch (e) {
        debugPrint(e.toString());
        return 2000;
      }
    } else {
      var dataReco = prefs.getString('dataS2');
      var grizzReco = prefs.getString('grizzS2');

      data = convert.jsonDecode(dataReco.toString()) as Map<String, dynamic>;
      grizz = convert.jsonDecode(grizzReco.toString()) as Map<String, dynamic>;

      for (int x = 0; x < 2; x++) {
        mapChangeGrizz[x][0] = DateTime.fromMillisecondsSinceEpoch(
                grizz['details'][x]['start_time'] * 1000)
            .toString();
        mapChangeGrizz[x][1] = DateTime.fromMillisecondsSinceEpoch(
                grizz['details'][x]['end_time'] * 1000)
            .toString();
      }

      for (int x = 0; x < 12; x++) {
        mapChange[x][0] = DateTime.fromMillisecondsSinceEpoch(
                data['regular'][x]['start_time'] * 1000)
            .toString();
        mapChange[x][1] = DateTime.fromMillisecondsSinceEpoch(
                data['regular'][x]['end_time'] * 1000)
            .toString();
      }
      return 200;
    }
  }

  Container actualRoll(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Image.asset(
              'assets/logo/S2.png',
              width: 280,
              height: 150,
            ),
            Card(
                elevation: 10,
                color: Color.fromARGB(255, 14, 197, 24),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("         "),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage('assets/logo/Regular.png'),
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "Regular Battle",
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 30),
                          ),
                          Image(
                              image: AssetImage('assets/logo/Regular.png'),
                              width: 50,
                              height: 50)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo/S2/${data['regular'][0]['rule']['key']}.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "(${data['regular'][0]['rule']['name'].toString()})",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 20),
                          ),
                          Image.asset(
                            'assets/logo/S2/${data['regular'][0]['rule']['key']}.png',
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                      Text(timeConvert(mapChange[0][0].substring(11, 13)) +
                          " to " +
                          timeConvert(mapChange[0][1].substring(11, 13))),
                      Text("Actual rotation:"),
                      Card(
                        elevation: 10,
                        color: Colors.grey.shade800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(data['regular'][0]['stage_a']['name'],
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15)),
                                CachedNetworkImage(
                                  imageUrl:
                                      "https://splatoon2.ink/assets/splatnet/${data['regular'][0]['stage_a']['image']}",
                                  width: 180,
                                  height: 110,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(data['regular'][0]['stage_b']['name'],
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15)),
                                CachedNetworkImage(
                                  imageUrl:
                                      "https://splatoon2.ink/assets/splatnet/${data['regular'][0]['stage_b']['image']}",
                                  width: 180,
                                  height: 110,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchedulesTwo(
                                        background:
                                            Color.fromARGB(255, 23, 200, 26),
                                        data: data,
                                        mapChange: mapChange,
                                        type: 'Regular Battle',
                                        picLink: 'assets/logo/Regular.png',
                                        typeLink: 'regular',
                                      )));
                        },
                        child: Card(
                          color: Colors.grey.shade800,
                          child: Text('  See what\'s next  ',
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                )),
            Card(
                elevation: 10,
                color: Color.fromARGB(255, 226, 69, 17),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("         "),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage('assets/logo/Ranked.png'),
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "Ranked Battle",
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 30),
                          ),
                          Image(
                            image: AssetImage('assets/logo/Ranked.png'),
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo/S2/${data['gachi'][0]['rule']['key']}.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "(${data['gachi'][0]['rule']['name'].toString()})",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 20),
                          ),
                          Image.asset(
                            'assets/logo/S2/${data['gachi'][0]['rule']['key']}.png',
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                      Text(timeConvert(mapChange[0][0].substring(11, 13)) +
                          " to " +
                          timeConvert(mapChange[0][1].substring(11, 13))),
                      Text("Actual rotation:"),
                      Card(
                        elevation: 10,
                        color: Colors.grey.shade800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(data['gachi'][0]['stage_a']['name'],
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15)),
                                CachedNetworkImage(
                                  imageUrl:
                                      "https://splatoon2.ink/assets/splatnet/${data['gachi'][0]['stage_a']['image']}",
                                  width: 180,
                                  height: 110,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(data['gachi'][0]['stage_b']['name'],
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15)),
                                CachedNetworkImage(
                                  imageUrl:
                                      "https://splatoon2.ink/assets/splatnet/${data['gachi'][0]['stage_b']['image']}",
                                  width: 180,
                                  height: 110,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchedulesTwo(
                                        background:
                                            Color.fromARGB(255, 226, 69, 17),
                                        data: data,
                                        mapChange: mapChange,
                                        type: 'Ranked Battle',
                                        picLink: 'assets/logo/Ranked.png',
                                        typeLink: 'gachi',
                                      )));
                        },
                        child: Card(
                          color: Colors.grey.shade800,
                          child: Text('  See what\'s next  ',
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                )),
            Card(
                color: Color.fromARGB(255, 220, 43, 116),
                elevation: 10,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("         "),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage('assets/logo/League.png'),
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "League Battle",
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 30),
                          ),
                          Image(
                            image: AssetImage('assets/logo/League.png'),
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo/S2/${data['league'][0]['rule']['key']}.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "(${data['league'][0]['rule']['name'].toString()})",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 20),
                          ),
                          Image.asset(
                            'assets/logo/S2/${data['league'][0]['rule']['key']}.png',
                            width: 50,
                            height: 50,
                          ),
                        ],
                      ),
                      Text(timeConvert(mapChange[0][0].substring(11, 13)) +
                          " to " +
                          timeConvert(mapChange[0][1].substring(11, 13))),
                      Text("Actual rotation:"),
                      Card(
                        elevation: 10,
                        color: Colors.grey.shade800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(data['league'][0]['stage_a']['name'],
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15)),
                                CachedNetworkImage(
                                  imageUrl:
                                      "https://splatoon2.ink/assets/splatnet/${data['league'][0]['stage_a']['image']}",
                                  width: 180,
                                  height: 110,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                Text(data['league'][0]['stage_b']['name'],
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15)),
                                CachedNetworkImage(
                                  imageUrl:
                                      "https://splatoon2.ink/assets/splatnet/${data['league'][0]['stage_b']['image']}",
                                  width: 180,
                                  height: 110,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchedulesTwo(
                                        background:
                                            Color.fromARGB(255, 220, 43, 116),
                                        data: data,
                                        mapChange: mapChange,
                                        type: 'League Battle',
                                        picLink: 'assets/logo/League.png',
                                        typeLink: 'league',
                                      )));
                        },
                        child: Card(
                          color: Colors.grey.shade800,
                          child: Text('  See what\'s next  ',
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 20)),
                        ),
                      )
                    ],
                  ),
                )),
            Text(
              "Source: splatoon2.ink",
              style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
            ),
          ]),
        ));
  }

  Container grizzRoll(BuildContext context) {
    position = 0;
    String time =
        DateTime.now().millisecondsSinceEpoch.toString().substring(0, 10);
    //String time = "1678923800";
    if (int.parse(time) < grizz['details'][0]['start_time'] ||
        int.parse(time) > grizz['details'][0]['end_time']) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/logo/S2/SalmonRun.png',
                width: 280,
                height: 150,
              ),
              for (var salmon in grizz['details'])
                Card(
                    elevation: 10,
                    color: Color.fromARGB(255, 232, 78, 3),
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text('', style: TextStyle(fontSize: 5)),
                          if (position == 0)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Image(
                                    image:
                                        AssetImage('assets/logo/SalmonRun.png'),
                                    width: 50,
                                    height: 50),
                                Text(
                                  "Salmon run",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 35),
                                ),
                                Image(
                                    image:
                                        AssetImage('assets/logo/SalmonRun.png'),
                                    width: 50,
                                    height: 50)
                              ],
                            ),
                          if (position == 0)
                            Column(
                              children: [
                                Text(
                                  "Coming soon:",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                          if (position == 1)
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Future:",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 25),
                                ),
                              ],
                            ),
                          Text(
                            salmon['stage']['name'],
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 20),
                          ),
                          Text(
                              'From ' +
                                  dateFormatLoop(
                                      mapChangeGrizz[position][0], false) +
                                  ' to ' +
                                  dateFormatLoop(
                                      mapChangeGrizz[position][1], true),
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 14)),
                          CachedNetworkImage(
                            imageUrl:
                                "https://splatoon2.ink/assets/splatnet${salmon['stage']['image']}",
                            width: 360,
                            height: 210,
                          ),
                          Card(
                            elevation: 10,
                            color: Colors.grey.shade800,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Supplied weapons:",
                                  style: TextStyle(
                                      color: Colors.grey.shade200,
                                      fontSize: 20),
                                ),
                                for (var elements in salmon['weapons'])
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      if (elements['id'] != '-1')
                                        Text(" ${elements['weapon']['name']}",
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 20)),
                                      if (elements['id'] == '-1')
                                        Text(
                                            " ${elements['coop_special_weapon']['name']}",
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 20)),
                                      Text("                          "),
                                      if (elements['id'] != '-1')
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://splatoon2.ink/assets/splatnet${elements['weapon']['image']}",
                                          width: 90,
                                          height: 90,
                                        ),
                                      if (elements['id'] == '-1')
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://splatoon2.ink/assets/splatnet${elements['coop_special_weapon']['image']}",
                                          width: 90,
                                          height: 90,
                                        ),
                                    ],
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )),
              Text(
                "Source: splatoon2.ink",
                style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/logo/S2/SalmonRun.png',
              width: 280,
              height: 150,
            ),
            for (var salmon in grizz['details'])
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
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Image(
                                  image:
                                      AssetImage('assets/logo/SalmonRun.png'),
                                  width: 50,
                                  height: 50),
                              Text(
                                "Salmon run",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 35),
                              ),
                              Image(
                                  image:
                                      AssetImage('assets/logo/SalmonRun.png'),
                                  width: 50,
                                  height: 50)
                            ],
                          ),
                        if (position == 0)
                          Column(
                            children: [
                              Text(
                                "Actual map:",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 25),
                              ),
                            ],
                          ),
                        if (position == 1)
                          Column(
                            children: [
                              Text(
                                "Next map:",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 25),
                              ),
                            ],
                          ),
                        Text(
                          salmon['stage']['name'],
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 20),
                        ),
                        Text(
                            'From ' +
                                dateFormatLoop(
                                    mapChangeGrizz[position][0], false) +
                                ' to ' +
                                dateFormatLoop(
                                    mapChangeGrizz[position][1], true),
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 14)),
                        CachedNetworkImage(
                          imageUrl:
                              "https://splatoon2.ink/assets/splatnet${salmon['stage']['image']}",
                          width: 360,
                          height: 210,
                        ),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "Supplied weapons:",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 20),
                              ),
                              for (var elements in salmon['weapons'])
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    if (elements['id'] != '-1')
                                      if (elements['id'] == '-2')
                                        Text(
                                            " ${elements['coop_special_weapon']['name']}",
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 20))
                                      else
                                        Text(" ${elements['weapon']['name']}",
                                            style: TextStyle(
                                                color: Colors.grey.shade400,
                                                fontSize: 20)),
                                    if (elements['id'] == '-1')
                                      Text(
                                          " ${elements['coop_special_weapon']['name']}",
                                          style: TextStyle(
                                              color: Colors.grey.shade400,
                                              fontSize: 20)),
                                    Text("                          "),
                                    if (elements['id'] != '-1')
                                      if (elements['id'] == '-2')
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://splatoon2.ink/assets/splatnet${elements['coop_special_weapon']['image']}",
                                          width: 90,
                                          height: 90,
                                        )
                                      else
                                        CachedNetworkImage(
                                          imageUrl:
                                              "https://splatoon2.ink/assets/splatnet${elements['weapon']['image']}",
                                          width: 90,
                                          height: 90,
                                        ),
                                    if (elements['id'] == '-1')
                                      CachedNetworkImage(
                                        imageUrl:
                                            "https://splatoon2.ink/assets/splatnet${elements['coop_special_weapon']['image']}",
                                        width: 90,
                                        height: 90,
                                      ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )),
            Text(
              "Source: splatoon2.ink",
              style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  String dateFormatLoop(String value, bool loop) {
    String date = value.substring(0, 10).replaceAll(RegExp('-'), '/');
    if (loop) {
      position++;
    }
    return '${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}' +
        ' at ' +
        timeConvert(value.substring(11, 13));
  }

  String timeConvert(String value) {
    int time = int.parse(value) % 12;
    String tz = 'AM';

    if (time == 0) {
      time = 12;
    }

    if (int.parse(value) >= 12) {
      tz = 'PM';
    }

    return time.toString() + ' ' + tz;
  }
}
