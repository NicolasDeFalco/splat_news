import 'package:flutter/material.dart';
import 'package:splat_news/functions/functions.dart';
import '../schedules/schedules.dart';
import 'package:cached_network_image/cached_network_image.dart';

Widget actual(BuildContext context, Map<String, dynamic> data, Color bgColor,
    String type, List<List<String>> mapChange, String iconLink) {
  return Card(
      elevation: 10,
      color: bgColor,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("         "),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Image(
                  image: AssetImage(iconLink),
                  width: 50,
                  height: 50,
                ),
                Text(
                  battleType(type),
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 30),
                ),
                Image(image: AssetImage(iconLink), width: 50, height: 50)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/S2/${data[type][0]['rule']['key']}.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  data[type][0]['rule']['name'].toString(),
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 20),
                ),
                Image.asset(
                  'assets/logo/S2/${data[type][0]['rule']['key']}.png',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
            Text(
                "${timeConvert(mapChange[0][0].substring(11, 13))} to ${timeConvert(mapChange[0][1].substring(11, 13))}"),
            const Text("Actual rotation:", style: TextStyle(fontSize: 20)),
            Card(
              elevation: 10,
              color: Colors.grey.shade800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(data[type][0]['stage_a']['name'],
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 15)),
                      CachedNetworkImage(
                        imageUrl:
                            "https://splatoon2.ink/assets/splatnet/${data[type][0]['stage_a']['image']}",
                        width: 180,
                        height: 110,
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(data[type][0]['stage_b']['name'],
                          style: TextStyle(
                              color: Colors.grey.shade200, fontSize: 15)),
                      CachedNetworkImage(
                        imageUrl:
                            "https://splatoon2.ink/assets/splatnet/${data[type][0]['stage_b']['image']}",
                        width: 180,
                        height: 110,
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => SchedulesTwo(
                              background: bgColor,
                              data: data,
                              mapChange: mapChange,
                              type: battleType(type),
                              picLink: iconLink,
                              typeLink: type,
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

String battleType(String type) {
  switch (type) {
    case 'regular':
      return 'Regular Battle';
    case 'gachi':
      return 'Ranked Battle';
    default:
      return 'League Battle';
  }
}
