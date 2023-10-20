import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splat_news/splaThree/schedules/schedule_grizz.dart';
import 'package:splat_news/splaThree/functions/functions.dart';

Widget actualGrizz(BuildContext context, Map<String, dynamic> data, int type,
    Color bg, bool soon, List<List<String>> changes, String iconLink) {
  return Card(
      elevation: 10,
      color: bg,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "",
              style: TextStyle(fontSize: 5),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Image(image: AssetImage(iconLink), width: 50, height: 50),
                Text(
                  textType(type, soon),
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 30),
                ),
                Image(image: AssetImage(iconLink), width: 50, height: 50)
              ],
            ),
            Text(
              textOccurence(type, soon),
              style: TextStyle(color: Colors.grey.shade200, fontSize: 25),
            ),
            Text(
              data['nodes'][0]['setting']['coopStage']['name'],
              style: TextStyle(color: Colors.grey.shade200, fontSize: 22),
            ),
            Text(
              'From ${dateFormat(changes[0][0])} to ${dateFormat(changes[0][1])}',
              style: TextStyle(color: Colors.grey.shade200, fontSize: 14),
            ),
            CachedNetworkImage(
              imageUrl: data['nodes'][0]['setting']['coopStage']['image']
                  ['url'],
              width: 360,
              height: 210,
            ),
            Card(
              elevation: 10,
              color: Colors.grey.shade800,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(
                    "Supplied weapons:",
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 20),
                  ),
                  for (var elements in data['nodes'][0]['setting']['weapons'])
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(" ${elements['name']}",
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 20)),
                        const Text("                   "),
                        CachedNetworkImage(
                          imageUrl: elements['image']['url'],
                          width: 90,
                          height: 90,
                        ),
                      ],
                    )
                ],
              ),
            ),
            if (type == 0)
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SchedulesGrizz(
                                content: data,
                                change: changes,
                                bigrun: soon,
                              )));
                },
                child: Card(
                  color: Colors.grey.shade800,
                  child: Text('  See what\'s next  ',
                      style:
                          TextStyle(color: Colors.grey.shade200, fontSize: 20)),
                ),
              )
          ],
        ),
      ));
}

String textType(int type, bool soon) {
  switch (type) {
    case 0:
      return "Salmon Run";
    case 1:
      if (soon) {
        return 'Eggstra Work Inkoming!';
      }
      return 'Eggstra work!';
    default:
      if (soon) {
        return 'Big Run Inkoming!';
      }
      return 'Big Run!';
  }
}

String textOccurence(int type, bool soon) {
  switch (type) {
    case 0:
      if (soon) {
        return 'Coming soon:';
      }
      return 'Actual map:';
    case 1:
      return 'Eggstra Work map:';
    default:
      return 'Big Run map:';
  }
}
