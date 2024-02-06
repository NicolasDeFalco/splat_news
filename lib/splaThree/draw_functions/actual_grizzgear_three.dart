import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget actualGrizzGear(Map<String, dynamic> gear) {
  return Card(
    color: Color.fromARGB(255, 201, 77, 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Text('This month\'s Gear:',
            style: TextStyle(color: Colors.grey.shade200, fontSize: 17)),
        Card(
          color: Colors.grey.shade800,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CachedNetworkImage(
                imageUrl: gear['image']['url'],
                width: 90,
                height: 90,
              ),
              Column(
                children: [
                  Text('${gear['name']}  ',
                      style:
                          TextStyle(color: Colors.grey.shade200, fontSize: 15)),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('(Grizzco)  ',
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 14)),
                        ],
                      ),
                      Image.asset(
                        'assets/logo/S3/grizzco.png',
                        width: 30,
                        height: 30,
                      ),
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
