import 'package:cloudgallery/auth/sign_in.dart';
import 'package:cloudgallery/database/auth.dart';
import 'package:cloudgallery/image_pick.dart';
import 'package:cloudgallery/wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    return StreamProvider.value(
      value: AuthService().user,
      initialData: null,
      //future: Firebase.initializeApp(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        routes: {
          '/': (context) => Wrapper(),
          '/sign-in': (context) => SignIn(),
        },
      ),
    );
  }
}
