import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloudgallery/database/storage.dart';
import 'package:cloudgallery/global/design.dart';
import 'package:cloudgallery/global/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';
//import 'package:xfile/xfile.dart';

//import 'package:image_picker_for_web/image_picker_for_web.dart';

class ImagePick extends StatefulWidget {
  User? user;
  ImagePick({Key? key, this.user}) : super(key: key);

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  String? imageFileWeb; //static so it can accest in storage.dart
  File? imageFileNative; //static so it can accest in storage.dart
  XFile? pickedFile;
  bool loading = false;
  final StorageServices _storageServices = StorageServices();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    uploadFromGallery() async {
      pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          if (kIsWeb) {
            imageFileWeb = pickedFile!.path;
          }
          if (!kIsWeb && Platform.isAndroid) {
            imageFileNative = File(pickedFile!.path);
          }
        });
      }
    }

    deletePickedImage() {
      setState(() {
        imageFileWeb = null;
        imageFileNative = null;
      });
    }

    return user != null
        ? Container(
            child: imageFileWeb == null && imageFileNative == null
                ? Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        ElevatedButton.icon(
                          icon: const Icon(Icons.image),
                          label: const Text(
                            "Upload an image from gallery",
                            style: TextStyle(
                              color: textColorButtonPrimary,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            primary: backgroundColorButtonPrimary,
                          ),
                          onPressed: () {
                            uploadFromGallery();
                          },
                        ),
                        const SizedBox(
                          height: heightSizedBox,
                        ),
                      ],
                    ),
                  )
                : StreamBuilder<DocumentSnapshot>(
                    stream: _storageServices.getProgress(user),
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Text('Something went wrong');
                      }
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Text("Image is uploading");
                      }
                      return Container(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            if (kIsWeb)
                              Image.network(
                                imageFileWeb!,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            if (!kIsWeb && Platform.isAndroid)
                              Image.file(
                                imageFileNative!,
                                fit: BoxFit.cover,
                                height: 200,
                              ),
                            if (loading)
                              Loading(
                                loadingText: 'Image is uploading...',
                              ),
                            const SizedBox(
                              height: heightSizedBox,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.image),
                                  label: const Text(
                                    "Upload another image from gallery",
                                    style: TextStyle(
                                      color: textColorButtonSecondary,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: backgroundColorButtonSecondary,
                                  ),
                                  onPressed: () {
                                    uploadFromGallery();
                                  },
                                ),
                                const SizedBox(
                                  width: 10.0,
                                ),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.delete),
                                  label: const Text(
                                    "Delete this image",
                                    style: TextStyle(
                                      color: textColorButtonSecondary,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    primary: backgroundColorButtonSecondary,
                                  ),
                                  onPressed: () {
                                    deletePickedImage();
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: heightSizedBox,
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.cloud_upload),
                              label: const Text(
                                "Upload this image to Firebase Storage",
                                style: TextStyle(
                                  color: textColorButtonPrimary,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                primary: backgroundColorButtonPrimary,
                              ),
                              onPressed: () async {
                                setState(() {
                                  loading = true;
                                });
                                await _storageServices.uploadImageToFirebase(
                                    pickedFile!, user);
                                deletePickedImage();
                              },
                            ),
                          ],
                        ),
                      );
                    }),
          )
        : Container();
  }
}
