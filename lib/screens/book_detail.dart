import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/models/book.dart';
// import 'package:to_be_read_mobile/widgets/bottom_nav.dart';

class BookDetailPage extends StatelessWidget {
  const BookDetailPage({super.key, required this.book});

  final Book book;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // bottomNavigationBar: const BottomNav(),
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
                    RichText(
                      text: const TextSpan(children: [
                        WidgetSpan(
                          child: Icon(
                            Icons.star,
                            size: 16,
                            color: Colors.yellow,
                          ),
                        ),
                        TextSpan(
                          text: "4.8",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ]),
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
                        onPressed: () {},
                        child: const Text('Save'),
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
}
