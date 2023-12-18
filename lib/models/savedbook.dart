// To parse this JSON data, do
//
//     final savedBook = savedBookFromJson(jsonString);

import 'dart:convert';

List<SavedBook> savedBookFromJson(String str) => List<SavedBook>.from(json.decode(str).map((x) => SavedBook.fromJson(x)));

String savedBookToJson(List<SavedBook> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SavedBook {
    String model;
    int pk;
    Fields fields;

    SavedBook({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory SavedBook.fromJson(Map<String, dynamic> json) => SavedBook(
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
    int owner;
    int book;

    Fields({
        required this.owner,
        required this.book,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        owner: json["owner"],
        book: json["book"],
    );

    Map<String, dynamic> toJson() => {
        "owner": owner,
        "book": book,
    };
}
