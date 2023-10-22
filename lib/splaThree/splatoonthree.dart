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
  Container page = Container();
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
              return message(notConnected());
            } else if (code == 0) {
              return loading();
            }
            return message(error(code));
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
