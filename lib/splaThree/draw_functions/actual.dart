import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:splat_news/splaThree/schedules/schedules.dart';
import 'package:splat_news/splaThree/functions/functions.dart';

Widget actual(BuildContext context, Map<String, dynamic> data, String name,
    List<List<String>> mapChange, bool fest, Color bgColor, String iconLink) {
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
                  typeName(name),
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 30),
                ),
                Image(image: AssetImage(iconLink), width: 50, height: 50)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/S3/${data['nodes'][0][name]['vsRule']['rule']}.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  "${data['nodes'][0][name]['vsRule']['name']}",
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 22),
                ),
                Image.asset(
                  'assets/logo/S3/${data['nodes'][0][name]['vsRule']['rule']}.png',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
            /*Text(
                        "(${turf['vsRule']['name'].toString()})",
                        style: TextStyle(
                            color: Colors.grey.shade800, fontSize: 20),
                      ),*/

            Text(
                "${timeConvert(mapChange[0][0].substring(11, 13))} to ${timeConvert(mapChange[0][1].substring(11, 13))}"),
            Text("Actual rotation:",
                style: TextStyle(color: Colors.grey.shade800, fontSize: 16)),
            Card(
              elevation: 10,
              color: Colors.grey.shade800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var elements in data['nodes'][0][name]['vsStages'])
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(elements['name'],
                            style: TextStyle(
                                color: Colors.grey.shade200, fontSize: 15)),
                        CachedNetworkImage(
                          imageUrl: elements['image']['url'],
                          width: 180,
                          height: 110,
                        ),
                      ],
                    )
                ],
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Schedules(
                              background: bgColor,
                              content: data,
                              mapChange: mapChange,
                              type: typeName(name),
                              picLink: iconLink,
                              typeCode: name,
                              fest: fest,
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

String typeName(String type) {
  switch (type) {
    case 'regularMatchSetting':
      return 'Regular Battle';
    case 'xMatchSetting':
      return 'X Battle';
    default:
      return 'Fest Battle';
  }
}
