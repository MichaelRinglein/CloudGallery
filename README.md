# CloudGallery build with Flutter 2.5 with sound Null safety for Android, iOS and Web [Still in progress]

With this project I want to demonstrate and use Flutters promise of one codebase for all platforms (Android, iOS, Web).

With this app a user can log in, pick an image from the device's gallery or computer's drive and save it to a Firebase Storage. 

Where necessary I use the `kIsWeb` boolean to display some widget particular for web or for native (the ImagePickerWeb and ImagePickerNative for example).

## Packages Used (all with Null safety)

Firebase Auth
Firebase Google Sign In
Firebase Storage
Image Picker

## Live Demos

- [Web](https://flutterwebapps.com/portfolio/cloud-gallery/#/)

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

### image_picker_web.dart
`uploadFromGallery()` picks the image from the computer and saves it into the State `imageFile`. The image's path is used by `imageFile.path` in an `Image.network` widget to display the image. 

`deletePickedImage()` is deleting the image by setting the State of `imageFile` back to `null`.

### image_picker_web.dart [still in progress]


