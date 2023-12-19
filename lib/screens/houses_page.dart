// houses_page.dart

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:to_be_read_mobile/models/publisher_house.dart';
import 'package:to_be_read_mobile/widgets/house_card.dart';
import 'package:to_be_read_mobile/widgets/bottom_nav.dart';

class HousesPage extends StatelessWidget {
  Future<List<PublisherHouse>> fetchPublisherHouses() async {
    var url = Uri.parse(
        'https://web-production-fd753.up.railway.app/publisher/get-houses/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      return List<PublisherHouse>.from(
          data.map((x) => PublisherHouse.fromJson(x)));
    } else {
      throw Exception('Failed to load publisher houses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(),
      appBar: AppBar(
        title: const Text('Publisher'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: Text(
                  'Publisher Houses',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              FutureBuilder(
                future: fetchPublisherHouses(),
                builder:
                    (context, AsyncSnapshot<List<PublisherHouse>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Text('Error loading publisher houses');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Text('No publisher houses available');
                  } else {
                    return GridView.count(
                      primary: true,
                      padding: const EdgeInsets.all(20),
                      crossAxisSpacing: 20,
                      mainAxisSpacing: 20,
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      children: snapshot.data!.map((PublisherHouse house) {
                        return HouseCard(house);
                      }).toList(),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
