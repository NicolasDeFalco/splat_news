import 'package:flutter/material.dart';
import 'splashscreen.dart';
import 'splaThree/splatoonthree.dart';
import 'splaTwo/splatoontwo.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  SplashScreenState createState() => SplashScreenState();
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset(
              'assets/squid.png',
              fit: BoxFit.contain,
              height: 42,
            ),
            const Text(" Splat news")
          ]),
          backgroundColor: Colors.grey.shade900,
          /*flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[Colors.purple.shade800, Colors.pink]),
            ),
          ),*/
        ),
        body: Container(
          decoration: BoxDecoration(
            color: Colors.grey.shade800,
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Image.asset(
                  'assets/squid.png',
                  width: 300,
                  height: 300,
                ),
                SizedBox.fromSize(
                  size: const Size(300, 90),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[Color.fromARGB(255, 229, 255, 0), Color.fromARGB(255, 100, 48, 254)]),
                      ),
                      child: InkWell(
                        //splashColor: Colors.white,
                        onTap: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SplatoonThree(
                                        title: "Splat News",
                                      )));
                        }),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text("Splatoon 3"), // <-- Icon
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox.fromSize(
                  size: const Size(300, 90),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: <Color>[Color.fromARGB(255, 240, 45, 125), Color.fromARGB(255, 25, 215, 25)]),
                      ),
                      child: InkWell(
                        //splashColor: Colors.white,
                        onTap: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SplatoonTwo(
                                        title: 'Splat news',
                                      )));
                        }),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const <Widget>[
                            Text("Splatoon 2"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
