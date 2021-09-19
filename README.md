# CloudGallery (Android, iOS, Web) [Still in progress]

With this project I want to demonstrate and use Flutters promise of one codebase for all platforms (Android, iOS, Web).

## Packages Used

Firebase Auth
Firebase Google Sign In
Firebase Storage

## Live Demos

- [Web](https://flutterwebapps.com)

## Documentation

### main.dart
Firebase is initialized here on the top of the widget tree. A Futurebuilder is used, the future is the Firebase.initializeApp() future. On successful connection to Firebase the next Widget in the tree is shown, the Wrapper()

### wrapper.dart
This Widget is between the main MyApp() and all the following widgets and pages. This Wrapper() discriminates between the user logged in (is already registerd) or logged out (need to register).

A StreamBuilder is listening to the authStateChanges() stream of Firebase. If the user is logged in, the Home() widget is shown. If he is logged out / hasn't registered yet, the SignIn() widget is shown.


