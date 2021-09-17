import 'package:cloudgallery/database/auth.dart';
import 'package:cloudgallery/global/design.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColorPage,
      body: Column(
        children: [
          const Text('Home()'),
          ElevatedButton(
            child: const Text('Log Out',
                style: TextStyle(
                  color: textColorButtonPrimary,
                )),
            style: ElevatedButton.styleFrom(
              primary: backgroundColorButtonPrimary,
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          ),
        ],
      ),
    );
  }
}
