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
            var quiz = snapshot.data!;

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
              // Build each page dynamically based on data from Firebase
              body: PageView.builder(
                physics: const NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                // Class to change state of page view
                controller: state.controller,
                // Update the progress bar when the page changes
                onPageChanged: (int idx) =>
                    state.progress = (idx / (quiz.questions.length + 1)),
                itemBuilder: (BuildContext context, int idx) {
                  if (idx == 0) {
                    // Starting page
                    return StartPage(quiz: quiz);
                  } else if (idx == quiz.questions.length + 1) {
                    // Finished quiz page
                    return CongratsPage(quiz: quiz);
                  } else {
                    // Question page
                    return QuestionPage(question: quiz.questions[idx - 1]);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }
}

// Page before a user starts a quiz
class StartPage extends StatelessWidget {
  final Quiz quiz;
  const StartPage({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<QuizState>(context);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        // Contains the Quiz title and a button to start the quiz
        children: [
          Text(quiz.title, style: Theme.of(context).textTheme.headline4),
          const Divider(),
          Expanded(child: Text(quiz.description)),
          ButtonBar(
            alignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton.icon(
                // Moved to the next page when buton is pressed
                onPressed: state.nextPage,
                label: const Text('Start Quiz!'),
                icon: const Icon(Icons.poll),
              )
            ],
          )
        ],
      ),
    );
  }
}

// Final page after completing a quiz
class CongratsPage extends StatelessWidget {
  final Quiz quiz;
  const CongratsPage({Key? key, required this.quiz}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      // Contains congrats message and gif, and option to mark completed
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Congrats! You completed the ${quiz.title} quiz',
            textAlign: TextAlign.center,
          ),
          const Divider(),
          Image.asset('assets/congrats.gif'),
          const Divider(),
          ElevatedButton.icon(
            style: TextButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            icon: const Icon(FontAwesomeIcons.check),
            label: const Text(' Mark Complete!'),
            // Updates user report document on Firestore
            // Then navigates back to the topics screen
            onPressed: () {
              FirestoreService().updateUserReport(quiz);
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/topics',
                (route) => false,
              );
            },
          )
        ],
      ),
    );
  }
}

// Question page during the quiz
class QuestionPage extends StatelessWidget {
  final Question question;
  const QuestionPage({Key? key, required this.question}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
