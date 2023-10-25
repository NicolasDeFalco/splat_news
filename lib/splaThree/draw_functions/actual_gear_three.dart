import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

Widget actualGear(Map<String, dynamic> data) {
  return Card(
      color: Colors.black,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              CachedNetworkImage(
                imageUrl: data['gear']['image']['url'],
                width: 90,
                height: 90,
              ),
              Column(
                children: [
                  Text('${data['gear']['name']}  ',
                      style:
                          TextStyle(color: Colors.grey.shade200, fontSize: 25)),
                  Row(
                    children: [
                      Column(
                        children: [
                          Text('(${data['gear']['brand']['name']})  ',
                              style: TextStyle(
                                  color: Colors.grey.shade200, fontSize: 20)),
                        ],
                      ),
                      CachedNetworkImage(
                        imageUrl: data['gear']['brand']['image']['url'],
                        width: 30,
                        height: 30,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Main gear power: ${data['gear']['primaryGearPower']['name']}',
                  style: TextStyle(color: Colors.grey.shade200, fontSize: 18)),
              CachedNetworkImage(
                imageUrl: data['gear']['primaryGearPower']['image']['url'],
                width: 30,
                height: 30,
              )
            ],
          ),
          Card(
            color: Colors.grey.shade400,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Column(
                  children: [
                    Text('Gear powers: ',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    Row(
                      children: [
                        SizedBox.fromSize(
                          size: const Size(40, 40),
                          child: ClipOval(
                              child: Material(
                            color: Colors.black,
                            child: CachedNetworkImage(
                              imageUrl: data['gear']['primaryGearPower']
                                  ['image']['url'],
                            ),
                          )),
                        ),
                        for (var power in data['gear']['additionalGearPowers'])
                          SizedBox.fromSize(
                            size: const Size(30, 30),
                            child: ClipOval(
                                child: Material(
                              color: Colors.black,
                              child: CachedNetworkImage(
                                imageUrl: power['image']['url'],
                              ),
                            )),
                          ),
                      ],
                    ),
                  ],
                ),
                Column(
                  children: [
                    const Text('Price:',
                        style: TextStyle(color: Colors.black, fontSize: 18)),
                    Text(data['price'].toString(),
                        style: TextStyle(color: Colors.black, fontSize: 16))
                  ],
                )
              ],
            ),
          )
        ],
      ));
}
