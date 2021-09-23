import 'package:cloudgallery/global/design.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
//import 'package:image_picker_for_web/image_picker_for_web.dart';

class ImagePick extends StatefulWidget {
  const ImagePick({Key? key}) : super(key: key);

  @override
  _ImagePickState createState() => _ImagePickState();
}

class _ImagePickState extends State<ImagePick> {
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
                    height: 200,                    
                  ),
                  const SizedBox(
                    height: heightSizedBox,
                  ),
                  ElevatedButton(
                    child: const Text(
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
                  const SizedBox(
                    height: heightSizedBox,
                  ),
                  OutlinedButton(
                    child: const Text(
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
            ),
    );
  }
}
