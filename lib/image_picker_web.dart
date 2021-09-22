import 'package:cloudgallery/global/design.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_for_web/image_picker_for_web.dart';

class ImagePickerWeb extends StatefulWidget {
  const ImagePickerWeb({Key? key}) : super(key: key);

  @override
  _ImagePickerWebState createState() => _ImagePickerWebState();
}

class _ImagePickerWebState extends State<ImagePickerWeb> {
  var imageFile;

  @override
  Widget build(BuildContext context) {
    uploadFromGallery() async {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = pickedFile.path;
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
                  Image.network(
                    imageFile!,
                    fit: BoxFit.cover,
                    height: 300,
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
