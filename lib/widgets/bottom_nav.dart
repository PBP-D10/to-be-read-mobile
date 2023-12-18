import 'package:flutter/material.dart';
// import 'package:pbp_django_auth/pbp_django_auth.dart';
// import 'package:provider/provider.dart';
import 'package:to_be_read_mobile/screens/mytbr_page.dart';
import 'package:to_be_read_mobile/screens/home_page.dart';
import 'package:to_be_read_mobile/screens/profile_page.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

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
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
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
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const ProfilePage())),
          }
      },
    );
  }
}
