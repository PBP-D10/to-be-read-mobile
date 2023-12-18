// To parse this JSON data, do
//
//     final quote = quoteFromJson(jsonString);

import 'dart:convert';

List<Quote> quoteFromJson(String str) => List<Quote>.from(json.decode(str).map((x) => Quote.fromJson(x)));

String quoteToJson(List<Quote> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Quote {
    Model model;
    int pk;
    Fields fields;

    Quote({
        required this.model,
        required this.pk,
        required this.fields,
    });

    factory Quote.fromJson(Map<String, dynamic> json) => Quote(
        model: modelValues.map[json["model"]]!,
        pk: json["pk"],
        fields: Fields.fromJson(json["fields"]),
    );

    Map<String, dynamic> toJson() => {
        "model": modelValues.reverse[model],
        "pk": pk,
        "fields": fields.toJson(),
    };
}

class Fields {
    String text;

    Fields({
        required this.text,
    });

    factory Fields.fromJson(Map<String, dynamic> json) => Fields(
        text: json["text"],
    );

    Map<String, dynamic> toJson() => {
        "text": text,
    };
}

enum Model {
    READER_QUOTE
}

final modelValues = EnumValues({
    "reader.quote": Model.READER_QUOTE
});

class EnumValues<T> {
    Map<String, T> map;
    late Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        reverseMap = map.map((k, v) => MapEntry(v, k));
        return reverseMap;
    }
}
