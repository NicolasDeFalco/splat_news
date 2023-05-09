import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:splat_news/splaThree/schedules/schedule_grizz.dart';
import 'package:splat_news/splaThree/schedules/schedule_rank.dart';
import 'package:splat_news/splaThree/schedules/schedules.dart';

class SplatoonTrois {
  // The data we receive from the API
  Map<String, dynamic> data = new Map();
  Map<String, dynamic> dataFest = new Map();

  // Dedicated to the turf war match
  Map<String, dynamic> turf = new Map();
  Map<String, dynamic> turfMult = new Map();

  // Dedicated to the ranked match
  Map<String, dynamic> series = new Map();
  Map<String, dynamic> open = new Map();
  Map<String, dynamic> rankMult = new Map();

  // Dedicated to the X match
  Map<String, dynamic> xrank = new Map();
  Map<String, dynamic> xrankMult = new Map();
  //Map<String, dynamic> nextXrank = new Map();

  // Dedicated to Salmon Run
  Map<String, dynamic> grizz = new Map();
  Map<String, dynamic> grizzEggstra = new Map();
  Map<String, dynamic> grizzMult = new Map();

  // Dedicated to the splatfest matches
  Map<String, dynamic> fest = new Map();
  Map<String, dynamic> festMult = new Map();
  Map<String, dynamic> festSettings = new Map();

  // True if a splatfest is in progress
  bool festCheck = false;

  // True if an eggstra work event is in progress
  bool eggstraCheck = false;

  // True if a fest is scheduled
  bool festScheduled = false;

  // Timestamp of each map
  List<List<String>> mapChange =
      List.generate(12, (i) => List.generate(2, (j) => ''));

  List<List<String>> grizzChange =
      List.generate(5, (i) => List.generate(2, (j) => ''));

  List<List<String>> grizzEggstraChange =
      List.generate(1, (i) => List.generate(2, (j) => ''));

  Future<int> test() async {
    String url = "https://splatoon3.ink/data/schedules.json";
    String urlFest = "https://splatoon3.ink/data/festivals.json";

    // We use a try in case there is no internet connectivity
    try {
      var response = await http.get(Uri.parse(url));
      var responseFest = await http.get(Uri.parse(urlFest));
      if (response.statusCode == 200) {
        data = convert.jsonDecode(response.body);
        dataFest = convert.jsonDecode(responseFest.body);
      }
      // Check if there is no splatfest
      if (data['data']['currentFest'] == null ||
          data['data']['currentFest']['state'] == 'SCHEDULED') {
        //No splatfest
        for (int x = 0; x < 12; x++) {
          mapChange[x][0] = DateTime.parse(
                  data['data']['regularSchedules']['nodes'][x]['startTime'])
              .toLocal()
              .toString();
          mapChange[x][1] = DateTime.parse(
                  data['data']['regularSchedules']['nodes'][x]['endTime'])
              .toLocal()
              .toString();
        }

        // FIXME: This part need optimizations. We should only use the 'mult'.
        turf =
            data['data']['regularSchedules']['nodes'][0]['regularMatchSetting'];
        turfMult = data['data']['regularSchedules'];
        series = data['data']['bankaraSchedules']['nodes'][0]
            ['bankaraMatchSettings'][0];
        open = data['data']['bankaraSchedules']['nodes'][0]
            ['bankaraMatchSettings'][1];
        rankMult = data['data']['bankaraSchedules'];
        xrank = data['data']['xSchedules']['nodes'][0]['xMatchSetting'];
        xrankMult = data['data']['xSchedules'];

        // Is true when a fest is scheduled
        if (data['data']['currentFest'] != null) {
          if (data['data']['currentFest']['state'] == 'SCHEDULED') {
            festScheduled = true;
          }
        }
      } else {
        //There is a splatfest
        festCheck = true;
        for (int x = 0; x < 12; x++) {
          if (data['data']['festSchedules']['nodes'][x]['festMatchSetting'] !=
              null) {
            mapChange[x][0] = DateTime.parse(
                    data['data']['festSchedules']['nodes'][x]['startTime'])
                .toLocal()
                .toString();
            mapChange[x][1] = DateTime.parse(
                    data['data']['festSchedules']['nodes'][x]['endTime'])
                .toLocal()
                .toString();
          }
        }

        fest = data['data']['festSchedules']['nodes'][0]['festMatchSetting'];
        festMult = data['data']['festSchedules'];
      }
      grizz =
          data['data']['coopGroupingSchedule']['regularSchedules']['nodes'][0];
      grizzMult = data['data']['coopGroupingSchedule']['regularSchedules'];
      int x = 0;
      for (var changes in data['data']['coopGroupingSchedule']
          ['regularSchedules']['nodes']) {
        grizzChange[x][0] =
            DateTime.parse(changes['startTime']).toLocal().toString();
        grizzChange[x][1] =
            DateTime.parse(changes['endTime']).toLocal().toString();
        x++;
      }
      // We'll check if a Eggstra work event is in progress
      if (data['data']['coopGroupingSchedule']['teamContestSchedules']['nodes']
              .toString() !=
          '[]') {
        grizzEggstra = data['data']['coopGroupingSchedule']
            ['teamContestSchedules']['nodes'][0];
        eggstraCheck = true;
        grizzEggstraChange[0][0] = DateTime.parse(data['data']
                    ['coopGroupingSchedule']['teamContestSchedules']['nodes'][0]
                ['startTime'])
            .toLocal()
            .toString();
        grizzEggstraChange[0][1] = DateTime.parse(data['data']
                    ['coopGroupingSchedule']['teamContestSchedules']['nodes'][0]
                ['endTime'])
            .toLocal()
            .toString();
      }

      return response.statusCode;
    } catch (e) {
      debugPrint(e.toString());
      return 2000;
    }
  }

