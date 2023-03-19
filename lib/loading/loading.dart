import 'dart:ui';

import 'package:flutter/material.dart';

Container loading() {
  return Container(
      decoration: BoxDecoration(color: Colors.grey.shade900),
      child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  CircularProgressIndicator(),
                  Text(
                    "Loading...",
                    style: TextStyle(color: Colors.white, fontSize: 15),
                  )
                ],
              ),
            ],
          )));
}

Container error(int code) {
  String message =
      "An error has occured during the connection. \nPlease try again later.";

  return Container(
      decoration: BoxDecoration(color: Colors.grey.shade900),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                Image.network(
                  'https://http.cat/$code.jpg',
                  width: 380,
                  height: 490,
                )
              ],
            )
          ],
        ),
      ));
}

Container notConnected() {
  return Container(
    decoration: BoxDecoration(color: Colors.grey.shade900),
    child: BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "You are not connected to the internet. \nPlease check that either Wi-fi or Cellular Mobile Data \nare enabled and try again.",
                style: TextStyle(color: Colors.grey.shade200, fontSize: 15),
              ),
            ],
          )
        ],
      ),
    ),
  );
}
