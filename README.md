# Flutter Quiz App

### App Demo (Web)

Deployed with Firebase Hosting [here](https://flutter-quizapp-5e713.web.app) and [here](https://flutter-quizapp-5e713.firebaseapp.com)

### App Description

This is a simple quiz app made with Flutter and Firebase, built for cross-platform development. Users can authenticate with Google Sign In, or sign in anonymously, then test their knowledge of various web technologies through a small collection of quizzes.

I completed this following a course by [Fireship](https://fireship.io/) to learn the basics of Flutter. The course can be found [here](https://fireship.io/courses/flutter-firebase/). Overall I find Flutter to be a very challenging framework to pick up, but the amazing developer experience almost fully makes up the difference. A fun project once again!

### Technologies Explored

- [Flutter](https://flutter.dev/) and [Dart](https://dart.dev/)
- [Firebase](https://firebase.google.com/) ([FlutterFire](https://firebase.flutter.dev/))
  - Firebase Google and anonymous [authentication](https://firebase.flutter.dev/docs/auth/usage/)
  - Firebase [Firestore](https://firebase.flutter.dev/docs/firestore/usage/) database
  - Firebase [Hosting](https://firebase.google.com/docs/hosting)

### Web Deployment

The course on Fireship walks through deployments for Android and iOS. Sadly in order to deploy and release an app to the Apple App Store or Google Play Store, it's either going to cost:

- $25 for Google Play registration
- $100/year(!) for Apple Store Developer account

But free things are always nice, and web deployment is free. Turns out, web deployment is a far more involved configuration process than I initially imagined...

#### Steps for Successful Web Deployment

- Add web app to Firebase
  - Go to the Firebase [console](https://console.firebase.google.com/), project settings, and follow the instructions for adding a web app. Ignore the steps for adding Firebase credentials for now
- Configuring FlutterFire
  - Folloing the FlutterFire web installation instructions [here](https://firebase.flutter.dev/docs/installation/web/), add the appropriate script tags to the `/web/index.html` containing core Firebase code and your Firebase credentials
  - That just takes care of the core Firebase installation. You need to add individual Firebase components, like Auth and Firestore, in separate script tags.
  - For example, go [here](https://firebase.flutter.dev/docs/firestore/overview) for the Firestore script tag
- Google Sign In
  - This app uses Google authentication, which is quite involved to set up for Flutter web
  - Configuring `google_sign_in_web`
    - Visit your Google Cloud [credentials](https://console.cloud.google.com/apis/credentials) page, and under `OAuth 2.0 Client IDs`, copy your web client ID
    - Add a meta tag to `/web/index.html` following the syntax from [this](https://github.com/flutter/plugins/blob/master/packages/google_sign_in/google_sign_in_web/README.md#web-integration) guide
  - Adding authorised Javascript origins
    - From the same [credentials](https://console.cloud.google.com/apis/credentials) page, click on the 'edit' pencil for the web client
    - Under 'Authorised Javascript origins', the Firebase Hosting URIs which look like `https://flutter-quizapp-5e713.firebaseapp.com` and `https://flutter-quizapp-5e713.web.app` should already be added. If not, manually add your domains after setting up Firebase Hosting
    - In order to run the app in development locally, you will need to add `localhost` with a specific port like http://localhost:5000
    - When running Flutter in development on web, Flutter likes to use random ports, so instead run `flutter run -d chrome --web-port=5000` to use a specific port that you have authorised on Google Cloud
  - Specialised Dart Code for Google web authentication
    - On web, Google Sign In has to be implemented differently in Dart
    - Follow the instructions [here](https://firebase.flutter.dev/docs/auth/social) for implemeting Google authentication on web
    - For this app, I just caught a generic exception after the mobile Google authentication, and continued with the web Google authentication. You can feel free to implement somehting fancier with device detection
- CORS
  - Sadly, I never figured out how to allow CORS with this application. Therefore, no profile picture is loaded in the profile screen
- Web Deployment
  - There are many good tutorials for deploying with Firebase Hosting. [Here](https://medium.com/flutter/must-try-use-firebase-to-host-your-flutter-app-on-the-web-852ee533a469) is a good one
  - Follow the instructions on the Flutter CLI. I'm not sure if it's necessary to build before releasing, but to be safe it's nice to do a `flutter build web`
  - Finally to deploy, do `firebase deploy`, and hopefully you have correctly configured the deployment to target the `/build/web` directory
  - The app is now deployed! Check out the 'Hosting' tab on the Firebase console to view the deployment