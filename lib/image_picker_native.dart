import 'package:cloudgallery/global/design.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerNative extends StatefulWidget {
  const ImagePickerNative({Key? key}) : super(key: key);

  @override
  _ImagePickerNativeState createState() => _ImagePickerNativeState();
}

class _ImagePickerNativeState extends State<ImagePickerNative> {
  File? imageFile;

  @override
  Widget build(BuildContext context) {
    /// Get from gallery
    uploadFromGallery() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxWidth: 400,
        maxHeight: 400,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      }
    }

    deletePickedImage() {
      setState(() {
        imageFile = null;
      });
    }

    return Container(
      child: imageFile == null
          ? Container(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    child: const Text(
                      "Web pick image from gallery",
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
                ],
              ),
            )
          : Container(
              alignment: Alignment.center,
              child: Column(
                children: [
                  Image.file(
                    imageFile!,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(
                    height: heightSizedBox,
                  ),
                  ElevatedButton(
                    child: const Text(
                      "Web pick another image from gallery",
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
                  OutlinedButton(
                    child: const Text(
                      "Web delete picked image",
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
            ),
    );
  }
}
