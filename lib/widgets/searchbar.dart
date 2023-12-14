import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class SearchBarApp extends StatefulWidget {
  const SearchBarApp({super.key});

  @override
  State<SearchBarApp> createState() => _SearchBarAppState();
}

class _SearchBarAppState extends State<SearchBarApp> {
  List<dynamic> _searchResults = [];

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
                  getBookWithKeyword();
                },
                leading: const Icon(Icons.search),
              ),
              const SizedBox(height: 16.0),
              Text('Keyword: ${_controller.text}'),
              const SizedBox(height: 20.0),
              _searchResults.isEmpty
                  ? const Center(child: Text('No results'))
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final book = _searchResults[index]['fields'];

                          return ListTile(
                            leading: Image.network(book['image_s'],
                                width: 50, height: 150, fit: BoxFit.cover,
                                errorBuilder: (BuildContext context,
                                    Object exception, StackTrace? stackTrace) {
                              return const Icon(Icons.error);
                            }),
                            title: Text(book['title']),
                            subtitle: Text(book['author']),
                          );
                        },
                      ),
                    )
            ]));
  }

  Future<void> getBookWithKeyword() async {
    String url = 'http://127.0.0.1:8000/json/';
    Map<String, String> headers = {
      'Content-Type': 'application/json; charset=UTF-8',
    };

    try {
      print('value: ${_controller.text}');

     // var j = jsonEncode(<String, String>{'keyword': _controller.text});
      var j = jsonEncode({'keyword': _controller.text});
      print(j);

      var response = await http.post(Uri.parse(url), headers: headers, body:j);

     // var hasil = jsonDecode(utf8.decode(response.bodyBytes));
      var hasil = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // success
        print('Request sent successfully');
        setState(() {
          // _searchResults = json.decode(response.body);
          var utf = utf8.decode(response.bodyBytes);
          //print(utf);

          _searchResults = jsonDecode(utf);
          //print(_searchResults);
        });
      } else {
        //  error
        print('Request failed with status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (error) {
      // network or other errors
      print('Error: $error');
    }
  }
}
