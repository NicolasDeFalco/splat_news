import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:splat_news/splaThree/schedules/schedule_rank.dart';
import 'package:splat_news/functions/functions.dart';

Widget actualRank(BuildContext context, Map<String, dynamic> data, int position,
    List<List<String>> mapChange) {
  return Card(
      color: const Color.fromARGB(255, 224, 67, 18),
      elevation: 10,
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text("         "),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                const Image(
                  image: AssetImage('assets/logo/Ranked.png'),
                  width: 50,
                  height: 50,
                ),
                Text(
                  typeName(position),
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 30),
                ),
                const Image(
                    image: AssetImage('assets/logo/Ranked.png'),
                    width: 50,
                    height: 50)
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/logo/S3/${data['nodes'][0]['bankaraMatchSettings'][position]['vsRule']['rule']}.png',
                  width: 50,
                  height: 50,
                ),
                Text(
                  "${data['nodes'][0]['bankaraMatchSettings'][position]['vsRule']['name']}",
                  style: TextStyle(color: Colors.grey.shade800, fontSize: 22),
                ),
                Image.asset(
                  'assets/logo/S3/${data['nodes'][0]['bankaraMatchSettings'][position]['vsRule']['rule']}.png',
                  width: 50,
                  height: 50,
                ),
              ],
            ),
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
                  for (var elements in data['nodes'][0]['bankaraMatchSettings']
                      [position]['vsStages'])
                    Column(
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
                        builder: (context) => SchedulesRank(
                              content: data,
                              mapChange: mapChange,
                              rankType: position,
                              type: typeName(position),
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

String typeName(int nmb) {
  switch (nmb) {
    case 0:
      return 'Anarchy Battle Series';
    default:
      return 'Anarchy Battle Open';
  }
}
