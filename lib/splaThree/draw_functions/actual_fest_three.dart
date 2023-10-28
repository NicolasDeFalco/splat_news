import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:splat_news/splaThree/schedules/schedule_fest.dart';
import 'package:splat_news/functions/functions.dart';

Widget actualFest(BuildContext context, Map<String, dynamic> data, String name,
    List<List<String>> mapChange, int index) {
  return Card(
      elevation: 10,
      color: Colors.black,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("         "),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Image(
                  image: AssetImage('assets/logo/S3/Tricolor.png'),
                  width: 50,
                  height: 50,
                ),
                Text(
                  name,
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 25),
                ),
                const Image(
                    image: AssetImage('assets/logo/S3/Tricolor.png'),
                    width: 50,
                    height: 50)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/S3/${data['nodes'][0]['festMatchSettings'][index]['vsRule']['rule']}.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  "${data['nodes'][0]['festMatchSettings'][index]['vsRule']['name']}",
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 22),
                ),
                Image.asset(
                  'assets/logo/S3/${data['nodes'][0]['festMatchSettings'][index]['vsRule']['rule']}.png',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
            Text(
                "${timeConvert(mapChange[0][0].substring(11, 13))} to ${timeConvert(mapChange[0][1].substring(11, 13))}",
                style: TextStyle(color: Colors.grey.shade200, fontSize: 16)),
            Text("Actual rotation:",
                style: TextStyle(color: Colors.grey.shade200, fontSize: 16)),
            Card(
              elevation: 10,
              color: Colors.grey.shade800,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  for (var elements in data['nodes'][0]['festMatchSettings']
                      [index]['vsStages'])
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
                        builder: (context) => SchedulesFest(
                              content: data,
                              mapChange: mapChange,
                              picLink: 'assets/logo/S3/Tricolor.png',
                              index: index,
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
