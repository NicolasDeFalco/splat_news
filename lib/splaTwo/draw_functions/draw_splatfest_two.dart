import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget splatfestResultCard(Map<String, dynamic> data) {
  return Card(
    elevation: 10,
    color: Colors.black,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            CachedNetworkImage(
                imageUrl:
                    "https://splatoon2.ink/assets/splatnet${data['images']['alpha']}",
                width: 50,
                height: 50),
            Text(
              "Splatfest",
              style: TextStyle(color: Colors.grey.shade200, fontSize: 30),
            ),
            CachedNetworkImage(
                imageUrl:
                    "https://splatoon2.ink/assets/splatnet${data['images']['bravo']}",
                width: 50,
                height: 50),
          ],
        ),
        Card(
          color: Colors.grey.shade800,
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(data['names']['alpha'],
                    style: TextStyle(
                        color: winnerColor(data['alphaWin']), fontSize: 18)),
                Text(data['names']['bravo'],
                    style: TextStyle(
                        color: winnerColor(data['bravoWin']), fontSize: 18))
              ],
            ),
            CachedNetworkImage(
              imageUrl:
                  "https://splatoon2.ink/assets/splatnet${data['images']['panel']}",
            ),
          ]),
        ),
        Text("Results:",
            style: TextStyle(color: Colors.grey.shade200, fontSize: 25)),
        resultCard(data, "Votes", 'vote'),
        resultCard(data, "Regular Battles", 'solo'),
        resultCard(data, "Challenge Battles", 'challenge'),
        Text('Team ${winner(data)} won the splatfest!',
            style: TextStyle(color: Colors.grey.shade200, fontSize: 20))
      ],
    ),
  );
}

Widget resultCard(Map<String, dynamic> data, String catName, String type) {
  return Card(
    color: Colors.grey.shade800,
    child: Column(
      children: [
        Text(catName,
            style: TextStyle(color: Colors.grey.shade200, fontSize: 22)),
        SizedBox(
          width: 1000,
          child: Card(
            color: Colors.grey.shade700,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text("${percentage(data['rates'][type]['alpha'])}%",
                    style: TextStyle(
                        color: textColor(data['rates'][type]['alpha'],
                            data['rates'][type]['bravo']),
                        fontSize: 18)),
                Text("${percentage(data['rates'][type]['bravo'])}%",
                    style: TextStyle(
                        color: textColor(data['rates'][type]['bravo'],
                            data['rates'][type]['alpha']),
                        fontSize: 18))
              ],
            ),
          ),
        )
      ],
    ),
  );
}

String percentage(int value) {
  double calc = value / 100;
  return calc.toStringAsFixed(2);
}

Color textColor(int valueOne, int valueTwo) {
  if (valueOne > valueTwo) return Colors.green.shade400;
  return Colors.grey.shade200;
}

String winner(Map<String, dynamic> data) {
  if (data['alphaWin']) {
    return data['names']['alpha'];
  }
  return data['names']['bravo'];
}

Color winnerColor(bool check) {
  if (check) {
    return Colors.green.shade400;
  }
  return Colors.grey.shade200;
}
