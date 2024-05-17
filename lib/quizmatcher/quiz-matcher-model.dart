import 'package:flutter/cupertino.dart';

class QuestionWidget {
  /// pass widget as a question
  final Widget widget;

  /// global key for question
  final GlobalKey key;

  /// color of border
  final Color color;

  /// right answer key
  late String? rightAnswerKey;

  QuestionWidget(
      {required this.widget,
      required this.key,
      required this.color,
      this.rightAnswerKey});
}

class AnswerWidget {
  /// widget for answer
  final Widget widget;

  /// answer global key for unique identifications
  final GlobalKey key;
  final Color color;

  AnswerWidget({required this.widget, required this.key, required this.color});
}

class Line {
  /// starting offset of pan
  late Offset panStartOffset;

  /// ending offset of pan
  late Offset panEndOffset;

  /// ans selection
  late bool ansSelection;

  /// color of points
  late Color colorOfPoint;

  Line(
      {required this.panStartOffset,
      required this.panEndOffset,
      required this.ansSelection,
      required this.colorOfPoint});
}

class UserScore {
  /// selected question index
  final int questionIndex;

  /// check answer is right or wrong
  final bool questionAnswer;

  UserScore({required this.questionIndex, required this.questionAnswer});
}
