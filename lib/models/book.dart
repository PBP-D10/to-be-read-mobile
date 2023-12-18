// To parse this JSON data, do
//
//     final book = bookFromJson(jsonString);

import 'dart:convert';

Book bookFromJson(String str) => Book.fromJson(json.decode(str));

String bookToJson(Book data) => json.encode(data.toJson());

class Book {
  String model;
  int pk;
  Fields fields;

  Book({
    required this.model,
    required this.pk,
    required this.fields,
  });

  factory Book.fromJson(Map<String, dynamic> json) => Book(
        model: json["model"],
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
      );

  Map<String, dynamic> toJson() => {
        "model": model,
        "pk": pk,
        "fields": fields.toJson(),
      };
}

class Fields {
  String isbn;
  String title;
  String author;
  int year;
  String publisher;
  String imageS;
  String imageM;
  String imageL;
  DateTime dateAdded;

  Fields({
    required this.isbn,
    required this.title,
    required this.author,
    required this.year,
    required this.publisher,
    required this.imageS,
    required this.imageM,
    required this.imageL,
    required this.dateAdded,
  });

  factory Fields.fromJson(Map<String, dynamic> json) => Fields(

/*
        isbn: json["ISBN"],
        title: json["title"],
        author: json["author"],
        year: json["year"],
        publisher: json["publisher"],
        imageS: json["image_s"],
        imageM: json["image_m"],
        imageL: json["image_l"],
        dateAdded: DateTime.parse(json["date_added"]),
        */
        // handle null value (terutama untuk image kalo linknya gak dikasih)
        isbn: json["ISBN"] ?? "",
        title: json["title"] ?? "",
        author: json["author"] ?? "",
        year: json["year"] ?? -1,
        publisher: json["publisher"] ?? "",
        imageS: json["image_s"] ?? "",
        imageM: json["image_m"] ?? "",
        imageL: json["image_l"] ?? "",
        dateAdded: DateTime.parse(json["date_added"]),
      );

  Map<String, dynamic> toJson() => {
        "ISBN": isbn,
        "title": title,
        "author": author,
        "year": year,
        "publisher": publisher,
        "image_s": imageS,
        "image_m": imageM,
        "image_l": imageL,
        "date_added": dateAdded.toIso8601String(),
      };
}
