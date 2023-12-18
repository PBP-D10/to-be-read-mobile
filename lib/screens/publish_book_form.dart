import 'package:flutter/material.dart';
// import 'package:lembarpena/AdminRegisterBook/widgets/admin_left_drawer.dart';
// import 'package:lembarpena/AdminRegisterBook/screens/admin_menu.dart';
import 'package:to_be_read_mobile/screens/home_page.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'dart:convert';

class BookFormPage extends StatefulWidget {
  const BookFormPage({super.key});

  @override
  State<BookFormPage> createState() => _BookFormPageState();
}

class _BookFormPageState extends State<BookFormPage> {
  final _formKey = GlobalKey<FormState>();
  String _isbn = "";
  String _title = "";
  String _author = "";
  int _year = 0;
  String _publisher = "";
  String _imageS = "";
  String _imageM = "";
  String _imageL = "";

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register Your Book',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.indigo.shade900,
      ),
      //drawer: const LeftDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "ISBN",
                    labelText: "ISBN",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _isbn = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "ISBN cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Title",
                    labelText: "Title",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _title = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Title cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Author",
                    labelText: "Author",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _author = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Author cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Year",
                    labelText: "Year",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) => _year = int.tryParse(value) ?? 0,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Year cannot be empty!";
                    }
                    if (int.tryParse(value) == null) {
                      return "Year must be a valid integer!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Publisher",
                    labelText: "Publisher",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _publisher = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Publisher cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Image S",
                    labelText: "Image S",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _imageS = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Image S cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Image M",
                    labelText: "Image M",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _imageM = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Image M cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: "Image L",
                    labelText: "Image L",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) => _imageL = value,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Image L cannot be empty!";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 12.0),
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final response = await request.postJson(
                            "http://127.0.0.1:8000/publisher/create-book-flutter/",
                            jsonEncode(<String, dynamic>{
                              'ISBN': _isbn,
                              'title': _title,
                              'author': _author,
                              'year': _year.toString(),
                              'publisher': _publisher,
                              'image_s': _imageS,
                              'image_m': _imageM,
                              'image_l': _imageL,
                            }),
                          );
                          if (response['status'] == 'success') {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("New book has been saved!"),
                              ),
                            );
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => HomePage()),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("ERROR, please try again!"),
                              ),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("Network error: $e"),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      "Save",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
