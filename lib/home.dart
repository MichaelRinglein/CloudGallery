import 'package:cloudgallery/database/auth.dart';
import 'package:cloudgallery/global/design.dart';
import 'package:cloudgallery/image_pick.dart';
import 'package:cloudgallery/show_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  static const TextStyle iconTextStyle = TextStyle(
    fontSize: 30,
    fontWeight: FontWeight.bold,
    color: iconsTextColor,
  );
  static const List<Widget> _widgetOptions = <Widget>[
    Text(
      'Index 0: Home',
      style: iconTextStyle,
    ),
    Text(
      'Index 1: Business',
      style: iconTextStyle,
    ),
    Text(
      'Index 2: School',
      style: iconTextStyle,
    ),
  ];

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 2) {
      _auth.signOut();
    }

    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);
    return Scaffold(
      backgroundColor: backgroundColorPage,
      appBar: AppBar(
        title: const Text('Home'),
        backgroundColor: backgroundColorAppBar,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _selectedIndex == 0
              ? ShowImages(
                  user: user,
                )
              : ImagePick(
                  user: user,
                ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.image,
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.upload),
            label: 'Upload',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.logout,
            ),
            label: 'Log Out',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: iconsTextColor,
        onTap: _onItemTapped,
      ),
    );
  }
}
