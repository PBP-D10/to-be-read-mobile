import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
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
    // Initialization logic can be added here if necessary
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final request = Provider.of<CookieRequest>(context, listen: false);
    _checkPublisherStatus(request);
  }

  void _checkPublisherStatus(CookieRequest request) async {
    isPublisher = await UserService().checkIsPublisher(request);
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
      if (isPublisher)
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
    switch (value) {
      case 0:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const MyTBReadPage()));
        break;
      case 2:
        if (isPublisher) {
          Navigator.push(context, MaterialPageRoute(builder: (context) => const PublisherPage()));
        }
        break;
      case 3:
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
    }
  }
}

class UserService {
  Future<bool> checkIsPublisher(CookieRequest request) async {
    var response = await request.get('https://web-production-fd753.up.railway.app/publisher/check/');
    try {
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
