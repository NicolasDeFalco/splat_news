import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget actualGrizzGear(Map<String, dynamic> gear) {
  return Card(
    color: const Color.fromARGB(255, 201, 77, 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('Actual Gear:',
            style: TextStyle(color: Colors.grey.shade200, fontSize: 18)),
        Card(
          color: Colors.grey.shade800,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CachedNetworkImage(
                imageUrl:
                    "https://splatoon2.ink/assets/splatnet${gear['image']}",
                width: 90,
                height: 90,
              ),
              Column(
                children: [
                  Text(' ${gear['name']}  ',
                      style:
                          TextStyle(color: Colors.grey.shade200, fontSize: 16)),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('(${gear['brand']['name']})  ',
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 15)),
                        ],
                      ),
                      CachedNetworkImage(
                        imageUrl:
                            "https://splatoon2.ink/assets/splatnet${gear['brand']['image']}",
                        width: 30,
                        height: 30,
                      )
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
