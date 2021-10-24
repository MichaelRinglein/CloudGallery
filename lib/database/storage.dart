import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class StorageServices {
  final firebase_storage.FirebaseStorage _storage =
      firebase_storage.FirebaseStorage.instanceFor(
          bucket: 'gs://cloudgallery-strawanzer.appspot.com');
  final CollectionReference _reference =
      FirebaseFirestore.instance.collection('images');

  Future<void> uploadImageToFirebase(XFile imageFile, User user) async {
    String fileName = imageFile.name;
    String filePath = 'images/${user.uid}/$fileName';
    Uint8List imageFileUpload = await imageFile.readAsBytes();

    try {
      //save the actual image to Firebase Storage
      await _storage.ref().child(filePath).putData(imageFileUpload,
          firebase_storage.SettableMetadata(contentType: 'image/jpeg'));
      //save the reference of the image to Firebase Firestore
      await _reference.doc(user.uid).set({'fileName': fileName});
    } catch (e) {
      print('error while uploadImageToFirebase:');
      print(e.toString());
    }
  }

  Future<List> getDownloadURLS(User user) async {
    String filePath = 'images/${user.uid}';
    final List downloadURLs = [];
    final firebase_storage.ListResult result =
        await _storage.ref().child(filePath).listAll();

    for (var i in result.items) {
      downloadURLs.add(await i.getDownloadURL());
    }

    //print('getDownloadURLS() fired');
    //print('downloadURLs are $downloadURLs');

    return downloadURLs;
  }

  Stream<DocumentSnapshot> getDownloadURLStream(User user) {
    return _reference.doc(user.uid).snapshots();
  }
}
