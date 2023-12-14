import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:to_be_read_mobile/models/quote.dart';
import 'dart:convert';
import 'package:to_be_read_mobile/models/savedbook.dart';
import 'package:to_be_read_mobile/screens/home_page.dart';
import 'package:to_be_read_mobile/widgets/bottom_nav.dart';

class MyTBReadPage extends StatefulWidget {
  const MyTBReadPage({Key? key}) : super(key: key);
  @override
  _MyTBReadPageState createState() => _MyTBReadPageState();
}

class _MyTBReadPageState extends State<MyTBReadPage> {
  final _quoteController = TextEditingController();
  //List<Map<String, dynamic>> savedBooks = []; // Replace with your data model
  Future<List<SavedBook>> fetchSavedBook() async {
      // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
       var url = Uri.parse(
        'http://127.0.0.1:8000/get_savedBook_json/');
      var response = await http.get(
          url,
          headers: {"Content-Type": "application/json"},
      );

      // melakukan decode response menjadi bentuk json
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      // melakukan konversi data json menjadi object Item
      List<SavedBook> saved_book = [];
      for (var d in data) {
          if (d != null) {
              saved_book.add(SavedBook.fromJson(d));
          }
      }
      return saved_book;
  }

    Future<List<Quote>> fetchLatestQuote() async {
      // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
       var url = Uri.parse(
        'http://127.0.0.1:8000/get-quote/');
      var response = await http.get(
          url,
          headers: {"Content-Type": "application/json"},
      );


      // melakukan decode response menjadi bentuk json
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      //Quote latest_quote = Quote.fromJson(data[data!.length]);

      // data['text'];

      // melakukan konversi data json menjadi object Item
      List<Quote> quotes = [];
      for (var d in data) {
          if (d != null) {
              quotes.add(Quote.fromJson(d));
          }
      }
      return quotes;
  }

  String _text = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    String latest_quote = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('My TBRead'),
      ),
      bottomNavigationBar: const BottomNav(),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              "Welcome to My TBRead",
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 18.0),
            FutureBuilder(
                future: fetchSavedBook(),
                builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (!snapshot.hasData) {
                      return const Column(
                        children: [
                          Text('Currently, there are no books to be read 😣', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 8),
                        ],
                      );
                    } else {
                      return GridView.builder(
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snapshot.data![index].fields.title}",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                        "${snapshot.data![index].fields.author}"),
                                    const SizedBox(height: 10),
                                    Text("${snapshot.data![index].fields.year}")
                                  ],
                                ),
                              ));
                    }
                  }
                }),
            FutureBuilder(
              future: fetchLatestQuote(), 
              builder: (context, AsyncSnapshot snapshot) {
                  if (snapshot.data == null) {
                    return const Center(child: CircularProgressIndicator());
                  } else {
                    if (!snapshot.hasData) {
                      return const Column(
                        children: [
                          Text('Your Favorite Quote!', style: TextStyle(fontSize: 18)),
                          SizedBox(height: 8),
                        ],
                      );
                    } else {
                      return ListView.builder(
                          itemCount: snapshot.data!.length,
                          itemBuilder: (_, index) => Container(
                                margin: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 12),
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _text = "${snapshot.data![snapshot.data!.length].fields.text}",
                                      style: const TextStyle(
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ));
                    }
                  }
                }),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add Your favorite Quote!'),
                        content: TextField(
                          controller: _quoteController,
                          decoration: InputDecoration(hintText: 'Enter your quote'),
                          onChanged: (String? value) {
                            setState(() {
                              _text = value!; 
                          });}
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              // add code here
                              final response = await request.postJson(
                                "http://127.0.0.1:8000/create-quote-flutter/",
                                jsonEncode(<String, String>{
                                    'text':_text,
                                    // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                }));
                              Navigator.pop(context);
                              //latest_quote = await fetchLatestQuote();
                              setState(() {
                                // Refresh the quote list after adding a new quote
                                fetchLatestQuote();
                              });
                            },
                            child: Text('Add Quote'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Add Your favorite Quote!'),
              ),
            ),
            Center(
              // Add your quote display widget here
              //child: Text('${latest_quote.fields.text}'),
            ),
            Center(
              child:ElevatedButton(
                onPressed: () {
                  // Navigate to the homepage or implement your logic
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
                },
                child: Text('Look at more books'),
              ),
            ),
          ],
        ),
      )
    );
  }
}
