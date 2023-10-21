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
    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
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
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: <Widget>[
              Tab(
                text: 'Splatoon 3',
              ),
              Tab(
                text: 'Splatoon 2',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: <Widget>[SplatoonThree(title: ""), SplatoonTwo(title: "")],
        ),
      ),
    );
  }
}
