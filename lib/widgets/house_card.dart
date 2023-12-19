// house_card.dart

import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/models/publisher_house.dart';

class HouseCard extends StatelessWidget {
  final PublisherHouse house;

  HouseCard(this.house);

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
            Icon(
              Icons.business, // Replace with your desired icon
              size: 30,
              color: Colors.blueGrey,
            ),
            SizedBox(height: 8),
            Text(
              house.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Est. ${house.yearEstablished}',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}// house_card.dart

import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/models/publisher_house.dart';

class HouseCard extends StatelessWidget {
  final PublisherHouse house;

  HouseCard(this.house);

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
            Icon(
              Icons.business, // Replace with your desired icon
              size: 30,
              color: Colors.blueGrey,
            ),
            SizedBox(height: 8),
            Text(
              house.name,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Est. ${house.yearEstablished}',
              style: TextStyle(
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
