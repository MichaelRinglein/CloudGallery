import 'dart:async';
import 'dart:typed_data';
import 'package:cloudgallery/database/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class StorageServices {
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'gs://cloudgallery-strawanzer.appspot.com');
  //final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> uploadImageToFirebase(XFile imageFile, User user) async {
    //String user = 'mvexC64DasgnwHNG6jl4PFZGa8x2';
    //isUserLoggedIn = user;
    //User? user;
    print('user is $user');

    String fileName = imageFile.name;
    String filePath = 'images/${user.uid}/$fileName';
    Uint8List imageFileUpload = await imageFile.readAsBytes();

    try {
      await _storage.ref().child(filePath).putData(imageFileUpload,
          firebase_storage.SettableMetadata(contentType: 'image/jpeg'));
    } catch (e) {
      print('error while uploading to storage:');
      print(e.toString());
    }
  }
}
