import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/quiz/quiz_state.dart';
import 'package:quizapp/services/firestore.dart';
import 'package:quizapp/services/services.dart';
import 'package:quizapp/shared/shared.dart';

// Main Quiz UI
class QuizScreen extends StatelessWidget {
  final String quizId;
  const QuizScreen({Key? key, required this.quizId}) : super(key: key);

  // This widget will have internal state like user answers
  // Can convert into a stateful widget, but business logic mixed with UI
  @override
  Widget build(BuildContext context) {
    // Instead, use provider to decouple the state from the widget
    return ChangeNotifierProvider(
      // Instantiates a class containing the data to be used
      // Reusable on multiple widgets
      create: (_) => QuizState(),
      child: FutureBuilder<Quiz>(
        // Retrieve the quiz information from Firestore
        future: FirestoreService().getQuiz(quizId),
        builder: (context, snapshot) {
          // Access the quiz state like this
          var state = Provider.of<QuizState>(context);
          // Show loader when data isn't ready yet
          if (!snapshot.hasData || snapshot.hasError) {
            return const Loader();
          } else {
            // Scaffoled will contain the progress bar and a return option
            return Scaffold(
              appBar: AppBar(
                title: AnimatedProgressBar(
                  value: state.progress,
                ),
                leading: IconButton(
                  icon: const Icon(FontAwesomeIcons.times),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
