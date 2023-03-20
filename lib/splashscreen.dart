import 'dart:async';

import 'package:flutter/material.dart';
import 'homepage.dart';

class SplashScreenState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3),
        () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage())));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          color: Color.fromRGBO(66, 66, 66, 1),
          /*image: DecorationImage(
            image: AssetImage('assets/images/bg-splash.jpg'),
            fit: BoxFit.cover,
          ),*/
        ),
        child: const Image(image: AssetImage('assets/squid.png')));
  }
}
