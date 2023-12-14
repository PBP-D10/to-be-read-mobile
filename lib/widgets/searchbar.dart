import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_be_read_mobile/models/book.dart';

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  List<Book> allBooks = [];
  List<Book> filteredBooks = [];

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text('SearchBar'),
              const SizedBox(height: 16.0),
              SearchBar(
                controller: _controller,
                padding: const MaterialStatePropertyAll<EdgeInsets>(
                    EdgeInsets.symmetric(horizontal: 16.0)),
                hintText: 'Search',
                onChanged: (String value) {
                  filterBooks();
                },
                leading: const Icon(Icons.search),
              ),
              const SizedBox(height: 16.0),
              Text('Keyword: ${_controller.text}'),
              const SizedBox(height: 20.0),
              filteredBooks.isEmpty
                  ? const Center(child: Text('No results'))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: filteredBooks.length,
                        itemBuilder: (context, index) {
                          final book = filteredBooks[index].fields;

                          return ListTile(
                            leading: Image.network(book.imageS,
                                width: 50, height: 150, fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                              return const Icon(Icons.error);
                            }),
                            title: Text(book.title),
                            subtitle: Text(book.author),
                          );
                        },
                      ),
                    )
            ]));
  }

  @override
  void initState() {
    super.initState();
    getAllBook();
  }

  Future<void> getAllBook() async {
    String url = 'http://127.0.0.1:8000/json/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      var j = jsonEncode({});
      var response = await http.post(Uri.parse(url), headers: headers, body: j);

      if (response.statusCode == 200) {
        // success
        setState(() {
          var data = jsonDecode(utf8.decode(response.bodyBytes));
          //print(data);
          for (var u in data) {
            if (u != null) {
              allBooks.add(Book.fromJson(u));
            } else {}
          }
          filteredBooks = allBooks;
        });
      } else {
        //  error
        // ignore: avoid_print
        print('Request failed with status: ${response.statusCode}');
        // ignore: avoid_print
        print('Response: ${response.body}');
      }
    } catch (error) {
      // network or other errors
      // ignore: avoid_print
      print('Error: $error');
    }
  }

  void filterBooks() {
    setState(() {
      filteredBooks = allBooks
          .where((book) =>
              book.fields.title
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase()) ||
              book.fields.author
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase()) ||
              book.fields.isbn
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase()) ||
              book.fields.publisher
                  .toLowerCase()
                  .contains(_controller.text.toLowerCase()))
          .toList();
    });
  }
}
