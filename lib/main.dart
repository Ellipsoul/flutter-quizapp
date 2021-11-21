import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:quizapp/routes.dart';
import 'package:quizapp/theme.dart';

// This is called to run the application
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

/// We are using a StatefulWidget such that we only create the [Future] once,
/// no matter how many times our widget rebuild.
/// If we used a [StatelessWidget], in the event where [App] is rebuilt, that
/// would re-initialize FlutterFire and make our application re-enter loading state,
/// which is undesired.
class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Initialize FlutterFire:
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          return const Text(
            'error',
            textDirection: TextDirection.ltr,
          );
        }

        // Once complete, show your application
        if (snapshot.connectionState == ConnectionState.done) {
          // Once routes are added here, don't add anything else to this main file
          return MaterialApp(
            routes: appRoutes, // Import the routes into the base app
            theme: appTheme,
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete
        return const Text(
          'loading',
          textDirection: TextDirection.ltr,
        );
      },
    );
  }
}
