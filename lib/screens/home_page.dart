import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/models/book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:to_be_read_mobile/widgets/book_card.dart';
import 'package:to_be_read_mobile/widgets/bottom_nav.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
    var response = await http.get(
      url,
      // headers: {"Content-Type": "application/json"},
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    List<Book> listBook = [];
    for (var d in data) {
      if (d != null) {
        listBook.add(Book.fromJson(d));
      }
    }
    return listBook;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Row(
      //     children: [
      //       Text('TBRead'),
      //     ],
      //   ),
      // ),
      // drawer: const LeftDrawer(),
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
                "Welcome to TBRead",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Colors.white,
                ),
                // textAlign: TextAlign.left,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "This is the home page",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 18.0),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                textInputAction: TextInputAction.go,
                onSubmitted: (value) {
                  // print(value);
                },
                decoration: const InputDecoration(
                  hintText: "Search",
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(24),
                    ),
                  ),
                ),
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
                    // const Text(
                    // "Quick Actions",
                    // style: TextStyle(
                    // fontSize: 24,
                    // fontWeight: FontWeight.w700,
                    // ),
                    // textAlign: TextAlign.left,
                    // ),
                    // const SizedBox(height: 18.0),
                    // const Row(),
                    // const SizedBox(height: 18.0),
                    const Text(
                      "Explore",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 18.0),
                    Expanded(
                      child: FutureBuilder(
                          future: fetchBooks(),
                          builder: (context, AsyncSnapshot snapshot) {
                            if (snapshot.data == null) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else {
                              if (!snapshot.hasData) {
                                return const Column(
                                  children: [
                                    Text(
                                      "Tidak ada buku.",
                                      style: TextStyle(
                                          color: Color(0xff59A5D8),
                                          fontSize: 20),
                                    ),
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
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
