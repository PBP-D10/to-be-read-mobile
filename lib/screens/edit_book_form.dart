import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:to_be_read_mobile/models/book.dart';
import 'package:to_be_read_mobile/screens/edit_book.dart';

class EditBookForm extends StatefulWidget {
  const EditBookForm({Key? key, required this.book}) : super(key: key);

  final Book book;

  @override
  State<EditBookForm> createState() => _EditBookFormState();
}

class _EditBookFormState extends State<EditBookForm> {
  late TextEditingController _isbnController;
  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _yearController;
  late TextEditingController _publisherController;
  late TextEditingController _imageSController;
  late TextEditingController _imageMController;
  late TextEditingController _imageLController;
  final _formKey = GlobalKey<FormState>();

  late Future<List<Book>> bookFuture;

  @override
  void initState() {
    super.initState();
    _isbnController = TextEditingController(text: widget.book.fields.isbn);
    _titleController = TextEditingController(text: widget.book.fields.title);
    _authorController = TextEditingController(text: widget.book.fields.author);
    _yearController =
        TextEditingController(text: widget.book.fields.year.toString());
    _publisherController =
        TextEditingController(text: widget.book.fields.publisher);
    _imageSController = TextEditingController(text: widget.book.fields.imageS);
    _imageMController = TextEditingController(text: widget.book.fields.imageM);
    _imageLController = TextEditingController(text: widget.book.fields.imageL);

    bookFuture = fetchBook();
  }

  @override
  void dispose() {
    _isbnController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _yearController.dispose();
    _publisherController.dispose();
    _imageSController.dispose();
    _imageMController.dispose();
    _imageLController.dispose();

    super.dispose();
  }

  Future<List<Book>> fetchBook() async {
    var url =
        Uri.parse('https://web-production-fd753.up.railway.app/api/books/');
    var response =
        await http.get(url, headers: {"content-type": "application/json"});
    var data = jsonDecode(response.body);

    List<Book> books = [];

    for (var bookData in data) {
      books.add(Book.fromJson(bookData));
    }

    return books;
  }

  Future<void> refreshBookData() async {
    try {
      if (mounted) {
        var books = await fetchBook();
        if (mounted && books.isNotEmpty) {
          setState(() {
            widget.book.fields = books.first.fields;
          });
        }
      }
    } catch (error) {
      // Handle any unexpected errors here
      if (mounted) {
        print('Error during refreshBookData(): $error');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Books'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: FutureBuilder<List<Book>>(
                future: bookFuture,
                builder: (context, AsyncSnapshot<List<Book>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('No books found.');
                  } else {
                    Book? book = snapshot.data!.firstWhere(
                      (b) => b.pk == widget.book.pk,
                      orElse: () => widget.book,
                    );
                    return _buildEditBookForm(book, request);
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditBookForm(Book? book, CookieRequest request) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TextFormField(
              controller: _isbnController,
              decoration: const InputDecoration(
                labelText: 'ISBN',
                contentPadding: EdgeInsets.only(bottom: 8.0),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                contentPadding: EdgeInsets.only(bottom: 8.0),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _authorController,
              decoration: const InputDecoration(
                labelText: 'Author',
                contentPadding: EdgeInsets.only(bottom: 8.0),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _yearController,
              decoration: const InputDecoration(
                labelText: 'Year',
                contentPadding: EdgeInsets.only(bottom: 8.0),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _publisherController,
              decoration: const InputDecoration(
                labelText: 'Publisher',
                contentPadding: EdgeInsets.only(bottom: 8.0),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageSController,
              decoration: const InputDecoration(
                labelText: 'Image Small',
                contentPadding: EdgeInsets.only(bottom: 8.0),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageMController,
              decoration: const InputDecoration(
                labelText: 'Image Medium',
                contentPadding: EdgeInsets.only(bottom: 8.0),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _imageLController,
              decoration: const InputDecoration(
                labelText: 'Image Large',
                contentPadding: EdgeInsets.only(bottom: 8.0),
              ),
            ),
            const SizedBox(height: 36),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    if (mounted) {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    backgroundColor: Colors.red,
                  ),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    if (mounted && _formKey.currentState!.validate()) {
                      final response = await request.postJson(
                        'https://web-production-fd753.up.railway.app/publisher/edit-book-flutter/${widget.book.pk}',
                        jsonEncode(<String, String>{
                          "ISBN": _isbnController.text,
                          "title": _titleController.text,
                          "author": _authorController.text,
                          "year": _yearController.text,
                          'publisher': _publisherController.text,
                          'image_s': _imageSController.text,
                          'image_m': _imageMController.text,
                          'image_l': _imageLController.text,
                        }),
                      );
                      if (mounted) {
                        if (response['status'] == 'success') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Book updated successfully!'),
                            ),
                          );

                          setState(() {
                            refreshBookData();
                          });
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EditBookPage(),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Error updating book. Please check logs for details.'),
                            ),
                          );
                        }
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                  child: const Text('Save Changes', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
