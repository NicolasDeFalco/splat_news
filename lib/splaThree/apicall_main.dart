import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:splat_news/splaThree/draw_functions/actual_fest_three.dart';
import 'package:splat_news/splaThree/draw_functions/actual_gear_three.dart';
import 'package:splat_news/splaThree/draw_functions/actual_grizzgear_three.dart';
import 'package:splat_news/splaThree/draw_functions/actual_three.dart';
import 'package:splat_news/splaThree/draw_functions/actual_coop_three.dart';
import 'package:splat_news/splaThree/draw_functions/actual_rank_three.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:splat_news/functions/functions.dart';
import 'package:splat_news/splaThree/draw_functions/draw_splatfest_three.dart';

class SplatoonTrois {
  // The data we receive from the API
  Map<String, dynamic> data = new Map();
  Map<String, dynamic> dataFest = new Map();
  Map<String, dynamic> dataGear = new Map();
  Map<String, dynamic> dailyGearData = new Map();

  // Dedicated to the turf war match
  Map<String, dynamic> turfMult = new Map();

  // Dedicated to the ranked match
  Map<String, dynamic> rankMult = new Map();

  // Dedicated to the X match
  Map<String, dynamic> xrankMult = new Map();

  // Dedicated to Challenges
  Map<String, dynamic> challenges = new Map();

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
      String urlGear = "https://splatoon3.ink/data/coop.json";
      String urlDailyGear = "https://splatoon3.ink/data/gear.json";

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
        var responseGear = await http.get(Uri.parse(urlGear), headers: {
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8',
          'User-Agent': 'SplatNews/dev (nicolasdefalco.9@gmail.com)'
        });
        var responseDailyGear =
            await http.get(Uri.parse(urlDailyGear), headers: {
          'Content-Type': 'application/json',
          'Accept-Charset': 'utf-8',
          'User-Agent': 'SplatNews/dev (nicolasdefalco.9@gmail.com)'
        });
        if (response.statusCode == 200) {
          data = convert.jsonDecode(response.body);
          dataFest = convert.jsonDecode(responseFest.body);
          dataGear = convert.jsonDecode(responseGear.body);
          dailyGearData = convert.jsonDecode(responseDailyGear.body);
          dataSet();
          await prefs.setInt(
              'nextUpdateS3',
              DateTime.parse(
                      data['data']['festSchedules']['nodes'][0]['endTime'])
                  .millisecondsSinceEpoch);
          await prefs.setString('dataS3', convert.jsonEncode(data));
          await prefs.setString('dataFestS3', convert.jsonEncode(dataFest));
          await prefs.setString('dataGearS3', convert.jsonEncode(dataGear));
          await prefs.setString(
              'dataDailyGearS3', convert.jsonEncode(dailyGearData));
        }
        return response.statusCode;
      } catch (e) {
        debugPrint(e.toString());
        return 2000;
      }
    } else {
      var dataReco = prefs.getString('dataS3');
      var festReco = prefs.getString('dataFestS3');
      var gearReco = prefs.getString('dataGearS3');
      var dailyGearReco = prefs.getString('dataDailyGearS3');

      data = convert.jsonDecode(dataReco.toString()) as Map<String, dynamic>;
      dataFest =
          convert.jsonDecode(festReco.toString()) as Map<String, dynamic>;
      dataGear =
          convert.jsonDecode(gearReco.toString()) as Map<String, dynamic>;
      dailyGearData =
          convert.jsonDecode(dailyGearReco.toString()) as Map<String, dynamic>;

      dataSet();
    }
    return 200;
  }

  void dataSet() {
    // Check if there is no splatfest
    if (dataFest['US']['data']['festRecords']['nodes'][0]['state'] ==
            'CLOSED' ||
        dataFest['US']['data']['festRecords']['nodes'][0]['state'] ==
            'SCHEDULED') {
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

      turfMult = data['data']['regularSchedules'];
      rankMult = data['data']['bankaraSchedules'];
      xrankMult = data['data']['xSchedules'];

      // Is true when a fest is scheduled
      if (dataFest['US']['data']['festRecords']['nodes'][0]['state'] ==
          'SCHEDULED') {
        festScheduled = true;
      }
    } else {
      //There is a splatfest
      festCheck = true;
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
      festMult = data['data']['festSchedules'];
    }

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
          DateTime.parse(data['data']['coopGroupingSchedule']
                  ['teamContestSchedules']['nodes'][0]['startTime'])
              .millisecondsSinceEpoch) {
        eggstraSoon = true;
      }
    }
    if (data['data']['coopGroupingSchedule']['bigRunSchedules']['nodes']
            .toString() !=
        '[]') {
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
          DateTime.parse(data['data']['coopGroupingSchedule']['bigRunSchedules']
                  ['nodes'][0]['startTime'])
              .millisecondsSinceEpoch) {
        bigSoon = true;
      }
      if (DateTime.now().millisecondsSinceEpoch >
              DateTime.parse(data['data']['coopGroupingSchedule']
                      ['bigRunSchedules']['nodes'][0]['startTime'])
                  .millisecondsSinceEpoch &&
          DateTime.now().millisecondsSinceEpoch <
              DateTime.parse(data['data']['coopGroupingSchedule']
                      ['bigRunSchedules']['nodes'][0]['endTime'])
                  .millisecondsSinceEpoch) {
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
              if (festScheduled) festBanner('Splat fest inkoming!'),
              actual(
                  context,
                  turfMult,
                  'regularMatchSetting',
                  mapChange,
                  const Color.fromARGB(255, 23, 200, 26),
                  'assets/logo/Regular.png'),
              actualRank(context, rankMult, 0, mapChange),
              actualRank(context, rankMult, 1, mapChange),
              actual(
                  context,
                  xrankMult,
                  'xMatchSetting',
                  mapChange,
                  const Color.fromARGB(255, 14, 199, 144),
                  'assets/logo/XBattle.png'),
              Text(
                "Source: splatoon3.ink",
                style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
              ),
              disclaimer()
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
            festBanner('SPLAT FEST !'),
            actualFest(
                context, festMult, 'Splatfest Battle (Open)', mapChange, 1),
            actualFest(
                context, festMult, 'Splatfest Battle (Pro)', mapChange, 0),
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
            disclaimer()
          ]),
        ));
  }

  Widget festBanner(String text) {
    return Card(
      elevation: 10,
      color: Colors.black,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Image(
                image: AssetImage('assets/logo/S3/Tricolor.png'),
                width: 50,
                height: 50,
              ),
              Text(
                text,
                style: TextStyle(color: Colors.grey.shade200, fontSize: 30),
              ),
              const Image(
                  image: AssetImage('assets/logo/S3/Tricolor.png'),
                  width: 50,
                  height: 50)
            ],
          ),
          Text(
            'From ${dateFormat(DateTime.parse(dataFest['US']['data']['festRecords']['nodes'][0]['startTime']).toLocal().toString())} to ${dateFormat(DateTime.parse(dataFest['US']['data']['festRecords']['nodes'][0]['endTime']).toLocal().toString())}',
            style: TextStyle(color: Colors.grey.shade200, fontSize: 14),
          ),
          Card(
            color: Colors.grey.shade800,
            child: Column(children: [
              Text(
                dataFest['US']['data']['festRecords']['nodes'][0]['title'],
                style: TextStyle(color: Colors.grey.shade200, fontSize: 20),
              ),
              Container(
                child: CachedNetworkImage(
                  imageUrl: dataFest['US']['data']['festRecords']['nodes'][0]
                      ['image']['url'],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  for (var team in dataFest['US']['data']['festRecords']
                      ['nodes'][0]['teams'])
                    Text(team['teamName'],
                        style: TextStyle(
                            color: Colors.grey.shade200, fontSize: 18))
                ],
              )
            ]),
          ),
        ],
      ),
    );
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
            actualGrizzGear(dataGear['data']['coopResult']['monthlyGear']),
            if (eggstraCheck)
              actualGrizz(
                  context,
                  data['data']['coopGroupingSchedule']['teamContestSchedules'],
                  1,
                  const Color(0xFFCA9215),
                  eggstraSoon,
                  grizzEggstraChange,
                  'assets/logo/EggstraWork.png'),
            if (bigCheck)
              actualGrizz(
                  context,
                  data['data']['coopGroupingSchedule']['bigRunSchedules'],
                  2,
                  const Color.fromARGB(255, 165, 53, 128),
                  bigSoon,
                  grizzBigChange,
                  'assets/logo/S3/BigRun.png'),
            actualGrizz(
                context,
                data['data']['coopGroupingSchedule']['regularSchedules'],
                0,
                const Color.fromARGB(255, 201, 77, 15),
                bigNow,
                grizzChange,
                'assets/logo/SalmonRun.png'),
            Text(
              "Source: splatoon3.ink",
              style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
            ),
            disclaimer()
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
                    if (elements['leagueMatchSetting']['vsRule'] != null)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/logo/S3/${elements['leagueMatchSetting']['vsRule']['rule'].toString()}.png',
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
                      )
                    else
                      Text(
                        "???",
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 20),
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
                                        ['leagueMatchEvent']['name']
                                    .replaceAll(RegExp('ï¼'), '?'),
                                style: TextStyle(
                                    color: Colors.grey.shade200, fontSize: 22),
                              ),
                              Text(
                                elements['leagueMatchSetting']
                                        ['leagueMatchEvent']['desc']
                                    .replaceAll(RegExp('<br />ã|<br />'), '\n')
                                    .replaceAll(RegExp('ï¼'), '?'),
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
                                                        ['name']
                                                    .replaceAll(
                                                        RegExp('ï¼'), '?'),
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
                                                        RegExp('»'), '-')
                                                    .replaceAll(
                                                        RegExp('ï¼'), '?'),
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
                    if (elements['timePeriods'].toString() != '[]')
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
                                      "${dateFormat(DateTime.parse(date['startTime']).toLocal().toString())} to ${dateFormat(DateTime.parse(date['endTime']).toLocal().toString())}",
                                      style: TextStyle(
                                          color: Colors.grey.shade200,
                                          fontSize: 15)),
                              ],
                            )
                          ],
                        ),
                      )
                    else
                      Card(
                        elevation: 10,
                        color: Colors.grey.shade800,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text("???",
                                    style: TextStyle(
                                        color: Colors.grey.shade200,
                                        fontSize: 15)),
                              ],
                            )
                          ],
                        ),
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
          disclaimer()
        ])));
  }

  Container gearRoll(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/logo/S3.png',
              width: 280,
              height: 150,
            ),
            Card(
              color: Colors.blueAccent.shade700,
              child: Column(
                children: [
                  Text('Daily Drop',
                      style:
                          TextStyle(color: Colors.grey.shade200, fontSize: 30)),
                  Card(
                      elevation: 10,
                      color: Colors.grey.shade800,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            dailyGearData['data']['gesotown']['pickupBrand']
                                ['brand']['name'],
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 22),
                          ),
                          CachedNetworkImage(
                            imageUrl: dailyGearData['data']['gesotown']
                                ['pickupBrand']['image']['url'],
                          ),
                        ],
                      )),
                  Text('Today\'s gear:',
                      style:
                          TextStyle(color: Colors.grey.shade200, fontSize: 25)),
                  for (var gear in dailyGearData['data']['gesotown']
                      ['pickupBrand']['brandGears'])
                    actualGear(gear)
                ],
              ),
            ),
            Card(
              color: Colors.grey.shade600,
              child: Column(
                children: [
                  Text('Gear on sale',
                      style:
                          TextStyle(color: Colors.grey.shade200, fontSize: 30)),
                  for (var gear in dailyGearData['data']['gesotown']
                      ['limitedGears'])
                    actualGear(gear)
                ],
              ),
            ),
            Text(
              "Source: splatoon3.ink",
              style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
            ),
            disclaimer()
          ],
        ),
      ),
    );
  }

  Container splatfestResult(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade800,
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/logo/S3.png',
              width: 280,
              height: 150,
            ),
            for (var team in dataFest['US']['data']['festRecords']['nodes'])
              if (team['state'] == 'CLOSED') splatfestResultCard(context, team),
            Text(
              "Source: splatoon3.ink",
              style: TextStyle(color: Colors.grey.shade200, fontSize: 16),
            ),
            disclaimer()
          ],
        ),
      ),
    );
  }
}
