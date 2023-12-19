// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pbp_django_auth/pbp_django_auth.dart';
import 'package:provider/provider.dart';
import 'package:to_be_read_mobile/models/profile.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:to_be_read_mobile/screens/auth/login_page.dart';
import 'package:to_be_read_mobile/widgets/bottom_nav.dart';
import 'package:date_field/date_field.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _editingProfile = false;
  String _name = "";
  String _email = "";
  String? _address = "";
  DateTime? _dateOfBirth;
  final _formKey = GlobalKey<FormState>();

  // Profile information variable
  late Profile profile;
  late Future<List<Profile>> profileFuture;

  @override
  void initState() {
    super.initState();
    profileFuture = fetchProfile();
  }

  Future<List<Profile>> fetchProfile() async {
    var url = Uri.parse(
        'https://web-production-fd753.up.railway.appget_profile_json_flutter');
    var response =
        await http.get(url, headers: {"content-type": "application/json"});
    var jsonString = utf8.decode(response.bodyBytes);
    var data = jsonDecode(jsonString);

    List<Profile> profiles = [];

    for (var profileData in data) {
      profiles.add(Profile.fromJson(profileData));
    }

    return profiles;
  }

  Future<int> fetchSavedBooks() async {
    var url = Uri.parse(
        'https://web-production-fd753.up.railway.appget_saved_books_json_flutter');
    var response =
        await http.get(url, headers: {"content-type": "application/json"});
    var jsonString = utf8.decode(response.bodyBytes);
    var data = jsonDecode(jsonString);

    return data.length;
  }

  Future<void> refreshProfileData() async {
    List<Profile> updatedProfile = await fetchProfile();
    setState(() {
      profile = updatedProfile.first;
    });
  }

  @override
  Widget build(BuildContext context) {
    final request = context.watch<CookieRequest>();
    return Scaffold(
      bottomNavigationBar: const BottomNav(
        currentIndex: 3,
      ),
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SizedBox(
          width: 500,
          height: _editingProfile ? 500 : 470,
          child: Card(
            child: Padding(
                padding: const EdgeInsets.all(36),
                child: _editingProfile
                    ? FutureBuilder(
                        future: profileFuture,
                        builder: (context, AsyncSnapshot snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            Profile profile = snapshot.data[0];
                            return _buildEditProfileForm(profile, request);
                          }
                        },
                      )
                    : FutureBuilder(
                        future:
                            Future.wait([fetchProfile(), fetchSavedBooks()]),
                        builder:
                            (context, AsyncSnapshot<List<dynamic>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<dynamic> profileData = snapshot.data![0];
                            int savedBooksCount = snapshot.data![1];
                            Profile profile = profileData[0] as Profile;
                            return SingleChildScrollView(
                              child: _buildProfileInfo(
                                  profile, savedBooksCount, request),
                            );
                          }
                        },
                      )),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileInfo(
      Profile profile, int savedBooksCount, CookieRequest request) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          profile.fields.name,
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Saved $savedBooksCount books on TBRead\n',
          style: const TextStyle(
            fontStyle: FontStyle.italic,
            fontSize: 14,
            color: Colors.grey,
          ),
        ),

        Divider(
          color: Colors.grey,
          height: 20,
          thickness: 1,
          indent: 16,
          endIndent: 16,
        ), // Added divider

        _buildProfileRow('Email :', profile.fields.email),
        _buildProfileRow('Address :', "${profile.fields.address}"),
        _buildProfileRow(
            'Date of Birth :', formatDateTime(profile.fields.dateOfBirth)),

        ElevatedButton(
          onPressed: () {
            setState(() {
              _buildEditProfileForm(profile, request);
              _editingProfile = true;
            });
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor:
                  Theme.of(context).colorScheme.primary // Increased button size
              ),
          child: const Text(
            'Edit Profile',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),

        const SizedBox(height: 8),

        ElevatedButton(
          onPressed: () async {
            final response = await request.logout(
                'https://web-production-fd753.up.railway.appauth/logout-endpoint');
            String message = response["message"];
            if (response['status']) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("$message Sampai jumpa kembali di TBRead!"),
              ));
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(message),
              ));
            }
          },
          style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              backgroundColor: Colors.red // Increased button size
              ),
          child: const Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime != null) {
      return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}\n\n';
    } else {
      return '-\n\n';
    }
  }

  Widget _buildProfileRow(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start, // Align values at the top
        children: [
          SizedBox(
            width: 150, // Adjust the width as needed
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditProfileForm(Profile profile, CookieRequest request) {
    if (!_editingProfile) {
      _name = profile.fields.name;
      _email = profile.fields.email;
      _address = profile.fields.address;
      _dateOfBirth = profile.fields.dateOfBirth;
    }

    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // Center vertically
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            initialValue: _name, // Use actual user data here
            onChanged: (value) {
              setState(() {
                _name = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Name',
              contentPadding: EdgeInsets.only(bottom: 8.0),
            ),
          ),

          const SizedBox(height: 16), // Space between fields
          TextFormField(
            initialValue: _email, // Use actual user data here
            onChanged: (value) {
              setState(() {
                _email = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Email',
              contentPadding: EdgeInsets.only(bottom: 8.0),
            ),
          ),

          const SizedBox(height: 16), // Space between fields
          TextFormField(
            initialValue: _address, // Use actual user data here
            onChanged: (value) {
              setState(() {
                _address = value;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Address',
              contentPadding: EdgeInsets.only(bottom: 8.0),
            ),
          ),

          const SizedBox(height: 16), // Space between fields
          DateTimeField(
            selectedDate: _dateOfBirth,
            onDateSelected: (DateTime date) {
              setState(() {
                _dateOfBirth = date;
              });
            },
            decoration: const InputDecoration(
              labelText: 'Date of Birth',
              contentPadding: EdgeInsets.only(bottom: 8.0),
            ),
          ),

          const SizedBox(height: 36), // Space after fields
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _editingProfile = false;
                  });
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Colors.red,
                ),
                child: const Text('Cancel',
                    style: TextStyle(
                      color: Colors.white,
                    )),
              ),
              const SizedBox(width: 16), // Space between buttons
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    // Check if any field is modified
                    if (_name.isNotEmpty ||
                        _email.isNotEmpty ||
                        _address != profile.fields.address ||
                        _dateOfBirth != profile.fields.dateOfBirth) {
                      // Only update the modified fields
                      final response = await request.postJson(
                        "https://web-production-fd753.up.railway.appedit_profile_flutter",
                        jsonEncode(<String, String>{
                          'name': _name,
                          'email': _email,
                          'address': _address != null ? _address! : "-",
                          'date_of_birth': _dateOfBirth != null
                              ? DateFormat('yyyy-MM-dd').format(_dateOfBirth!)
                              : "null",
                        }),
                      );
                      if (response['status'] == 'success') {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content: Text("Profile berhasil diupdate!"),
                        ));
                        setState(() {
                          _editingProfile = false;
                          refreshProfileData();
                        });
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(
                          content:
                              Text("Terdapat kesalahan, silakan coba lagi."),
                        ));
                      }
                    } else {
                      // No fields are modified
                      setState(() {
                        _editingProfile = false;
                      });
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: const Text(
                  'Save Changes',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
