library flutter_quiz_matcher;

import 'dart:math';

import 'package:belajarkognitif/global_variabel.dart';
import 'package:belajarkognitif/quizmatcher/painter.dart';
import 'package:belajarkognitif/quizmatcher/quiz-matcher-model.dart';
import 'package:belajarkognitif/quizmatcher/quiz-matcher-global-ext.dart';
import 'package:belajarkognitif/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:confetti/confetti.dart';
import 'package:audioplayers/audioplayers.dart';

typedef OnScoreUpdate = void Function(UserScore userAnswers);

class QuizMatcher extends StatefulWidget {
  const QuizMatcher({
    super.key,
    required this.questions,
    required this.answers,
    required this.onScoreUpdated,
    required this.defaultLineColor,
    required this.correctLineColor,
    required this.incorrectLineColor,
    required this.drawingLineColor,
    required this.paddingAround,
    this.backgroundColor,
    required this.backgroundAudioPlayer,
  });

  final List<Widget> questions;
  final List<Widget> answers;
  final Color defaultLineColor;
  final Color correctLineColor;
  final Color incorrectLineColor;
  final OnScoreUpdate onScoreUpdated;
  final Color drawingLineColor;
  final EdgeInsets paddingAround;
  final Color? backgroundColor;
  final AudioPlayer backgroundAudioPlayer; // Tambahkan atribut

  @override
  State<QuizMatcher> createState() => _QuizMatcherState();
}

