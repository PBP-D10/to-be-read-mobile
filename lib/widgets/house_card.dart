// house_card.dart

import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/models/publisher_house.dart';


class HouseCard extends StatelessWidget {
  final PublisherHouse house;

  const HouseCard(this.house, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.business, // Replace with your desired icon
              size: 30,
              color: Colors.blueGrey,
            ),
            const SizedBox(height: 8),
            Text(
              house.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Est. ${house.yearEstablished}',
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
