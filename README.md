# quizapp

A new Flutter project.



- Apple Store deployment: $100/year
- Google Play deployment: $25 one time

#### Web Deployment Tips

- Include this to configure Firestore and initialise app: https://firebase.flutter.dev/docs/installation/web/
- Then go to each of the tools' overview and include: https://firebase.flutter.dev/docs/firestore/overview
- Finally for Google Sign in add a meta tag following this: https://github.com/flutter/plugins/blob/master/packages/google_sign_in/google_sign_in_web/README.md#web-integration
  - Go to Firebase/Google Cloud and grab the OAuth Client ID, https://console.cloud.google.com/apis/credentials
  - Also while here, add the URI that you will use, like http://localhost:5000
  - The Firebase hosting URIs should be configured there already, like https://flutter-quizapp-5e713.web.app and https://flutter-quizapp-5e713.firebaseapp.com
  - When running on web, do `flutter run -d chrome --web-port=5000`
  - The localhost port 5000 uri is specifically listed as an allowed domain on Google Cloud
- CORS is going to prevent a the user display photo from loading! Avoid and use a static image or do something risky and disable some security rules (not sure if it'll even work on production)
- Google Sign in will work dfferently on web!
  - https://firebase.flutter.dev/docs/auth/social
  - Just put it below the native authentication and catch the error
- Deploy by following this https://medium.com/flutter/must-try-use-firebase-to-host-your-flutter-app-on-the-web-852ee533a469
  - Follow instructions, but probably still do a `flutter build web` before `firebase deploy` just to be safe
  - Check out the 'hosting' section on Firebase console
- Mention that Apple Sign In is just bugged


## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
