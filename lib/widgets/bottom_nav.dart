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
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final CookieRequest request =
        Provider.of<CookieRequest>(context, listen: false);
    _checkPublisherStatus(request);
  }

  void _checkPublisherStatus(CookieRequest request) async {
    try {
      isPublisher = await UserService().checkIsPublisher(request);
      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error checking publisher status: $e');
    }
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
        label: 'Saved',
      ),
      const BottomNavigationBarItem(
        icon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    if (isPublisher) {
      navItems.add(const BottomNavigationBarItem(
        icon: Icon(Icons.library_books),
        label: 'Publisher',
      ));
    }

    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      elevation: 12,
      items: navItems,
      currentIndex: widget.currentIndex,
      onTap: (index) => _onItemTapped(index, context),
    );
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const HomePage()));
        break;
      case 1:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MyTBReadPage()));
        break;
      case 2:
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
      case 3:
        if (isPublisher) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const PublisherPage()));
        }
        break;
    }
  }
}

class UserService {
  Future<bool> checkIsPublisher(CookieRequest request) async {
    var result = await request
        .get('https://web-production-fd753.up.railway.app/publisher/check/');

    // Check if the result is already a decoded JSON map.
    if (result is Map<String, dynamic>) {
      if (result.containsKey('is_publisher')) {
        return result['is_publisher'];
      } else {
        throw Exception('is_publisher key not found in response');
      }
    } else {
      throw Exception('Unexpected type for response: ${result.runtimeType}');
    }
  }
}
