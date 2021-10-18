import 'package:cloudgallery/database/storage.dart';
import 'package:cloudgallery/global/design.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';
//import 'package:xfile/xfile.dart';

//import 'package:image_picker_for_web/image_picker_for_web.dart';

class ImagePick extends StatefulWidget {
  const ImagePick({Key? key}) : super(key: key);

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
  String? imageFileWeb; //static so it can accest in storage.dart
  File? imageFileNative; //static so it can accest in storage.dart
  XFile? pickedFile;
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

    return Container(
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
          : Container(
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
                  const SizedBox(
                    height: heightSizedBox,
                  ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                        icon: Icon(Icons.image),
                        label: const Text(
                          "Upload another image from gallery",
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
                  const SizedBox(height: heightSizedBox),
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
                      await _storageServices.uploadImageToFirebase(
                          pickedFile!, user!);
                      deletePickedImage();
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
