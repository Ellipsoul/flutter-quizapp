// Firestore data is returned as a MAP, with string keys and dynamic values
// Lose strong typing and intellisense if dynamic data types are imported
// Define classes with null safety and sound typing

import 'package:json_annotation/json_annotation.dart';
part 'models.g.dart';

@JsonSerializable()
class Option {
  String value;
  String detail;
  bool correct;
  Option({this.value = '', this.detail = '', this.correct = false});
  // Define this factory constructor that tells JsonSerialisable what to do
  factory Option.fromJson(Map<String, dynamic> json) => _$OptionFromJson(json);
  // Define a toJson method for each class to be called
  Map<String, dynamic> toJson() => _$OptionToJson(this);
}

// These classes all mimic the firestore database model
@JsonSerializable()
class Question {
  String text;
  List<Option> options;
  Question({this.options = const [], this.text = ''});
  factory Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);
  Map<String, dynamic> toJson() => _$QuestionToJson(this);
}

@JsonSerializable()
class Quiz {
  String id;
  String title;
  String description;
  String video;
  String topic;
  List<Question> questions;

  Quiz(
      {this.title = '',
      this.video = '',
      this.description = '',
      this.id = '',
      this.topic = '',
      this.questions = const []});
  factory Quiz.fromJson(Map<String, dynamic> json) => _$QuizFromJson(json);
  Map<String, dynamic> toJson() => _$QuizToJson(this);
}

class Topic {
  final String id;
  final String title;
  final String descripton;
  final String img;
  final List<Quiz> quizzes;

  // Always a good idea to have default values to work with null safety
  Topic(
      {this.id = 'default-id',
      this.title = 'Default Title',
      this.descripton = 'Default description',
      this.img = 'default.png',
      this.quizzes = const []});
}

@JsonSerializable()
class Report {
  String uid;
  int total;
  Map<String, dynamic> topics;

  Report({this.uid = '', this.topics = const {}, this.total = 0});
  factory Report.fromJson(Map<String, dynamic> json) => _$ReportFromJson(json);
  Map<String, dynamic> toJson() => _$ReportToJson(this);
}

// Ran this command to generate models.g.dart file:
// flutter pub run build_runner build
