import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/services/services.dart';
import 'package:quizapp/shared/shared.dart';

// Simple user profile screen, also for signing out
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve instances of the user report and authenticated user object
    var report = Provider.of<Report>(context);
    var user = AuthService().user;

    if (user != null) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepOrange,
          title: const Text('Profile'),
        ),
        // This container will be sad if window is sized to be too small!
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile picture
              // Using a static asset to avoid CORS policy on web
              Container(
                width: 200,
                height: 200,
                margin: const EdgeInsets.only(top: 50, bottom: 20),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: AssetImage('assets/hacker.png'),
                  ),
                ),
              ),
              // User information
              Text(
                !user.isAnonymous ? '${user.displayName}' : 'Anonymous User',
                style: Theme.of(context).textTheme.headline5,
              ),
              const SizedBox(
                // Best way to add space between items
                height: 5,
              ),
              Text(
                user.email ?? 'Missing Email',
                style: Theme.of(context).textTheme.headline6,
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                'User ID: ${user.uid}',
                style: Theme.of(context).textTheme.bodyText2,
              ),
              const Spacer(),
              // Shows the quizzes completed from report
              Text(
                '${report.total}',
                style: Theme.of(context).textTheme.headline2,
              ),
              Text(
                report.total != 1 ? 'Quizzes Completed' : 'Quiz Completed',
                style: Theme.of(context).textTheme.subtitle2,
              ),
              const Spacer(),
              // Logic for signing out and returning to home page
              ElevatedButton(
                child: const Text('Sign Out'),
                onPressed: () async {
                  await AuthService().signOut();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/', (route) => false);
                },
              ),
              const Spacer(),
            ],
          ),
        ),
      );
    } else {
      return const Loader();
    }
  }
}
