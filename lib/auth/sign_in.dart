import 'package:cloudgallery/database/auth.dart';
import 'package:cloudgallery/global/design.dart';
import 'package:cloudgallery/global/loading.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  //const SignIn({Key? key}) : super(key: key);

  final Function? toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  bool loading = false;
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: backgroundColorPage,
            body: Column(
              children: [
                ElevatedButton(
                    child: const Text('Sign in Anonymously',
                        style: TextStyle(
                          color: textColorButtonPrimary,
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: backgroundColorButtonPrimary,
                    ),
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInAnonym();
                      if (result == null) {
                        setState(() {
                          error = 'Something went wrong. Please try again';
                          loading = false;
                        });
                      }
                      Navigator.pushNamed(context, '/');
                    }),
                const SizedBox(height: 12.0),
                Text(
                  error,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14.0,
                  ),
                ),
                const SizedBox(height: heightSizedBox),
                ElevatedButton(
                    child: const Text('Sign in with Google',
                        style: TextStyle(
                          color: textColorButtonPrimary,
                        )),
                    style: ElevatedButton.styleFrom(
                      primary: backgroundColorButtonPrimary,
                    ),
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result;
                      if (kIsWeb == true) {
                        result = await _auth.signInWithGoogleWeb();
                        if (result == null) {
                          setState(() {
                            error = 'Something went wrong. Please try again';
                            loading = false;
                          });
                        }
                        return result;
                      } else {
                        result = await _auth.signInWithGoogleNative();
                        if (result == null) {
                          setState(() {
                            error = 'Something went wrong. Please try again';
                            loading = false;
                          });
                        }
                        return result;
                      }
                    }),
              ],
            ),
          );
  }
}
