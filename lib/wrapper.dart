import 'package:cloudgallery/auth/sign_in.dart';
import 'package:cloudgallery/global/loading.dart';
import 'package:cloudgallery/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  Wrapper({Key? key}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    //User? user;
    //bool userLoggedIn = false;

    return StreamBuilder(
        stream: _auth.authStateChanges(),
        builder: (context, snapshot) {
          //print('snapshot is $snapshot');
          //print('snapshot.data is');
          //print(snapshot.data);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Loading(
              loadingText: 'Loading...',
            );
          }

          return snapshot.data == null ? SignIn() : Home();
        });
  }
}