  /*String colorResult(double valeur) {
    double colorCalc = valeur * 255;
    double color = 0;
    if (colorCalc == 255) {
      color = 255;
    } else {
      color = double.parse(colorCalc.toString());
    }
    debugPrint(color.toString());
    return color.toString();
  }*/

  Container actualRoll(BuildContext context) {
    if (data['data']['currentFest'] == null ||
        data['data']['currentFest']['state'] == 'SCHEDULED') {
      return Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
          ),
          child: SingleChildScrollView(
            child: Column(children: [
              Image.asset(
                'assets/logo/S3.png',
                width: 280,
                height: 150,
              ),
              if (festScheduled)
                Text(
                  "Slat fest inkoming!",
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 30),
                ),
              if (festScheduled)
                Card(
                  elevation: 10,
                  color: Colors.black,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        dataFest['US']['data']['festRecords']['nodes'][0]
                            ['title'],
                        style: TextStyle(
                            color: Colors.grey.shade200, fontSize: 25),
                      ),
                      Container(
                        child: Image.network(dataFest['US']['data']
                            ['festRecords']['nodes'][0]['image']['url']),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          for (var team in dataFest['US']['data']['festRecords']
                              ['nodes'][0]['teams'])
                            Text(team['teamName'],
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 25))
                        ],
                      )
                    ],
                  ),
                ),
              Card(
                  elevation: 10,
                  color: Color.fromARGB(255, 23, 200, 26),
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
                              'assets/logo/S3/${turf['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "(${turf['vsRule']['name'].toString()})",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 20),
                            ),
                            Image.asset(
                              'assets/logo/S3/${turf['vsRule']['rule']}.png',
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

                        Text(timeConvert(mapChange[0][0].substring(11, 13)) +
                            " to " +
                            timeConvert(mapChange[0][1].substring(11, 13))),
                        Text("Actual rotation:",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 16)),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var elements in turf['vsStages'])
                                Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(elements['name'],
                                        style: TextStyle(
                                            color: Colors.grey.shade200,
                                            fontSize: 15)),
                                    Image.network(
                                      elements['image']['url'],
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
                                    builder: (context) => Schedules(
                                          background:
                                              Color.fromARGB(255, 23, 200, 26),
                                          content: turfMult,
                                          mapChange: mapChange,
                                          type: 'Regular Battle',
                                          picLink: 'assets/logo/Regular.png',
                                          typeCode: 'regularMatchSetting',
                                          fest: false,
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
                  color: Color.fromARGB(255, 224, 67, 18),
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
                              "Anarchy Battle Series",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 30),
                            ),
                            Image(
                                image: AssetImage('assets/logo/Ranked.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/S3/${series['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "(${series['vsRule']['name'].toString()})",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 20),
                            ),
                            Image.asset(
                              'assets/logo/S3/${series['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        Text(timeConvert(mapChange[0][0].substring(11, 13)) +
                            " to " +
                            timeConvert(mapChange[0][1].substring(11, 13))),
                        Text("Actual rotation:",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 16)),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var elements in series['vsStages'])
                                Column(
                                  children: [
                                    Text(elements['name'],
                                        style: TextStyle(
                                            color: Colors.grey.shade200,
                                            fontSize: 15)),
                                    Image.network(
                                      elements['image']['url'],
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
                                    builder: (context) => SchedulesRank(
                                          content: rankMult,
                                          mapChange: mapChange,
                                          rankType: 0,
                                          type: 'Anarchy Battle Series',
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
                  color: Color.fromARGB(255, 224, 67, 18),
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
                              image: AssetImage('assets/logo/Ranked.png'),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "Anarchy Battle Open",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 30),
                            ),
                            Image(
                                image: AssetImage('assets/logo/Ranked.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/S3/${open['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "(${open['vsRule']['name'].toString()})",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 20),
                            ),
                            Image.asset(
                              'assets/logo/S3/${open['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        Text("Actual rotation:",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 16)),
                        Text(timeConvert(mapChange[0][0].substring(11, 13)) +
                            " to " +
                            timeConvert(mapChange[0][1].substring(11, 13))),
                        Text("Actual rotation:",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 16)),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var elements in open['vsStages'])
                                Column(
                                  children: [
                                    Text(elements['name'],
                                        style: TextStyle(
                                            color: Colors.grey.shade200,
                                            fontSize: 15)),
                                    Image.network(
                                      elements['image']['url'],
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
                                    builder: (context) => SchedulesRank(
                                          content: rankMult,
                                          mapChange: mapChange,
                                          rankType: 1,
                                          type: 'Anarchy Battle Open',
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
                  color: Color.fromARGB(255, 14, 199, 144),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("         "),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image(
                              image: AssetImage('assets/logo/XBattle.png'),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "X Battle",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 30),
                            ),
                            Image(
                                image: AssetImage('assets/logo/XBattle.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/S3/${xrank['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "(${xrank['vsRule']['name'].toString()})",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 20),
                            ),
                            Image.asset(
                              'assets/logo/S3/${xrank['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        Text(timeConvert(mapChange[0][0].substring(11, 13)) +
                            " to " +
                            timeConvert(mapChange[0][1].substring(11, 13))),
                        Text("Actual rotation:",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 16)),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var elements in xrank['vsStages'])
                                Column(
                                  children: [
                                    Text(elements['name'],
                                        style: TextStyle(
                                            color: Colors.grey.shade200,
                                            fontSize: 15)),
                                    Image.network(
                                      elements['image']['url'],
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
                                    builder: (context) => Schedules(
                                          background:
                                              Color.fromARGB(255, 14, 199, 144),
                                          content: xrankMult,
                                          mapChange: mapChange,
                                          type: 'X Battle',
                                          picLink: 'assets/logo/XBattle.png',
                                          typeCode: 'xMatchSetting',
                                          fest: false,
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
                "Source: splatoon3.ink",
                style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
              ),
            ]),
          ));
    }
    return Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade800,
        ),
        child: SingleChildScrollView(
          child: Column(children: [
            Image.asset(
              'assets/logo/S3.png',
              width: 280,
              height: 150,
            ),
            Text(
              "SPLAT FEST !",
              style: TextStyle(color: Colors.grey.shade200, fontSize: 30),
            ),
            Card(
              elevation: 10,
              color: Colors.black,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    dataFest['US']['data']['festRecords']['nodes'][0]['title'],
                    style: TextStyle(color: Colors.grey.shade200, fontSize: 25),
                  ),
                  Container(
                    child: Image.network(dataFest['US']['data']['festRecords']
                        ['nodes'][0]['image']['url']),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      for (var team in dataFest['US']['data']['festRecords']
                          ['nodes'][0]['teams'])
                        Text(team['teamName'],
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 25))
                    ],
                  )
                ],
              ),
            ),
            Card(
                elevation: 10,
                color: Colors.black,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text("         "),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image(
                            image: AssetImage('assets/logo/S3/Tricolor.png'),
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "Fest Battle",
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 30),
                          ),
                          Image(
                              image: AssetImage('assets/logo/S3/Tricolor.png'),
                              width: 50,
                              height: 50)
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo/S3/${fest['vsRule']['rule']}.png',
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "(${fest['vsRule']['name'].toString()})",
                            style: TextStyle(
                                color: Colors.grey.shade400, fontSize: 20),
                          ),
                          Image.asset(
                            'assets/logo/S3/${fest['vsRule']['rule']}.png',
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
                          timeConvert(mapChange[0][0].substring(11, 13)) +
                              " to " +
                              timeConvert(mapChange[0][1].substring(11, 13)),
                          style: TextStyle(color: Colors.grey.shade200)),
                      Text("Actual rotation:",
                          style: TextStyle(
                              color: Colors.grey.shade400, fontSize: 16)),
                      Card(
                        elevation: 10,
                        color: Colors.grey.shade800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            for (var elements in fest['vsStages'])
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(elements['name'],
                                      style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontSize: 15)),
                                  Image.network(
                                    elements['image']['url'],
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
                                  builder: (context) => Schedules(
                                        background: Colors.black,
                                        content: festMult,
                                        mapChange: mapChange,
                                        type: 'Fest Battle',
                                        picLink: 'assets/logo/S3/Tricolor.png',
                                        typeCode: 'regularMatchSetting',
                                        fest: true,
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
            if (data['data']['currentFest']['state'] == "SECOND_HALF")
              Card(
                  elevation: 10,
                  color: Colors.black,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("         "),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image(
                              image: AssetImage('assets/logo/S3/Tricolor.png'),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "Tricolor Battle",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 30),
                            ),
                            Image(
                                image:
                                    AssetImage('assets/logo/S3/Tricolor.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/S3/Tricolor.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "Tricolor Turf War",
                              style: TextStyle(
                                  color: Colors.grey.shade400, fontSize: 20),
                            ),
                            Image.asset(
                              'assets/logo/S3/Tricolor.png',
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

                        Text("Tricolor map:",
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 16)),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text(
                                      data['data']['currentFest']
                                          ['tricolorStage']['name'],
                                      style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontSize: 25)),
                                  Image.network(
                                    data['data']['currentFest']['tricolorStage']
                                        ['image']['url'],
                                    width: 350,
                                    height: 230,
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
          ]),
        ));
  }

  Container grizzRoll(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/logo/S3/SalmonRun.png',
              width: 280,
              height: 150,
            ),
            if (eggstraCheck)
              Card(
                  elevation: 10,
                  color: Color(0xFFCA9215),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          "",
                          style: TextStyle(fontSize: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(
                                image:
                                    AssetImage('assets/logo/EggstraWork.png'),
                                width: 50,
                                height: 50),
                            Text(
                              "Eggstra Work",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 35),
                            ),
                            Image(
                                image:
                                    AssetImage('assets/logo/EggstraWork.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Text(
                          "Actual map:",
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 25),
                        ),
                        Text(
                          grizzEggstra['setting']['coopStage']['name'],
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 22),
                        ),
                        Text(
                          'From ' +
                              dateFormat(grizzEggstraChange[0][0]) +
                              ' to ' +
                              dateFormat(grizzEggstraChange[0][1]),
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 14),
                        ),
                        Image.network(
                          grizzEggstra['setting']['coopStage']['image']['url'],
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
                                    color: Colors.grey.shade400, fontSize: 20),
                              ),
                              for (var elements in grizzEggstra['setting']
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
                        ),
                      ],
                    ),
                  )),
            Card(
                elevation: 10,
                color: Color.fromARGB(255, 225, 65, 10),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text('', style: TextStyle(fontSize: 5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Image(
                              image: AssetImage('assets/logo/SalmonRun.png'),
                              width: 50,
                              height: 50),
                          Text(
                            "Salmon run",
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 35),
                          ),
                          Image(
                              image: AssetImage('assets/logo/SalmonRun.png'),
                              width: 50,
                              height: 50)
                        ],
                      ),
                      Text(
                        "Actual map:",
                        style: TextStyle(
                            color: Colors.grey.shade200, fontSize: 25),
                      ),
                      Text(
                        grizz['setting']['coopStage']['name'],
                        style: TextStyle(
                            color: Colors.grey.shade200, fontSize: 22),
                      ),
                      Text(
                        'From ' +
                            dateFormat(grizzChange[0][0]) +
                            ' to ' +
                            dateFormat(grizzChange[0][1]),
                        style: TextStyle(
                            color: Colors.grey.shade200, fontSize: 14),
                      ),
                      Image.network(
                        grizz['setting']['coopStage']['image']['url'],
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
                                  color: Colors.grey.shade400, fontSize: 20),
                            ),
                            for (var elements in grizz['setting']['weapons'])
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
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchedulesGrizz(
                                        content: grizzMult,
                                        change: grizzChange,
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
              "Source: splatoon3.ink",
              style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
            ),
          ],
        ),
      ),
    );
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

  String dateFormat(String value) {
    String date = value.substring(0, 10).replaceAll(RegExp('-'), '/');
    return '${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}' +
        ' at ' +
        timeConvert(value.substring(11, 13));
  }
}
