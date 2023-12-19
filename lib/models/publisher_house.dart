// To parse this JSON data, do
//
//     final publisherHouse = publisherHouseFromJson(jsonString);

import 'dart:convert';

List<PublisherHouse> publisherHouseFromJson(String str) => List<PublisherHouse>.from(json.decode(str).map((x) => PublisherHouse.fromJson(x)));

String publisherHouseToJson(List<PublisherHouse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PublisherHouse {
    String name;
    int yearEstablished;

    PublisherHouse({
        required this.name,
        required this.yearEstablished,
    });

    factory PublisherHouse.fromJson(Map<String, dynamic> json) => PublisherHouse(
        name: json["name"],
        yearEstablished: json["year_established"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "year_established": yearEstablished,
    };
}// To parse this JSON data, do
//
//     final publisherHouse = publisherHouseFromJson(jsonString);

import 'dart:convert';

List<PublisherHouse> publisherHouseFromJson(String str) => List<PublisherHouse>.from(json.decode(str).map((x) => PublisherHouse.fromJson(x)));

String publisherHouseToJson(List<PublisherHouse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PublisherHouse {
    String name;
    int yearEstablished;

    PublisherHouse({
        required this.name,
        required this.yearEstablished,
    });

    factory PublisherHouse.fromJson(Map<String, dynamic> json) => PublisherHouse(
        name: json["name"],
        yearEstablished: json["year_established"],
    );

    Map<String, dynamic> toJson() => {
        "name": name,
        "year_established": yearEstablished,
    };
}