class _QuizMatcherState extends State<QuizMatcher>
    with SingleTickerProviderStateMixin {
  late Animation<double> animation;
  late AnimationController controller;
  final List<QuestionWidget> widgetDataQuestions = [];
  final List<AnswerWidget> widgetDataAnswer = [];
  late List<AnswerWidget> widgetDataAnswerBeforeShuffle = [];
  final List<bool> userAnswers = [];
  List<Line> listLine = [];
  late Offset p1 = Offset.zero;
  late Offset p2 = Offset.zero;
  late int score = 0;
  final List<GlobalKey> globalImageKeyList = [];
  final List<GlobalKey> globalAnswerKeyList = [];
  late List<Offset> points = <Offset>[];
  late int animationIndex = 0;
  late ConfettiController _controllerSuccess;
  late ConfettiController _controllerFailed;
  late AudioPlayer _audioPlayer = AudioPlayer();
  bool _isBackgroundAudioPlaying = false;
  @override
  void initState() {
    super.initState();
    for (int i = 0; i < widget.questions.length; i++) {
      globalImageKeyList.add(GlobalKey());
      globalAnswerKeyList.add(GlobalKey());

      widgetDataQuestions.add(QuestionWidget(
        widget: widget.questions[i],
        key: globalImageKeyList[i],
        color: widget.defaultLineColor,
      ));

      widgetDataAnswer.add(AnswerWidget(
        widget: widget.answers[i],
        key: globalAnswerKeyList[i],
        color: widget.defaultLineColor,
      ));

      _controllerSuccess =
          ConfettiController(duration: const Duration(seconds: 2));
      _controllerFailed =
          ConfettiController(duration: const Duration(seconds: 2));
    }

    widgetDataAnswerBeforeShuffle = widgetDataAnswer;
    for (int i = 0; i < widgetDataQuestions.length; i++) {
      widgetDataQuestions[i].rightAnswerKey =
          widgetDataAnswerBeforeShuffle[i].key.toString();
    }
    widgetDataAnswer.shuffle();
    for (int i = 0; i < widget.questions.length; i++) {
      listLine.add(Line(
          panStartOffset: Offset.zero,
          panEndOffset: Offset.zero,
          ansSelection: false,
          colorOfPoint: widget.defaultLineColor));
    }
    controller = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);

    animation = Tween(begin: 0.0, end: 1.0).animate(controller)
      ..addListener(() {
        setState(() {});
      });

    _isBackgroundAudioPlaying = true; // Set status pemutaran latar belakang
    _resumeBackgroundAudio();
  }

  void _pauseBackgroundAudio() async {
    if (_isBackgroundAudioPlaying) {
      await widget.backgroundAudioPlayer.pause(); // Pause latar belakang
      _isBackgroundAudioPlaying = false; // Perbarui status pemutaran
    }
  }

  void _resumeBackgroundAudio() async {
    if (!_isBackgroundAudioPlaying) {
      await widget.backgroundAudioPlayer.resume(); // Lanjutkan latar belakang
      _isBackgroundAudioPlaying = true; // Perbarui status pemutaran
    }
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  Future<void> _playSound(String url) async {
    _pauseBackgroundAudio(); // Pause latar belakang saat memainkan suara ang
    AudioCache.instance = AudioCache(prefix: '');
    final player = AudioPlayer();
    await player.play(AssetSource(url));
    await player.onPlayerComplete.first; // Tunggu sampai suara angka selesai
    _resumeBackgroundAudio(); // Lanjutkan latar belakang setelah suara angka selesai
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _audioPlayer.dispose();
    _controllerSuccess.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool allQuestionsAnswered = userAnswers.length == widget.questions.length;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: primary,
      body: Container(
        child: GestureDetector(
          onPanUpdate: (DragUpdateDetails details) {
            ////
            p2 = details.globalPosition;
            List<Rect> questionsOffset = List.generate(
              widget.questions.length,
              (i) => widgetDataQuestions[i].key.globalPaintBounds!,
            );

            List<Rect> answersOffset = List.generate(
              widget.answers.length,
              (i) => widgetDataAnswer[i].key.globalPaintBounds!,
            );

            RenderBox box = context.findRenderObject() as RenderBox;
            Offset point = box.localToGlobal(details.localPosition);

            bool isInOffset(List<Rect> offsets) {
              return offsets.any(
                (offset) =>
                    p2.dx >= offset.left &&
                    p2.dx <= offset.right &&
                    p2.dy >= offset.top &&
                    p2.dy <= offset.bottom,
              );
            }

            if (!isInOffset(questionsOffset) && !isInOffset(answersOffset)) {
              points = List.from(points)..add(point);
            }
            setState(() {});
          },
          onPanEnd: (DragEndDetails details) {
            points.clear();

            List<Rect> questionsOffset = List.generate(
              widget.questions.length,
              (i) => widgetDataQuestions[i].key.globalPaintBounds!,
            );

            List<Rect> answersOffset = List.generate(
              widget.answers.length,
              (i) => widgetDataAnswer[i].key.globalPaintBounds!,
            );

            for (int i = 0; i < questionsOffset.length; i++) {
              if (listLine[i].panStartOffset == Offset.zero &&
                  questionsOffset[i].contains(p1)) {
                bool answerSelected =
                    false; // Flag to track if an answer is selected
                for (int j = 0; j < answersOffset.length; j++) {
                  if (answersOffset[j].contains(p2)) {
                    if (listLine[j].ansSelection == false) {
                      if (widgetDataQuestions[i].rightAnswerKey.toString() ==
                          widgetDataAnswer[j].key.toString()) {
                        score += 1;
                        userAnswers.add(true);
                        widget.onScoreUpdated(
                            UserScore(questionIndex: i, questionAnswer: true));
                        listLine[i].colorOfPoint = widget.correctLineColor;
                      } else {
                        listLine[i].colorOfPoint = widget.incorrectLineColor;
                        userAnswers.add(false);
                        widget.onScoreUpdated(
                            UserScore(questionIndex: i, questionAnswer: false));
                      }
                      listLine[i].panEndOffset = Offset(answersOffset[j].left,
                          answersOffset[j].top + answersOffset[j].height / 2);
                      listLine[i].panStartOffset = Offset(
                          questionsOffset[i].right,
                          questionsOffset[i].bottom -
                              questionsOffset[i].height / 2);
                      listLine[j].ansSelection = true;
                      answerSelected = true; // Set the flag to true
                    } else {
                      // Clear the line and selection if a wrong answer is selected again
                      listLine[i].panStartOffset = Offset.zero;
                      listLine[i].panEndOffset = Offset.zero;
                      listLine[j].ansSelection = false;
                      listLine[i].colorOfPoint =
                          widget.defaultLineColor; // Reset color to default
                    }
                  }
                }
                // If no answer is selected, reset the line and color
                if (!answerSelected) {
                  listLine[i].panStartOffset = Offset.zero;
                  listLine[i].panEndOffset = Offset.zero;
                  listLine[i].colorOfPoint =
                      widget.defaultLineColor; // Reset color to default
                }
                if (animationIndex <= widgetDataAnswer.length) {
                  animationIndex = i + 1;
                } else {
                  animationIndex = 0;
                }
              }
            }
            if (userAnswers.length == widget.questions.length) {
              // Check if the score is equal to the total number of questions
              if (score == widget.questions.length) {
                // If all questions are answered correctly, play success animation
                _playSound('audio/game/winning-quiz.wav');
                _controllerSuccess.play();
              } else {
                // If there are incorrect answers or some questions are unanswered, play failed animation
                _playSound('audio/game/losing-quiz.wav');
                _controllerFailed.play();
              }
            }

            controller.forward(from: 0);
            setState(() {});
          },
          onPanStart: (details) {
            List<Rect> questionsOffset = [];
            for (int i = 0; i < widget.questions.length; i++) {
              questionsOffset
                  .add(widgetDataQuestions[i].key.globalPaintBounds!);
            }

            for (int i = 0; i < questionsOffset.length; i++) {
              if (questionsOffset[i].contains(details.globalPosition)) {
                p1 = details.globalPosition;
                break; // Exit the loop once a match is found
              }
            }
          },
          child: Stack(
            children: [
              Column(
                children: [
                  //TOP CENTER - shoot down

                  Container(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: IconButton(
                        icon: Icon(
                          size: 41.0,
                          Icons.close_outlined,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          // do something
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Home()));
                        },
                      ),
                    ),
                  ),
                  Container(
                    height: 125,
                    child: Text(
                      'Rangkai\nPuzzel Ini',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        color: Colors.black,
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 230,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      color: greybackground,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Score: $score', // Display the score here
                        textAlign: TextAlign.center,
                        style: GoogleFonts.montserrat(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20), // Add spacing if needed
                  // Your existing quiz container
                  Container(
                    color: widget.backgroundColor ?? Colors.transparent,
                    child: ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return Padding(
                          padding: widget.paddingAround,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                key: widgetDataQuestions[index].key,
                                child: widgetDataQuestions[index].widget,
                              ),
                              const Spacer(),
                              SizedBox(
                                key: widgetDataAnswer[index].key,
                                child: widgetDataAnswer[index].widget,
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 16,
                        );
                      },
                      itemCount: widgetDataQuestions.length,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    allQuestionsAnswered
                        ? (score == widget.questions.length
                            ? "Berhasil"
                            : "Gagal")
                        : "", // Tampilkan pesan sesuai dengan kondisi
                    style: TextStyle(
                      fontFamily: 'SuperCosmic',
                      fontSize: 45,
                      color: allQuestionsAnswered
                          ? (score == widget.questions.length
                              ? Colors.green
                              : redbase)
                          : Colors.transparent, // Sesuaikan warna teks
                    ),
                  ),
                ],
              ),
              Container(
                color: const Color.fromRGBO(25, 0, 0, 0.2),
                child: Stack(
                  children: [
                    for (int i = 0; i < widget.questions.length; i++)
                      CustomPaint(
                        painter: Sketcher(
                            p1: listLine[i].panStartOffset,
                            p2: listLine[i].panEndOffset,
                            color: listLine[i].colorOfPoint,
                            progress:
                                animationIndex == i + 1 ? controller.value : 1),
                      ),
                  ],
                ),
              ),
              Container(
                color: const Color.fromRGBO(25, 0, 0, 0.2),
                child: CustomPaint(
                  painter: SketcherRealtime(points, widget.drawingLineColor),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _controllerSuccess,
                  blastDirectionality: BlastDirectionality.explosive, // ,
                  maxBlastForce: 5, // set a lower max blast force
                  minBlastForce: 1, // set a lower min blast force
                  emissionFrequency: 0.05,
                  numberOfParticles: 20, // a lot of particles at once
                  gravity: 0.5,
                  colors: const [
                    Colors.green,
                    Colors.blue,
                    Colors.pink,
                    Colors.orange,
                    Colors.purple
                  ], // manually specify the colors to be used
                  createParticlePath: drawStar, // define a custom shape/path.
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
