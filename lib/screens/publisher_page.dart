import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/screens/edit_book.dart';
import 'package:to_be_read_mobile/screens/houses_page.dart';
import 'package:to_be_read_mobile/screens/publish_book_form.dart';
import 'package:to_be_read_mobile/widgets/bottom_nav.dart';

// class IsPublisher {
//   bool isPublisher;

//   IsPublisher({
//     required this.isPublisher,
//   });

//   factory IsPublisher.fromJson(Map<String, dynamic> json) => IsPublisher(
//         isPublisher: json["is_publisher"],
//       );

//   Map<String, dynamic> toJson() => {
//         "is_publisher": isPublisher,
//       };
// }

class PublisherPage extends StatelessWidget {
  const PublisherPage({Key? key}) : super(key: key);

  // Future<IsPublisher> checkIsPublisher() async {
  //   var url = Uri.parse('https://web-production-fd753.up.railway.app/publisher/check/');

  //   try {
  //     var response = await http.get(url);

  //     if (response.statusCode == 200) {
  //       var data = jsonDecode(utf8.decode(response.bodyBytes));
  //       print(response.body);
  //       return IsPublisher.fromJson(data);
  //     } else {
  //       return IsPublisher(isPublisher: false);
  //     }
  //   } catch (e) {
  //     print('Error checking publisher status: $e');
  //     return IsPublisher(isPublisher: false);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const BottomNav(currentIndex: 2),
      appBar: AppBar(
        title: const Text('Publisher'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body:
          // FutureBuilder<IsPublisher>(
          //   future: checkIsPublisher(),
          //   builder: (context, snapshot) {
          //     if (snapshot.connectionState == ConnectionState.waiting) {
          //       return Center(child: CircularProgressIndicator());
          //     } else if (snapshot.hasError || !snapshot.data!.isPublisher) {
          //       return Center(
          //         child: Text('This section can only be accessed by publisher.'),
          //       );
          //     } else {
          //       return
          Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Welcome aboard, Publisher!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            CardButton(
              title: 'Publish Book',
              icon: Icons.publish,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const BookFormPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            CardButton(
              title: 'Edit Book',
              icon: Icons.edit,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const EditBookPage()),
                );
              },
            ),
            const SizedBox(height: 20),
            CardButton(
              title: 'Publisher House',
              icon: Icons.home,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => HousesPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CardButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const CardButton({
    required this.title,
    required this.icon,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Card(
        elevation: 3,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(icon, size: 40),
              const SizedBox(height: 8),
              Text(
                title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
