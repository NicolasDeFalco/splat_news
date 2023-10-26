import 'package:flutter/material.dart';
import 'apicall_main.dart';
import '../loading/loading.dart';

class SplatoonThree extends StatefulWidget {
  const SplatoonThree({super.key, required this.title});

  final String title;

  @override
  State<SplatoonThree> createState() => _SplatoonThreeState();
}

class _SplatoonThreeState extends State<SplatoonThree>
    with AutomaticKeepAliveClientMixin {
  SplatoonTrois test = SplatoonTrois();
  int code = 0;
  int pageCount = 1;
  bool received = false;

  @override
  bool get wantKeepAlive => true;

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

  Widget retry() {
    return GestureDetector(
      onTap: () {
        setState(() {
          code = 0;
          received = false;
        });
      },
      child: Card(
        color: Colors.grey.shade800,
        child: Text('   Retry   ',
            style: TextStyle(color: Colors.grey.shade200, fontSize: 20)),
      ),
    );
  }

  Widget message(Widget message) {
    return Container(
        decoration: BoxDecoration(color: Colors.grey.shade900),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            message,
            retry(),
          ],
        ));
  }

  Widget pages(pageNumber) {
    switch (pageNumber) {
      case 1:
        return test.actualRoll(context);
      case 2:
        return test.challengesRoll(context);
      case 3:
        return test.grizzRoll(context);
      case 4:
        return test.gearRoll(context);
      default:
        return test.splatfestResult(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
        body: FutureBuilder(
          future: codeRetreive(),
          builder: (context, snapshot) {
            switch (code) {
              case 200:
                return pages(pageCount);
              case 2000:
                return message(notConnected());
              case 0:
                return loading();
              default:
                return message(error(code));
            }
          },
        ),
        bottomNavigationBar: BottomAppBar(
            color: Colors.grey.shade900,
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  SizedBox(
                    height: 60,
                    width: 110,
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
                  SizedBox(
                    height: 60,
                    width: 110,
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
                  SizedBox(
                    height: 60,
                    width: 110,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pageCount = 3;
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
                  SizedBox(
                    height: 60,
                    width: 110,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pageCount = 4;
                          });
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Gears",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15))
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 60,
                    width: 110,
                    child: Material(
                      type: MaterialType.transparency,
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            pageCount = 5;
                          });
                        },
                        child: const Column(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Splat Fest",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 15))
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )));
  }
}
