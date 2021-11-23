import 'package:flutter/material.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/shared/shared.dart';

import 'package:quizapp/services/models.dart';

class TopicsScreen extends StatelessWidget {
  const TopicsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Topic>>(
      future: FirestoreService().getTopics(), // Retrieve topics from firestore
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingScreen();
        } else if (snapshot.hasError) {
          return Center(
            child: ErrorMessage(message: snapshot.error.toString()),
          );
        } else if (snapshot.hasData) {
          // Main logic contained in here
          var topics = snapshot.data!; // Typed in FutureBuilder

          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.deepPurple,
              title: const Text('Topics'),
            ),
            // Gridview,count puts a fixed number of items on the x axis
            body: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(20.0),
              crossAxisSpacing: 10.0,
              crossAxisCount: 2,
              children: topics.map((topic) => Text(topic.title)).toList(),
            ),
            bottomNavigationBar: const BottomNavBar(),
          );
        } else {
          return const Text('No topics found in Firestore. Check database');
        }
      },
    );
  }
}
