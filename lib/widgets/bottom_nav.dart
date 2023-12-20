// add publisher check
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/screens/home_page.dart';
import 'package:to_be_read_mobile/screens/mytbr_page.dart';
import 'package:to_be_read_mobile/screens/profile_page.dart';
import 'package:to_be_read_mobile/screens/publisher_page.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key, this.currentIndex = 0}) : super(key: key);

  final int currentIndex;

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  bool isPublisher = false;

  @override
  void initState() {
    super.initState();
    _checkPublisherStatus();
  }

  void _checkPublisherStatus() async {
    isPublisher = await UserService().checkIsPublisher();
    setState(() {}); // Update the state to reflect changes
  }

  @override
  Widget build(BuildContext context) {
    List<BottomNavigationBarItem> navItems = [
      const BottomNavigationBarItem(
        icon: Icon(Icons.home_filled),
        label: 'Home',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.bookmark),
        label: 'Bookmarks',
      ),
      if (isPublisher) // Conditional item
        const BottomNavigationBarItem(
          icon: Icon(Icons.library_books),
          label: 'Publisher',
        ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 12,
      items: navItems,
      currentIndex: widget.currentIndex,
      onTap: (value) => _onItemTapped(value, context),
    );
  }

  void _onItemTapped(int value, BuildContext context) {
    if (value == 0) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else if (value == 1) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const MyTBReadPage()));
    } else if (value == 2 && isPublisher) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const PublisherPage()));
    } else if (value == 3) {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const ProfilePage()));
    }
  }
}


class UserService {
  Future<bool> checkIsPublisher() async {
    var url = Uri.parse('https://web-production-fd753.up.railway.app/publisher/check/');
    try {
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        return data['is_publisher'];
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
