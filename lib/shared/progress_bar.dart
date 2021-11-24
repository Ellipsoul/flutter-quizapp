import 'package:flutter/material.dart';
import 'package:quizapp/services/models.dart';
import 'package:provider/provider.dart';

// Progress bar used in topic card and within the quiz
class AnimatedProgressBar extends StatelessWidget {
  final double value; // How filled up the bar is
  final double height; // How tall the bar physically is

  const AnimatedProgressBar({
    Key? key,
    required this.value,
    this.height = 12,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use this when size of widget is unknown before building
    return LayoutBuilder(builder: (BuildContext context, BoxConstraints box) {
      return Container(
        padding: const EdgeInsets.all(10),
        width: box.maxWidth,
        // Gray background with coloured bar on top
        child: Stack(
          children: [
            Container(
              height: height,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(height),
                ),
              ),
            ),
            // Works like a container, except animates between changes
            AnimatedContainer(
              duration: const Duration(milliseconds: 800),
              curve: Curves.easeOutCubic,
              height: height,
              width: box.maxWidth * _floor(value),
              decoration: BoxDecoration(
                // Dynamically generate the colour of the bar
                color: _colorGen(value),
                borderRadius: BorderRadius.all(
                  Radius.circular(height),
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  // Always round negative or NaNs to min value
  _floor(double value, [min = 0.0]) {
    return value.sign <= min ? min : value;
  }

  // Colours the progress bar relative to it's filled percentage
  _colorGen(double value) {
    int rbg = (value * 255).toInt();
    return Colors.deepOrange.withGreen(rbg).withRed(255 - rbg);
  }
}

// Progress bar to be used on the main topics screen
class TopicProgress extends StatelessWidget {
  final Topic topic;

  const TopicProgress({Key? key, required this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Report report = Provider.of<Report>(context);

    return Row(
      children: [
        _progressCount(report, topic),
        Expanded(
          child: AnimatedProgressBar(
              value: _calculateProgress(topic, report), height: 8),
        ),
      ],
    );
  }

  Widget _progressCount(Report report, Topic topic) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        '${report.topics[topic.id]?.length ?? 0} / ${topic.quizzes.length}',
        style: const TextStyle(fontSize: 10, color: Colors.grey),
      ),
    );
  }

  double _calculateProgress(Topic topic, Report report) {
    try {
      int totalQuizzes = topic.quizzes.length;
      int completedQuizzes = report.topics[topic.id].length;
      return completedQuizzes / totalQuizzes;
    } catch (err) {
      return 0.0;
    }
  }
}
