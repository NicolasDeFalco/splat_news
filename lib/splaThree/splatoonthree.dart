import 'package:flutter/material.dart';
import 'apicall_main.dart';
import '../loading/loading.dart';

class SplatoonThree extends StatefulWidget {
  const SplatoonThree({super.key, required this.title});

  final String title;

  @override
  State<SplatoonThree> createState() => _SplatoonThreeState();
}

class _SplatoonThreeState extends State<SplatoonThree> {
  SplatoonTrois test = SplatoonTrois();
  int code = 0;
  Container page = Container();
  int pageCount = 1;
  bool received = false;

  Future<void> codeRetreive() async {
    if (!received) {
      while (true) {
        code = await test.test();
        //debugPrint(code.toString());
        if (code != 21) {
          if (code == 200) {
            received = true;
          }
          break;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder(
          future: codeRetreive(),
          builder: (context, snapshot) {
            if (code == 200) {
              if (pageCount == 1) {
                page = test.actualRoll(context);
              } else if (pageCount == 2) {
                page = test.challengesRoll(context);
              } else {
                page = test.grizzRoll(context);
              }
              return page;
            } else if (code == 2000) {
              return notConnected();
            } else if (code == 0) {
              return loading();
            }
            return error(code);
          },
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.grey.shade900,
          child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pageCount = 1;
                          });
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Match",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pageCount = 2;
                          });
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Challenges",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pageCount = 0;
                          });
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Salmon Run",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15))
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ));
  }
}
