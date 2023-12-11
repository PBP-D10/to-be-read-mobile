import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/mytbr.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:to_be_read_mobile/screens/auth/login_page.dart';
// import 'package:to_be_read_mobile/screens/auth/login_page.dart';
import 'package:to_be_read_mobile/screens/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return Provider(
            create: (_) {
                CookieRequest request = CookieRequest();
                return request;
            }, 
      child:
      MaterialApp(
          title: 'My TBR',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
            useMaterial3: true,
          ),
          debugShowCheckedModeBanner: false,
          home: MyTBReadPage(),
      )
    );
  }
}