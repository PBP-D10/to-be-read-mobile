import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:to_be_read_mobile/models/book.dart';
import 'package:to_be_read_mobile/models/quote.dart';
import 'dart:convert';
import 'package:to_be_read_mobile/models/savedbook.dart';
// import 'package:to_be_read_mobile/screens/home_page.dart';
import 'package:to_be_read_mobile/widgets/book_card.dart';
import 'package:to_be_read_mobile/widgets/bottom_nav.dart';

class MyTBReadPage extends StatefulWidget {
  const MyTBReadPage({super.key});

  @override
  State<MyTBReadPage> createState() => _MyTBReadPageState();
}

class _MyTBReadPageState extends State<MyTBReadPage> {
  Future<List<Book>> fetchSavedBook() async {
    var url = Uri.parse('http://127.0.0.1:8000/get_savedBook_json');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Book> savedBook = [];
    for (var d in data) {
      if (d != null) {
        var theUrl = Uri.parse(
            'http://127.0.0.1:8000/book_by_id/${SavedBook.fromJson(d).fields.book}/');
        var theResponse = await http.get(
          theUrl,
          headers: {"Content-Type": "application/json"},
        );
        var theBook = jsonDecode(utf8.decode(theResponse.bodyBytes));
        savedBook.add(Book.fromJson(theBook[0]));
      }
    }
    return savedBook;
  }

  Future<List<Quote>> fetchLatestQuote() async {
    var url = Uri.parse('http://127.0.0.1:8000/get-quote/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Item
    List<Quote> quotes = [];
    for (var d in data) {
      if (d != null) {
        quotes.add(Quote.fromJson(d));
      }
    }
    return quotes;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String _quote = '';
    String shownQuote = '';
    return Scaffold(
        bottomNavigationBar: const BottomNav(),
        body: Container(
            color: Theme.of(context).colorScheme.primary,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Padding(
                    padding: EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 0),
                    child: Text(
                      "Welcome to My TBRead",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      // textAlign: TextAlign.left,
                    ),
                  ),
                  const SizedBox(height: 32.0),
                  Expanded(
                      child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.background,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder(
                            future: fetchLatestQuote(),
                            builder: (context, AsyncSnapshot snapshot) {
                              if (snapshot.data == null) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else {
                                if (!snapshot.hasData) {
                                  shownQuote = 'Insert your favorite Quote!';
                                } else {
                                  shownQuote =
                                      ' " ${snapshot.data![snapshot.data!.length - 1].fields.text} " ';
                                }
                                return Center(
                                    child: InkWell(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text(
                                              'Add Your favorite Quote!'),
                                          content: TextFormField(
                                              decoration: InputDecoration(
                                                hintText: 'Enter your quote',
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          5.0),
                                                ),
                                              ),
                                              onChanged: (String? value) {
                                                setState(() {
                                                  _quote = value!;
                                                  shownQuote = _quote;
                                                });
                                              }),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () async {
                                                // add code here
                                                final response =
                                                    await request.postJson(
                                                        "http://127.0.0.1:8000/create-quote-flutter/",
                                                        jsonEncode(<String,
                                                            String>{
                                                          'text': _quote,
                                                        }));
                                                if (response.statusCode ==
                                                    200) {
                                                  if (context.mounted) {
                                                    Navigator.pop(context);
                                                    Navigator.pushReplacement(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) =>
                                                                const MyTBReadPage()));
                                                  }
                                                } else {
                                                  if (context.mounted) {
                                                    ScaffoldMessenger.of(
                                                        context)
                                                      ..hideCurrentSnackBar()
                                                      ..showSnackBar(const SnackBar(
                                                          content: Text(
                                                              "Failed to add quote!")));
                                                  }
                                                }
                                              },
                                              child: const Text('Add Quote'),
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  child: Text(
                                    shownQuote,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                                    //]
                                    );
                              }
                            }),
                        const SizedBox(height: 18.0),
                        Expanded(
                          child: FutureBuilder(
                              future: fetchSavedBook(),
                              builder: (context, AsyncSnapshot snapshot) {
                                if (snapshot.data == null) {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                } else {
                                  if (!snapshot.hasData) {
                                    return const Column(
                                      children: [
                                        Text(
                                            'Currently, there are no books to be read 😣',
                                            style: TextStyle(
                                                fontSize: 18,
                                                color: Color(0xff59A5D8))),
                                        SizedBox(height: 8),
                                      ],
                                    );
                                  } else {
                                    return ListView.builder(
                                      itemCount: snapshot.data!.length,
                                      itemBuilder: (_, index) =>
                                          BookCard(book: snapshot.data![index]),
                                    );
                                  }
                                }
                              }),
                        ),
                      ],
                    ),
                  ))
                ])));
  }
}