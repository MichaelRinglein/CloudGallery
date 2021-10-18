import 'package:cloudgallery/database/auth.dart';
import 'package:cloudgallery/global/design.dart';
import 'package:cloudgallery/image_pick.dart';
import 'package:cloudgallery/show_images.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final AuthService _auth = AuthService();

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
          ShowImages(
            user: user,
          ),
          const SizedBox(
            height: heightSizedBox,
          ),
          const ImagePick(),
          const SizedBox(
            height: heightSizedBox,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.logout),
            label: const Text('Log Out',
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
