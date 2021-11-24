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
    var state = Provider.of<QuizState>(context);

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // Question text
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            alignment: Alignment.center,
            child: Text(question.text),
          ),
        ),
        // Container with list of options
        Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: question.options.map((option) {
              return Container(
                height: 90,
                margin: const EdgeInsets.only(bottom: 10),
                color: Colors.black26,
                child: InkWell(
                  // Update selected option when one is tapped
                  onTap: () {
                    state.selected = option;
                    // Open the bottom sheet
                    _bottomSheet(context, option, state);
                  },
                  // Contains an icon and the option value
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(
                            state.selected == option
                                ? FontAwesomeIcons.checkCircle
                                : FontAwesomeIcons.circle,
                            size: 30),
                        Expanded(
                          child: Container(
                            margin: const EdgeInsets.only(left: 16),
                            child: Text(
                              option.value,
                              style: Theme.of(context).textTheme.bodyText2,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        )
      ],
    );
  }

  // Bottom sheet shown when Question is answered
  _bottomSheet(BuildContext context, Option option, QuizState state) {
    bool correct = option.correct;

    // Magic global method that opens a bottom sheet
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 250,
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              // Question correctness and explanation of right/wrong answer
              Text(correct ? 'Good Job!' : 'Wrong'),
              Text(
                option.detail,
                style: const TextStyle(fontSize: 18, color: Colors.white54),
              ),
              // Continue or try again depending on correctness
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: correct ? Colors.green : Colors.red),
                child: Text(
                  correct ? 'Onward!' : 'Try Again',
                  style: const TextStyle(
                    color: Colors.white,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // Navigate based on whether the question was correct
                onPressed: () {
                  if (correct) {
                    state.nextPage();
                  }
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
