import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:to_be_read_mobile/screens/home_page.dart';
import 'dart:convert';

import 'package:to_be_read_mobile/widgets/book_card.dart';

// make stateful widget called SearchPage
// ignore: must_be_immutable
class SearchPage extends StatefulWidget {
  final String query;
  const SearchPage({Key? key, required this.query}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late FocusNode _focusNode;

  List<Book> allBooks = [];
  List<Book> filteredBooks = [];

  final TextEditingController _textFieldController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _textFieldController.text = widget.query;
    getAllBooks();
    // filterBooks(widget.query);

    _focusNode = FocusNode();
    // Set a delay to ensure that the keyboard is displayed after a short delay
    Future.delayed(Duration.zero, () {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _textFieldController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void getAllBooks() async {
    var url =
        Uri.parse('https://web-production-fd753.up.railway.app/api/books/');
    var response = await http.get(url);

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    // melakukan konversi data json menjadi object Product
    allBooks = [];
    for (var d in data) {
      if (d != null) {
        allBooks.add(Book.fromJson(d));
      }
    }
    // filteredBooks = allBooks;
    filterBooks(widget.query);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            const Text("Pencarian Buku", style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white, // Change the color of the back button icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      // bottomNavigationBar: const BottomNav(),
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Search Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: TextField(
                focusNode: _focusNode,
                controller: _textFieldController,
                textInputAction: TextInputAction.go,
                onChanged: (value) {
                  filterBooks(value);
                },
                decoration: const InputDecoration(
                  hintText:
                      "Cari buku berdasarkan judul, penulis, penerbit, atau ISBN",
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
                    const Text(
                      "Hasil Pencarian",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                      textAlign: TextAlign.left,
                    ),
                    const SizedBox(height: 18.0),
                    Expanded(
                        child: filteredBooks.isEmpty
                            ? const Center(
                                child: Text(
                                "Tidak ada buku.",
                                style: TextStyle(
                                    color: Color(0xff59A5D8), fontSize: 20),
                              ))
                            : ListView.builder(
                                itemCount: filteredBooks.length,
                                itemBuilder: (_, index) =>
                                    BookCard(book: filteredBooks[index]))),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void filterBooks(String keyword) {
    setState(() {
      filteredBooks = allBooks
          .where((book) =>
              book.fields.title.toLowerCase().contains(keyword.toLowerCase()) ||
              book.fields.author
                  .toLowerCase()
                  .contains(keyword.toLowerCase()) ||
              book.fields.isbn.toLowerCase().contains(keyword.toLowerCase()) ||
              book.fields.publisher
                  .toLowerCase()
                  .contains(keyword.toLowerCase()))
          .toList();
    });
  }
}
