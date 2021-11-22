import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';
import 'package:quizapp/services/auth.dart';
import 'package:quizapp/services/models.dart';

class FirestoreService {
  // Grab an instance of the firestore database
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Retrieve the topics which will be displayed on the topics screen
  Future<List<Topic>> getTopics() async {
    var ref = _db.collection('topics'); // Reference the firestore collection
    var snapshot = await ref.get(); // Retrieve a single snapshot of it
    // Just like with JS, retrieve the desired data from each document
    // Otherwise a lot of meta data will also be returned
    var data = snapshot.docs.map((s) => s.data());
    var topics = data.map((d) => Topic.fromJson(d)); // Convert to a class

    return topics.toList();
  }

  // Retrieve a single quiz document from quizzes collection
  Future<Quiz> getQuiz(String quizId) async {
    var ref = _db.collection('quizzes').doc(quizId);
    var snapshot = await ref.get();
    return Quiz.fromJson(snapshot.data() ?? {});
  }

  // Listen to user's report document in Firestore
  Stream<Report> streamReport() {
    // The user authentication state may change, so it's a stream
    // But the user's report is also a stream, updating as they complete quizzes
    return AuthService().userStream.switchMap((user) {
      // Rxdart allows for switching between streams (switchMap)
      if (user != null) {
        // Listen to the report document in real time
        var ref = _db.collection('reports').doc(user.uid);
        return ref.snapshots().map((doc) => Report.fromJson(doc.data()!));
      } else {
        return Stream.fromIterable([Report()]);
      }
    });
  }

  // Update user report when they complete a quiz
  Future<void> updateUserReport(Quiz quiz) {
    var user = AuthService().user!; // Assert that user is always defined
    var ref = _db.collection('reports').doc(user.uid);

    // Firestore database uses string keys and dynamic values
    var data = {
      'total': FieldValue.increment(1),
      'topics': {
        quiz.topic: FieldValue.arrayUnion([quiz.id]) // Merge to existing array
      }
    };

    // Write to firestore, allowing for merging instead of overwriting
    return ref.set(data, SetOptions(merge: true));
  }
}
