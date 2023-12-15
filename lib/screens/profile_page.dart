// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:to_be_read_mobile/models/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class Profile {
  String name;
  String dateOfBirth;
  String email;
  String address;

  Profile({
    required this.name,
    required this.dateOfBirth,
    required this.email,
    required this.address,
  });
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool _editingProfile = false;

  // Profile information variable
  late Profile profile;

  @override
  void initState() {
    super.initState();
    // Initialize the profile with default values
    profile = Profile(
      name: 'John Doe',
      dateOfBirth: 'January 1, 1990',
      email: 'johndoe@mail.com',
      address: '123 Main St, Cityville, Country',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: SizedBox(
          width: 400,
          height: _editingProfile ? 500 : 400,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(36),
              child: _editingProfile
                  ? _buildEditProfileForm()
                  : _buildProfileInfo(),
            ),
          ),
        ),
      ),
      floatingActionButton: _editingProfile
          ? null
          : FloatingActionButton(
              onPressed: () {
                setState(() {
                  _editingProfile = true;
                });
              },
              tooltip: 'Edit Profile',
              child: const Icon(Icons.edit),
            ),
    );
  }

  Widget _buildProfileInfo() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          '${profile.name}',
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '\nsaved 12 books on TBRead\n',
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),

        const SizedBox(height: 16),
        Text(
          'Date of Birth: ${profile.dateOfBirth}',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Email: ${profile.email}',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          'Address: ${profile.address}\n\n',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.grey,
          ),
        ), // Reduced space after the sections
        ElevatedButton(
          onPressed: () {
            setState(() {
              _editingProfile = true;
            });
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16), // Increased button size
          ),
          child: const Text('Edit Profile'),
        ),
      ],
    );
  }

  Widget _buildEditProfileForm() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center, // Center vertically
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextFormField(
          initialValue: profile.name, // Use actual user data here
          onChanged: (value) {
            setState(() {
              profile.name = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Name',
          ),
        ),
        const SizedBox(height: 16), // Space between fields
        TextFormField(
          initialValue: profile.dateOfBirth, // Use actual user data here
          onChanged: (value) {
            setState(() {
              profile.dateOfBirth = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Date of Birth',
          ),
        ),
        const SizedBox(height: 16), // Space between fields
        TextFormField(
          initialValue: profile.email, // Use actual user data here
          onChanged: (value) {
            setState(() {
              profile.email = value;
            });
          },
          decoration: const InputDecoration(
            labelText: 'Email',
          ),
        ),
        const SizedBox(height: 16), // Space between fields
        TextFormField(
          initialValue: profile.address, // Use actual user data here
          onChanged: (value) {
            setState(() {
              profile.address = value;
            });
          },
          maxLines: 2,
          decoration: const InputDecoration(
            labelText: 'Address',
          ),
        ),
        const SizedBox(height: 36), // Space after fields
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: (){
                setState(() {
                  _editingProfile = false;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                backgroundColor: Colors.red,
              ),
              child: const Text('Cancel'),
            ),
            const SizedBox(width: 16), // Space between buttons
            ElevatedButton(
              onPressed: () {
                // TODO: Handle updating profile info
                // You can use the profile variable here to access the updated values
                setState(() {
                  _editingProfile = false;
                });
              },
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              ),
              child: const Text('Save Changes'),
            ),
          ],
        ),
      ],
    );
  }
}
