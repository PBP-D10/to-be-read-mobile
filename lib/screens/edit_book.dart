import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:to_be_read_mobile/models/book.dart';
import 'package:to_be_read_mobile/screens/home_page.dart';

class EditBookCard extends StatelessWidget {
  final Book book;

  const EditBookCard({
    required this.book,
    Key? key,
  }) : super(key: key);

  Future<void> deleteBook(BuildContext context, int bookId) async {
    var url = Uri.parse('http://127.0.0.1:8000/publisher/delete/$bookId/');
    try {
      var response = await http.delete(url);

      if (response.statusCode == 200) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book deleted successfully')));
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                );
        // Optionally, refresh the list or navigate back
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to delete the book')));
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 120,
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: NetworkImage(book.fields.imageL),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    book.fields.title,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text("${book.fields.author}, ${book.fields.year}"),
                  const SizedBox(height: 10),
                  Text(book.fields.publisher),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // ElevatedButton(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => EditBookForm(book: book),
                //       ),
                //     );
                //   },
                //   child: const Text('Edit'),
                // ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () async {
                    deleteBook(context, book.pk);
                  },
                  child: const Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditBookPage extends StatelessWidget {
  const EditBookPage({Key? key}) : super(key: key);

  Future<List<Book>> fetchBooks() async {
    var url = Uri.parse('http://127.0.0.1:8000/api/books/');
    var response = await http.get(url);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    List<Book> listBook = [];
    for (var d in data) {
      if (d != null) {
        listBook.add(Book.fromJson(d));
      }
    }
    return listBook;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Books'),
      ),
      body: FutureBuilder(
        future: fetchBooks(),
        builder: (context, AsyncSnapshot<List<Book>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No books available for editing.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return EditBookCard(book: snapshot.data![index]);
              },
            );
          }
        },
      ),
    );
  }
}
