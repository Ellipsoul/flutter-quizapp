import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quizapp/quiz/quiz.dart';
import 'package:quizapp/services/services.dart';

// Scrollable drawer showing completed topics
class TopicDrawer extends StatelessWidget {
  final List<Topic> topics;
  const TopicDrawer({
    Key? key,
    required this.topics,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      // Scrollable list of topics and the quizzes
      child: ListView.separated(
        shrinkWrap: true,
        itemCount: topics.length,
        // Retrieve the index of the target topic
        itemBuilder: (BuildContext context, int idx) {
          Topic topic = topics[idx];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title of topic
              Padding(
                padding: const EdgeInsets.only(top: 5, left: 20),
                child: Text(
                  topic.title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              ),
              QuizList(topic: topic)
            ],
          );
        },
        // Simple divider between each item
        separatorBuilder: (BuildContext context, int idx) => const Divider(),
      ),
    );
  }
}

// List of quizzes under each topic
class QuizList extends StatelessWidget {
  final Topic topic;
  const QuizList({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: topic.quizzes.map(
        (quiz) {
          return Card(
            shape:
                const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
            elevation: 4,
            margin: const EdgeInsets.all(4),
            child: InkWell(
              // Redirect to the Quiz Screen
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) =>
                        QuizScreen(quizId: quiz.id),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(
                    quiz.title,
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  subtitle: Text(
                    quiz.description,
                    overflow: TextOverflow.fade,
                    style: Theme.of(context).textTheme.subtitle2,
                  ),
                  leading: QuizBadge(topic: topic, quizId: quiz.id),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}

// Shows whether the Quiz has been completed (read from Firestore)
class QuizBadge extends StatelessWidget {
  final String quizId;
  final Topic topic;

  const QuizBadge({Key? key, required this.quizId, required this.topic})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve an instance of the provided report
    Report report = Provider.of<Report>(context);
    // Filter to see if the topic id is present
    // ignore: strict_raw_type
    List completed = report.topics[topic.id] ?? [];
    if (completed.contains(quizId)) {
      return const Icon(FontAwesomeIcons.checkDouble, color: Colors.green);
    } else {
      return const Icon(FontAwesomeIcons.solidCircle, color: Colors.grey);
    }
  }
}
