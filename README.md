# CloudGallery build with Flutter 2.5 with sound Null safety for Android, iOS and Web [Still in progress]

With this project I want to demonstrate and use Flutter's promise of one codebase for all platforms (Android, iOS, Web).

A user can log in, pick an image from the device's gallery or computer's drive and save it to a Firebase Storage (coming soon). 

Where necessary I use the `kIsWeb` boolean to display some widget particular for web or for native (the `signInWithGoogleNative()` and `signInWithGoogleWeb()` for example).

## Packages Used (all with Null safety)

- Firebase Auth
- Firebase Google Sign In
- Firebase Storage
- Image Picker

## Live Demos

- [Web](https://flutterwebapps.com/portfolio/cloud-gallery/#/)
- [Andoid (Play Store)](https://play.google.com/store/apps/details?id=com.strawanzer.cloudgallery)


## Documentation

### main.dart
Firebase is initialized here on the top of the widget tree. A Futurebuilder is used, the future is the `Firebase.initializeApp()` future. On successful connection to Firebase the next Widget in the tree is shown, the Wrapper()

### wrapper.dart
This Widget is between the main MyApp() and all the following widgets and pages. This Wrapper() discriminates between the user logged in (is already registerd) or logged out (need to register).

A StreamBuilder is listening to the `authStateChanges()` stream of Firebase. If the user is logged in, the Home() widget is shown. If he is logged out / hasn't registered yet, the SignIn() widget is shown.

### home.dart
The boolean `kIsWeb` is used to discriminate between web and native. If it is true, ImagePickerWeb() is shown, if it is false then ImagePickerNative() is shown.

### auth/sign_in.dart
The screen to either sign in anonymously or with Google. `kIsWeb` and `Platform.isAndroid` are used in a if-else loop to iscriminate between web and native.

### database/auth.dart
The Firebase authentication methods are stored here. I prefer Future classes with try-catch loops so the app doesn't crash and the user gets an error (from the sign_in.dart) in case the authentication doesn't work.

### image_picker.dart
`uploadFromGallery()` picks the image from the computer or device and saves it into the State `imageFileWeb` or `imageFileNative`. Since Web and Android/iOS handle images a bit different, the following distinction is made: 

For Web the image's path `pickedFile.path` is set in `imageFileWeb` and displayed in an `Image.network` widget.

For Android the ` File(pickedFile.path)` is set in `imageFileNative` and displayed in an `Image.file` widget.

`deletePickedImage()` is deleting the image by setting the State of `imageFileWeb` and `imageFileNative` back to `null`.

`uploadImageToFirebase()` takes the picked `XFile` and the `user` object as parameters.

## database/storage.dart
`uploadImageToFirebase()` receives the picked `XFile` and the `user` object as parameters from the image_picker.dart.

For Web `.putFile()` is used. The image `XFile` is transformed to a ` Uint8List` via the `readAsBytes()` method. This solution a modified version of this post on [StackOverflow](https://stackoverflow.com/questions/59716944/flutter-web-upload-image-file-to-firebase-storage).

The image is saved via the `filePath` in a folder in the Firebase Storage which contains the `user.id` (later in the development several images can be uploaded to the same user id).

## To Do Next
- Add Firebase Storage function for image upload for Android
- Set up app structure to upload and display several images


