import 'package:flutter/material.dart';
import 'package:quizapp/services/services.dart';

// Tracks the state of the quiz
// ChangeNotifier has a notifyListeners method that rerenders widgets
// when the data changes
class QuizState with ChangeNotifier {
  // Private variables to represent the state
  double _progress = 0;
  Option? _selected;

  // Getters and setters
  double get progress => _progress;
  Option? get selected => _selected;

  set progress(double newValue) {
    _progress = newValue;
    notifyListeners();
  }

  set selected(Option? newOption) {
    _selected = newOption;
    notifyListeners();
  }
}
