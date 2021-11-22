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
}
