import 'package:flutter/material.dart';
import 'homepage.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      title: 'Splat News',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Splatfont',
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.grey,
        ),
      ),
      home: const MyHomePage(title: 'Squid info'),
      debugShowCheckedModeBanner: false,
    );
  }
}
