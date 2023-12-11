import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:to_be_read_mobile/models/savedbook.dart';

class MyTBReadPage extends StatefulWidget {
  const MyTBReadPage({Key? key}) : super(key: key);
  @override
  _MyTBReadPageState createState() => _MyTBReadPageState();
}

class _MyTBReadPageState extends State<MyTBReadPage> {
  List<Map<String, dynamic>> savedBooks = []; // Replace with your data model
  Future<List<SavedBook>> fetchItem() async {
      // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
      var url = Uri.parse(
          'http://localhost:8000/json/');
      var response = await http.get(
          url,
          headers: {"Content-Type": "application/json"},
      );

      // melakukan decode response menjadi bentuk json
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      // melakukan konversi data json menjadi object Item
      List<SavedBook> list_Item = [];
      for (var d in data) {
          if (d != null) {
              list_Item.add(SavedBook.fromJson(d));
          }
      }
      return list_Item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home | My TBRead'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to My TBRead',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            savedBooks.isEmpty
                ? Text('Currently, there are no books to be read 😣', style: TextStyle(fontSize: 18))
                : Column(
                    children: [
                      Text('Currently, you have ${savedBooks.length} book(s) to be read', style: TextStyle(fontSize: 18)),
                      SizedBox(height: 8),
                      GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
                        itemCount: savedBooks.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final savedBook = savedBooks[index];
                          return GestureDetector(
                            onTap: () {
                              // Handle book item click
                              // Navigate to 'mytbr/${savedBook['book']['pk']}'
                            },
                            child: Card(
                              elevation: 5,
                              child: Column(
                                children: [
                                  Image.network(savedBook['book']['image_l'], height: 150, width: double.infinity, fit: BoxFit.cover),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(savedBook['book']['title'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                        Text(savedBook['book']['author']),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Add Your favorite Quote!'),
                        content: TextField(
                          controller: TextEditingController(),
                          decoration: InputDecoration(hintText: 'Enter your quote'),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () {
                              String quoteText = 'Get the quote text from the text field';
                              //addQuote(quoteText);
                              Navigator.pop(context);
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
              child: Text('quote disini'),
            ),
            Center(
              child:ElevatedButton(
                onPressed: () {
                  // Navigate to the homepage or implement your logic
                },
                child: Text('Look at more books'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
