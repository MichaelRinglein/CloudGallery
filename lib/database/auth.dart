import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future signInAnonym() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      print('signInAnonym() with $userCredential');
      return userCredential;
    } catch (e) {
      print('error while signInAnonym() is:');
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogleNative() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      print('signInWithGoogleNative() with $credential');
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print('error while signInWithGoogle() is:');
      print(e.toString());
      return null;
    }
  }

  Future signInWithGoogleWeb() async {
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider
          .addScope('https://www.googleapis.com/auth/contacts.readonly');
      googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
      return await FirebaseAuth.instance.signInWithPopup(googleProvider);
    } catch (e) {
      print('error while signInWithGoogle() is:');
      print(e.toString());
      return null;
    }
  }
  /*
  Future registerWithEmail(String email, String pass) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: pass);
      print('registerWithEmail() with $userCredential');
      return userCredential;
    } catch (e) {
      print('error while registerWithEmail() is:');
      print(e.toString());
      return null;
    }
  }

  Future signInWithEmail(String email, String pass) async {
    try {
      UserCredential userCredential =
          await _auth.signInWithEmailAndPassword(email: email, password: pass);
      print('signInWithEmail() with $userCredential');
      return userCredential;
    } catch (e) {
      print('error while signInWithEmail() is:');
      print(e.toString());
      return null;
    }
  }
  */

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('error while signOut() is:');
      print(e.toString());
      return null;
    }
  }
}
