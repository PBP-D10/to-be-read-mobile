import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:to_be_read_mobile/models/book.dart';
import 'package:to_be_read_mobile/screens/mytbr_page.dart';
// import 'package:to_be_read_mobile/widgets/bottom_nav.dart';

class BookDetailPage extends StatefulWidget {
  const BookDetailPage({super.key, required this.book});

  final Book book;

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  late Book book;
  @override
  void initState() {
    super.initState();
    book = widget.book;
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(book.fields.imageL),
                fit: BoxFit.cover,
              ),
              // backgroundBlendMode: BlendMode.multiply,
              color: Colors.black.withOpacity(0.5),
            ),
          ),
          Container(
              decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.black.withOpacity(0.9),
                Colors.black.withOpacity(0.5),
                Colors.black.withOpacity(0.0),
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          )),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.fields.title,
                  style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      overflow: TextOverflow.ellipsis),
                  maxLines: 2,
                ),
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${book.fields.author}, ${book.fields.year}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        )),
                    FutureBuilder(
                      future: getLikeCount(),
                      builder:
                          (BuildContext context, AsyncSnapshot<int> snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (snapshot.hasError) {
                          return Text(
                              'Error getting like count: ${snapshot.error}');
                        } else {
                          return RichText(
                            text: TextSpan(children: [
                              WidgetSpan(
                                child: Icon(
                                  Icons.thumb_up,
                                  size: 16,
                                  color: Colors.blue.shade200,
                                ),
                              ),
                              TextSpan(
                                text: snapshot.data.toString(),
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                            ]),
                          );
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                    "${book.fields.title} was published in ${book.fields.year} by ${book.fields.publisher} and written by ${book.fields.author}.",
                    style: const TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    )),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 18),
                        ),
                        onPressed: () async {
                          final response = await request.postJson(
                                "http://127.0.0.1:8000/create-saved-flutter/",
                                jsonEncode(<String, Book>{
                                    'book': book,
                                    // TODO: Sesuaikan field data sesuai dengan aplikasimu
                                }));
                                if (response['status'] == 'success') {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                    content: Text("Buku berhasil disimpan!"),
                                    ));
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(builder: (context) => MyTBReadPage()),
                                    );
                                } else if(response['status'] == 'already exist'){
                                    ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                      content: Text("Buku sudah pernah disimpan!"),
                                      ));
                                }
                                else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(const SnackBar(
                                        content:
                                            Text("Terdapat kesalahan, silakan coba lagi."),
                                    ));
                                }
                            },
                        
                        child: const Text('Save'),
                      ),
                    ),
                    const SizedBox(width: 20),

                    // Like Button
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 18),
                        ),
                        onPressed: () async {
                          var response = await request.postJson(
                              'http://127.0.0.1:8000/like_book_ajax/',
                              jsonEncode(<String, int>{'book': book.pk}));

                          if (response['status'] == 'created') {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(const SnackBar(
                                    content: Text("Buku berhasil dilike!")));   
                            }
                            
                          } else if (response['status'] == 'ALREADY_EXISTS') {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  ..hideCurrentSnackBar()
                                  ..showSnackBar(const SnackBar(
                                content:
                                    Text("Anda sudah pernah like buku ini!"),
                              ));
                            }
                          } else {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                content: Text(
                                    "Terdapat kesalahan, silakan coba lagi."),
                              ));
                            }
                          }

                          // refresh like count
                          setState(() {});
                        },
                        child: const Text('Like'),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 36, vertical: 18),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Back'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<int> getLikeCount() async {
    var url = Uri.parse('http://127.0.0.1:8000/like-count/${book.pk}/');
    var response = await http.get(
      url,
    );

    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    return data['like_count'];
  }
}
