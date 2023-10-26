import 'package:cached_network_image/cached_network_image.dart';
import 'package:splat_news/functions/functions.dart';
import 'package:flutter/material.dart';

Widget splatfestResultCard(BuildContext context, Map<String, dynamic> data) {
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
              "Splatfest",
              style: TextStyle(color: Colors.grey.shade200, fontSize: 30),
            ),
            const Image(
                image: AssetImage('assets/logo/S3/Tricolor.png'),
                width: 50,
                height: 50)
          ],
        ),
        Text(
          'From ${dateFormat(DateTime.parse(data['startTime']).toLocal().toString())} to ${dateFormat(DateTime.parse(data['endTime']).toLocal().toString())}',
          style: TextStyle(color: Colors.grey.shade200, fontSize: 14),
        ),
        Card(
          color: Colors.grey.shade800,
          child: Column(children: [
            Text(
              data['title'].replaceAll(RegExp('Ã©'), 'é'),
              style: TextStyle(color: Colors.grey.shade200, fontSize: 20),
            ),
            CachedNetworkImage(
              imageUrl: data['image']['url'],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                for (var team in data['teams'])
                  Text(team['teamName'],
                      style: TextStyle(
                          color: textColor(team['result']['isWinner']),
                          fontSize: 18))
              ],
            ),
          ]),
        ),
        Text("Results:",
            style: TextStyle(color: Colors.grey.shade200, fontSize: 25)),
        resultCard(data, "Conch Shells", 'horagaiRatio', 'isHoragaiRatioTop'),
        resultCard(data, "Votes", 'voteRatio', 'isVoteRatioTop'),
        resultCard(data, "Open Battles", 'regularContributionRatio',
            'isRegularContributionRatioTop'),
        resultCard(data, "Challenge Battles", 'challengeContributionRatio',
            'isChallengeContributionRatioTop'),
        if (data['teams'][0]['result']['tricolorContributionRatio'] != null)
          resultCard(data, "Tricolor Battles", 'tricolorContributionRatio',
              'isTricolorContributionRatioTop'),
        for (var team in data['teams'])
          if (team['result']['isWinner'])
            Text('Team ${team['teamName']} won the splatfest!',
                style: TextStyle(color: Colors.grey.shade200, fontSize: 20))
      ],
    ),
  );
}

Widget resultCard(Map<String, dynamic> data, String catName, String ratioName,
    String boolName) {
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
                for (var team in data['teams'])
                  Text(percentage(team['result'][ratioName]),
                      style: TextStyle(
                          color: textColor(team['result'][boolName]),
                          fontSize: 18))
              ],
            ),
          ),
        )
      ],
    ),
  );
}

String percentage(double value) {
  double calc = value * 100;
  return calc.toStringAsFixed(2);
}

Color textColor(bool checker) {
  if (checker) return Colors.green.shade400;
  return Colors.grey.shade200;
}
