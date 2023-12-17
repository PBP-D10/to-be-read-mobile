// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

// ignore_for_file: prefer_if_null_operators

import 'dart:convert';

List<Profile> profileFromJson(String str) => List<Profile>.from(json.decode(str).map((x) => Profile.fromJson(x)));

String profileToJson(List<Profile> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Profile {
    String model;
    int pk;
    Fields fields;

    Profile({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
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
    int user;
    String name;
    String email;
    String? address;
    DateTime? dateOfBirth;

    Fields({
        required this.user,
        required this.name,
        required this.email,
        required this.address,
        required this.dateOfBirth,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
      user: json["user"],
      name: json["name"],
      email: json["email"],
      address: json["address"] != null 
          ? json["address"] 
          : "-",
      dateOfBirth: json["date_of_birth"] != null
          ? DateTime.parse(json["date_of_birth"])
          : null,
    );

Map<String, dynamic> toJson() => {
      "user": user,
      "name": name,
      "email": email,
      "address": address,
      "date_of_birth": dateOfBirth != null
          ? "${dateOfBirth?.year.toString().padLeft(4, '0')}-${dateOfBirth?.month.toString().padLeft(2, '0')}-${dateOfBirth?.day.toString().padLeft(2, '0')}"
          : null,
    };

}
