import 'package:flutter/material.dart';

import 'package:quizapp/services/models.dart';
import 'package:quizapp/shared/shared.dart';
import 'package:quizapp/topics/drawer.dart';

class TopicItem extends StatelessWidget {
  final Topic topic;
  const TopicItem({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Special widget that animates between widgets of the same tag
    return Hero(
      tag: topic.img, // Use the image name as the tag here
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          // Navigate to the topic screen with each tap
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (BuildContext context) => TopicScreen(topic: topic),
              ),
            );
          },
          // Column with image and title
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                flex: 3,
                child: SizedBox(
                  child: Image.asset(
                    'assets/covers/${topic.img}',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 10,
                  ),
                  child: Text(
                    topic.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      height: 2,
                      fontWeight: FontWeight.bold,
                    ),
                    // Graceful text overflow
                    overflow: TextOverflow.fade,
                    softWrap: false,
                  ),
                ),
              ),
              // Progress of topic below name
              Flexible(child: TopicProgress(topic: topic)),
            ],
          ),
        ),
      ),
    );
  }
}

// Individual topic screens
class TopicScreen extends StatelessWidget {
  final Topic topic;

  const TopicScreen({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      // Contains the image and title directly underneath
      body: ListView(
        children: [
          Hero(
            tag: topic.img,
            // Useful media query to size the image as full-width
            child: Image.asset('assets/covers/${topic.img}',
                width: MediaQuery.of(context).size.width),
          ),
          Text(
            topic.title,
            style: const TextStyle(
              height: 2,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          // List of Quizzes (reused widget)
          QuizList(topic: topic),
        ],
      ),
    );
  }
}
