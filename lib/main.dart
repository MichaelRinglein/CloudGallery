import 'package:cloudgallery/auth/sign_in.dart';
import 'package:cloudgallery/global/loading.dart';
import 'package:cloudgallery/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          print('snapshot.hasError');
          print(snapshot.error);
          return Loading();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            //home: ,
            routes: {
              '/': (context) => Wrapper(),
              '/sign-in': (context) => SignIn(),
            },
          );
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          print('ConnectionState.waiting');
          return Loading();
        }
        print('Loading()');
        return Loading();
      },
    );
  }
}
