import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:splat_news/splaThree/schedules/schedule_grizz.dart';
import 'package:splat_news/splaThree/schedules/schedule_rank.dart';
import 'package:splat_news/splaThree/schedules/schedules.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplatoonTrois {
  // The data we receive from the API
  Map<String, dynamic> data = new Map();
  Map<String, dynamic> dataFest = new Map();

  // Dedicated to the turf war match
  Map<String, dynamic> turfMult = new Map();

  // Dedicated to the ranked match
  Map<String, dynamic> rankMult = new Map();

  // Dedicated to the X match
  Map<String, dynamic> xrankMult = new Map();

  // Dedicated to Challenges
  Map<String, dynamic> challenges = new Map();

  // Dedicated to Salmon Run
  Map<String, dynamic> grizz = new Map();
  Map<String, dynamic> grizzEggstra = new Map();
  Map<String, dynamic> grizzBig = new Map();
  Map<String, dynamic> grizzMult = new Map();

  // Dedicated to the splatfest matches
  Map<String, dynamic> fest = new Map();
  Map<String, dynamic> festMult = new Map();
  Map<String, dynamic> festSettings = new Map();

  // True if a splatfest is in progress
  bool festCheck = false;

  // True if an eggstra work event is in progress
  bool eggstraCheck = false;
  bool eggstraSoon = false;

  // True if a Big Run event is in progress
  bool bigCheck = false;
  bool bigSoon = false;
  bool bigNow = false;

  // True if a fest is scheduled
  bool festScheduled = false;

  // True if there is a challenge
  bool challengeCheck = false;

  // Timestamp of each map
  List<List<String>> mapChange =
      List.generate(12, (i) => List.generate(2, (j) => ''));

  List<List<String>> grizzChange =
      List.generate(5, (i) => List.generate(2, (j) => ''));

  List<List<String>> grizzEggstraChange =
      List.generate(1, (i) => List.generate(2, (j) => ''));

  List<List<String>> grizzBigChange =
      List.generate(1, (i) => List.generate(2, (j) => ''));

  Future<int> test() async {
    final prefs = await SharedPreferences.getInstance();
    final nextUpdate = prefs.getInt('nextUpdateS3') ?? 0;
    final actualTime = DateTime.now().millisecondsSinceEpoch;
    if (actualTime > nextUpdate) {
      String url = "https://splatoon3.ink/data/schedules.json";
      String urlFest = "https://splatoon3.ink/data/festivals.json";

      // We use a try in case there is no internet connectivity
      try {
        var response = await http.get(Uri.parse(url), headers: {
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8',
          'User-Agent': 'SplatNews/dev (nicolasdefalco.9@gmail.com)'
        });
        var responseFest = await http.get(Uri.parse(urlFest), headers: {
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8',
          'User-Agent': 'SplatNews/dev (nicolasdefalco.9@gmail.com)'
        });
        if (response.statusCode == 200) {
          data = convert.jsonDecode(response.body);
          dataFest = convert.jsonDecode(responseFest.body);
          dataSet();
          await prefs.setInt(
              'nextUpdateS3',
              DateTime.parse(
                      data['data']['festSchedules']['nodes'][0]['endTime'])
                  .millisecondsSinceEpoch);
          await prefs.setString('dataS3', convert.jsonEncode(data));
          await prefs.setString('dataFestS3', convert.jsonEncode(dataFest));
          return response.statusCode;
        }
      } catch (e) {
        debugPrint(e.toString());
        return 2000;
      }
    } else {
      var dataReco = prefs.getString('dataS3');
      var festReco = prefs.getString('dataFestS3');

      data = convert.jsonDecode(dataReco.toString()) as Map<String, dynamic>;
      dataFest =
          convert.jsonDecode(festReco.toString()) as Map<String, dynamic>;

      dataSet();
    }
    return 200;
  }

  void dataSet() {
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
      turfMult = data['data']['regularSchedules'];
      rankMult = data['data']['bankaraSchedules'];
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
    for (var changes in data['data']['coopGroupingSchedule']['regularSchedules']
        ['nodes']) {
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
      if (DateTime.now().millisecondsSinceEpoch <
          DateTime.parse(grizzEggstra['startTime']).millisecondsSinceEpoch) {
        eggstraSoon = true;
      }
    }
    if (data['data']['coopGroupingSchedule']['bigRunSchedules']['nodes']
            .toString() !=
        '[]') {
      grizzBig =
          data['data']['coopGroupingSchedule']['bigRunSchedules']['nodes'][0];
      bigCheck = true;
      grizzBigChange[0][0] = DateTime.parse(data['data']['coopGroupingSchedule']
              ['bigRunSchedules']['nodes'][0]['startTime'])
          .toLocal()
          .toString();
      grizzBigChange[0][1] = DateTime.parse(data['data']['coopGroupingSchedule']
              ['bigRunSchedules']['nodes'][0]['endTime'])
          .toLocal()
          .toString();
      if (DateTime.now().millisecondsSinceEpoch <
          DateTime.parse(grizzBig['startTime']).millisecondsSinceEpoch) {
        bigSoon = true;
      }
      if (DateTime.now().millisecondsSinceEpoch >
              DateTime.parse(grizzBig['startTime']).millisecondsSinceEpoch &&
          DateTime.now().millisecondsSinceEpoch <
              DateTime.parse(grizzBig['endTime']).millisecondsSinceEpoch) {
        bigNow = true;
      }
    }

    if (data['data']['eventSchedules'] != null) {
      challenges = data['data']['eventSchedules'];
      challengeCheck = true;
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

  //FIXME: This function is absudely huge, and it's surely possible to optimize it(720 line is huge).
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
                  "Splat fest inkoming!",
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
                        child: CachedNetworkImage(
                          imageUrl: dataFest['US']['data']['festRecords']
                              ['nodes'][0]['image']['url'],
                        ),
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
                  color: const Color.fromARGB(255, 23, 200, 26),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("         "),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Image(
                              image: AssetImage('assets/logo/Regular.png'),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "Regular Battle",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 30),
                            ),
                            const Image(
                                image: AssetImage('assets/logo/Regular.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/S3/${turfMult['nodes'][0]['regularMatchSetting']['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "(${turfMult['nodes'][0]['regularMatchSetting']['vsRule']['name'].toString()})",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 20),
                            ),
                            Image.asset(
                              'assets/logo/S3/${turfMult['nodes'][0]['regularMatchSetting']['vsRule']['rule']}.png',
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

                        Text("${timeConvert(mapChange[0][0].substring(11, 13))} to ${timeConvert(mapChange[0][1].substring(11, 13))}"),
                        Text("Actual rotation:",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 16)),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var elements in turfMult['nodes'][0]
                                  ['regularMatchSetting']['vsStages'])
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Schedules(
                                          background:
                                              const Color.fromARGB(255, 23, 200, 26),
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
                  color: const Color.fromARGB(255, 224, 67, 18),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("         "),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Image(
                              image: AssetImage('assets/logo/Ranked.png'),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "Anarchy Battle Series",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 30),
                            ),
                            const Image(
                                image: AssetImage('assets/logo/Ranked.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/S3/${rankMult['nodes'][0]['bankaraMatchSettings'][0]['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "(${rankMult['nodes'][0]['bankaraMatchSettings'][0]['vsRule']['name'].toString()})",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 20),
                            ),
                            Image.asset(
                              'assets/logo/S3/${rankMult['nodes'][0]['bankaraMatchSettings'][0]['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        Text("${timeConvert(mapChange[0][0].substring(11, 13))} to ${timeConvert(mapChange[0][1].substring(11, 13))}"),
                        Text("Actual rotation:",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 16)),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var elements in rankMult['nodes'][0]
                                  ['bankaraMatchSettings'][0]['vsStages'])
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
                  color: const Color.fromARGB(255, 224, 67, 18),
                  elevation: 10,
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text("         "),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Image(
                              image: AssetImage('assets/logo/Ranked.png'),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "Anarchy Battle Open",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 30),
                            ),
                            const Image(
                                image: AssetImage('assets/logo/Ranked.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/S3/${rankMult['nodes'][0]['bankaraMatchSettings'][1]['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "(${rankMult['nodes'][0]['bankaraMatchSettings'][1]['vsRule']['name'].toString()})",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 20),
                            ),
                            Image.asset(
                              'assets/logo/S3/${rankMult['nodes'][0]['bankaraMatchSettings'][1]['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        Text("${timeConvert(mapChange[0][0].substring(11, 13))} to ${timeConvert(mapChange[0][1].substring(11, 13))}"),
                        Text("Actual rotation:",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 16)),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var elements in rankMult['nodes'][0]
                                  ['bankaraMatchSettings'][1]['vsStages'])
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
                  color: const Color.fromARGB(255, 14, 199, 144),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text("         "),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Image(
                              image: AssetImage('assets/logo/XBattle.png'),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "X Battle",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 30),
                            ),
                            const Image(
                                image: AssetImage('assets/logo/XBattle.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/logo/S3/${xrankMult['nodes'][0]['xMatchSetting']['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "(${xrankMult['nodes'][0]['xMatchSetting']['vsRule']['name'].toString()})",
                              style: TextStyle(
                                  color: Colors.grey.shade800, fontSize: 20),
                            ),
                            Image.asset(
                              'assets/logo/S3/${xrankMult['nodes'][0]['xMatchSetting']['vsRule']['rule']}.png',
                              width: 50,
                              height: 50,
                            ),
                          ],
                        ),
                        Text("${timeConvert(mapChange[0][0].substring(11, 13))} to ${timeConvert(mapChange[0][1].substring(11, 13))}"),
                        Text("Actual rotation:",
                            style: TextStyle(
                                color: Colors.grey.shade800, fontSize: 16)),
                        Card(
                          elevation: 10,
                          color: Colors.grey.shade800,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              for (var elements in xrankMult['nodes'][0]
                                  ['xMatchSetting']['vsStages'])
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
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Schedules(
                                          background:
                                              const Color.fromARGB(255, 14, 199, 144),
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
                    child: CachedNetworkImage(
                      imageUrl: dataFest['US']['data']['festRecords']['nodes']
                          [0]['image']['url'],
                    ),
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
                      const Text("         "),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          const Image(
                            image: AssetImage('assets/logo/S3/Tricolor.png'),
                            width: 50,
                            height: 50,
                          ),
                          Text(
                            "Fest Battle",
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 30),
                          ),
                          const Image(
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
                          "${timeConvert(mapChange[0][0].substring(11, 13))} to ${timeConvert(mapChange[0][1].substring(11, 13))}",
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
                        const Text("         "),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            const Image(
                              image: AssetImage('assets/logo/S3/Tricolor.png'),
                              width: 50,
                              height: 50,
                            ),
                            Text(
                              "Tricolor Battle",
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 30),
                            ),
                            const Image(
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
                                  CachedNetworkImage(
                                    imageUrl: data['data']['currentFest']
                                        ['tricolorStage']['image']['url'],
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

  //FIXME: This needs to be more compact.
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
                  color: const Color(0xFFCA9215),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "",
                          style: TextStyle(fontSize: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Image(
                                image:
                                    AssetImage('assets/logo/EggstraWork.png'),
                                width: 50,
                                height: 50),
                            if (eggstraSoon)
                              Text(
                                "Eggstra Work Inkoming",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 30),
                              )
                            else
                              Text(
                                "Eggstra Work",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 35),
                              ),
                            const Image(
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
                          'From ${dateFormat(grizzEggstraChange[0][0])} to ${dateFormat(grizzEggstraChange[0][1])}',
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 14),
                        ),
                        CachedNetworkImage(
                          imageUrl: grizzEggstra['setting']['coopStage']
                              ['image']['url'],
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
                        ),
                      ],
                    ),
                  )),
            if (bigCheck)
              Card(
                  elevation: 10,
                  color: const Color.fromARGB(255, 165, 53, 128),
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          "",
                          style: TextStyle(fontSize: 5),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Image(
                                image: AssetImage('assets/logo/S3/BigRun.png'),
                                width: 50,
                                height: 50),
                            if (bigSoon)
                              Text(
                                "Big Run Inkoming!",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 35),
                              )
                            else
                              Text(
                                "Big Run!",
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 35),
                              ),
                            const Image(
                                image: AssetImage('assets/logo/S3/BigRun.png'),
                                width: 50,
                                height: 50)
                          ],
                        ),
                        Text(
                          "Big Run map:",
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 25),
                        ),
                        Text(
                          grizzBig['setting']['coopStage']['name'],
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 22),
                        ),
                        Text(
                          'From ${dateFormat(grizzBigChange[0][0])} to ${dateFormat(grizzBigChange[0][1])}',
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 14),
                        ),
                        CachedNetworkImage(
                          imageUrl: grizzBig['setting']['coopStage']['image']
                              ['url'],
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
                              for (var elements in grizzBig['setting']
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
                        ),
                      ],
                    ),
                  )),
            Card(
                elevation: 10,
                color: const Color.fromARGB(255, 225, 65, 10),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const Text('', style: TextStyle(fontSize: 5)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Image(
                              image: AssetImage('assets/logo/SalmonRun.png'),
                              width: 50,
                              height: 50),
                          Text(
                            "Salmon run",
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 35),
                          ),
                          const Image(
                              image: AssetImage('assets/logo/SalmonRun.png'),
                              width: 50,
                              height: 50)
                        ],
                      ),
                      if (bigNow)
                        Text(
                          "Coming soon:",
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 25),
                        )
                      else
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
                        'From ${dateFormat(grizzChange[0][0])} to ${dateFormat(grizzChange[0][1])}',
                        style: TextStyle(
                            color: Colors.grey.shade200, fontSize: 14),
                      ),
                      CachedNetworkImage(
                        imageUrl: grizz['setting']['coopStage']['image']['url'],
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
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SchedulesGrizz(
                                        content: grizzMult,
                                        change: grizzChange,
                                        bigrun: bigNow,
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

  Container challengesRoll(BuildContext context) {
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
          for (var elements in challenges['nodes'])
            Card(
              elevation: 10,
              color: const Color.fromARGB(255, 221, 41, 118),
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const Text("         "),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Image(
                            image: AssetImage('assets/logo/S3/Challenge.png'),
                            width: 60,
                            height: 60),
                        Text(
                          "Challenge",
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 30),
                        ),
                        const Image(
                            image: AssetImage('assets/logo/S3/Challenge.png'),
                            width: 60,
                            height: 60)
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/logo/S3/${elements['leagueMatchSetting']['vsRule']['rule']}.png',
                          width: 50,
                          height: 50,
                        ),
                        Text(
                          "(${elements['leagueMatchSetting']['vsRule']['name'].toString()})",
                          style: TextStyle(
                              color: Colors.grey.shade800, fontSize: 20),
                        ),
                        Image.asset(
                          'assets/logo/S3/${elements['leagueMatchSetting']['vsRule']['rule']}.png',
                          width: 50,
                          height: 50,
                        ),
                      ],
                    ),
                    Card(
                      elevation: 10,
                      color: Colors.grey.shade800,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              Text(
                                elements['leagueMatchSetting']
                                    ['leagueMatchEvent']['name'],
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 22),
                              ),
                              Text(
                                elements['leagueMatchSetting']
                                        ['leagueMatchEvent']['desc']
                                    .replaceAll(RegExp('<br />ã|<br />'), '\n'),
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 20),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.grey.shade700),
                                  onPressed: () {
                                    showDialog(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              backgroundColor:
                                                  Colors.grey.shade800,
                                              title: Text(
                                                elements['leagueMatchSetting']
                                                        ['leagueMatchEvent']
                                                    ['name'],
                                                style: TextStyle(
                                                    color: Colors.grey.shade200,
                                                    fontSize: 25),
                                              ),
                                              content: Text(
                                                elements['leagueMatchSetting']
                                                            ['leagueMatchEvent']
                                                        ['regulation']
                                                    .replaceAll(
                                                        RegExp(
                                                            '<br />ã|<br />'),
                                                        '\n')
                                                    .replaceAll(
                                                        RegExp('»'), '-'),
                                                style: TextStyle(
                                                    color: Colors.grey.shade200,
                                                    fontSize: 15),
                                              ),
                                              actions: [
                                                TextButton(
                                                    onPressed: () =>
                                                        Navigator.pop(context),
                                                    child: Text("Ok",
                                                        style: TextStyle(
                                                            color: Colors
                                                                .grey.shade400,
                                                            fontSize: 15)))
                                              ],
                                            ));
                                  },
                                  child: Text(
                                    "     Challenge Rules     ",
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 20),
                                  )),
                            ],
                          )
                        ],
                      ),
                    ),
                    Text(
                      "Schedules:",
                      style:
                          TextStyle(color: Colors.grey.shade200, fontSize: 25),
                    ),
                    Card(
                      elevation: 10,
                      color: Colors.grey.shade800,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              for (var date in elements['timePeriods'])
                                Text(
                                    "${dateFormat(DateTime.parse(date['startTime'])
                                            .toLocal()
                                            .toString())} to ${dateFormat(
                                            DateTime.parse(date['endTime'])
                                                .toLocal()
                                                .toString())}",
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Text(
                      "Challenge's maps:",
                      style:
                          TextStyle(color: Colors.grey.shade200, fontSize: 25),
                    ),
                    Card(
                      elevation: 10,
                      color: Colors.grey.shade800,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          for (var map in elements['leagueMatchSetting']
                              ['vsStages'])
                            Column(
                              children: [
                                Text(map['name'],
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15)),
                                CachedNetworkImage(
                                  imageUrl: map['image']['url'],
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
              ),
            ),
          Text(
            "Source: splatoon3.ink",
            style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
          ),
        ])));
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

    return '$time $tz';
  }

  String dateFormat(String value) {
    String date = value.substring(0, 10).replaceAll(RegExp('-'), '/');
    return '${date.substring(8, 10)}/${date.substring(5, 7)}/${date.substring(0, 4)}' +
        ' at ' +
        timeConvert(value.substring(11, 13));
  }
}
