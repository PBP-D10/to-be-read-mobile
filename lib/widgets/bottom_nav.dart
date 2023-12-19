import 'package:flutter/material.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
import 'package:to_be_read_mobile/screens/mytbr_page.dart';
import 'package:to_be_read_mobile/screens/home_page.dart';
import 'package:to_be_read_mobile/screens/profile_page.dart';
import 'package:to_be_read_mobile/screens/publisher_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key, this.currentIndex = 0});

  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    // final request = context.watch<CookieRequest>();
    return BottomNavigationBar(
      elevation: 12,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.home_filled),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bookmark),
          label: 'Bookmarks',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Publisher',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: currentIndex,
      onTap: (value) => {
        if (value == 0)
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const HomePage())),
          }
        else if (value == 1)
          {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const MyTBReadPage())),
          }
        else if (value == 2)
          {
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const PublisherPage())),
          }
        else if (value == 3)
          {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfilePage())),
          }
      },
    );
  }
}
