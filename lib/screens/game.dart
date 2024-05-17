import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:belajarkognitif/quizmatcher/quiz-matcher.dart';
import 'package:belajarkognitif/quizmatcher/quiz-model.dart';
import '../quizmatcher/quiz-matcher-model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import '../global_variabel.dart';

import 'home.dart';

class Game extends StatelessWidget {
  final AudioPlayer backgroundAudioPlayer;

  const Game({Key? key, required this.backgroundAudioPlayer}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: GamePage(backgroundAudioPlayer: backgroundAudioPlayer));
  }
}

class GamePage extends StatefulWidget {
  final AudioPlayer backgroundAudioPlayer; // Tambahkan atribut
  const GamePage({Key? key, required this.backgroundAudioPlayer})
      : super(key: key);

  @override
  State<GamePage> createState() => _GamePage();
}

class _GamePage extends State<GamePage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  AudioPlayer _audioPlayer = AudioPlayer();

  final List<Quiz> _quizData = [
    Quiz(imageUrl: 'image/angka/Angka-0.png', answer: 'Angka 0'),
    Quiz(imageUrl: 'image/huruf/letter-a.png', answer: 'Huruf A'),
    Quiz(imageUrl: 'image/warna/warna-biru.png', answer: 'Warna Biru'),
    Quiz(imageUrl: 'image/warna/warna-merah.png', answer: 'Warna Merah'),
    Quiz(imageUrl: 'image/angka/Angka-1.png', answer: 'Angka 1'),
    Quiz(imageUrl: 'image/huruf/letter-b.png', answer: 'Huruf B'),
    Quiz(imageUrl: 'image/warna/warna-hijau.png', answer: 'Warna Hijau'),
    Quiz(imageUrl: 'image/warna/warna-kuning.png', answer: 'Warna Kuning'),
    Quiz(imageUrl: 'image/angka/Angka-2.png', answer: 'Angka 2'),
    Quiz(imageUrl: 'image/huruf/letter-c.png', answer: 'Huruf C'),
  ];

  late List<Quiz> _selectedQuizData;

  @override
  void initState() {
    super.initState();
    _initializeQuizData();
  }

  void _initializeQuizData() {
    _selectedQuizData = _getRandomQuizData();
  }

  List<Quiz> _getRandomQuizData() {
    final random = Random();
    List<Quiz> tempQuizData = List.from(_quizData);
    tempQuizData.shuffle(random);
    return tempQuizData.take(3).toList();
  }

  void _randomizeQuizData() {
    setState(() {
      _selectedQuizData = _getRandomQuizData();
      print(
          "New quiz data: ${_selectedQuizData.map((quiz) => quiz.answer).toList()}");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: QuizMatcher(
              backgroundAudioPlayer: widget.backgroundAudioPlayer,
              key: ValueKey(_selectedQuizData),
              backgroundColor: primary,
              questions: _selectedQuizData.map((quiz) {
                return Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        width: 2,
                        color: Colors.black,
                      ),
                      borderRadius: BorderRadius.circular(8)),
                  width: 100,
                  height: 100,
                  child: Image.asset(quiz.imageUrl),
                );
              }).toList(),
              answers: _selectedQuizData.map((quiz) {
                return Container(
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      border: Border.all(width: 2, color: Colors.black),
                      borderRadius: BorderRadius.circular(8)),
                  width: 100,
                  height: 100,
                  child: Text(quiz.answer),
                );
              }).toList(),
              defaultLineColor: Colors.black,
              correctLineColor: Colors.green,
              incorrectLineColor: Colors.red,
              drawingLineColor: Colors.black,
              onScoreUpdated: (UserScore userAnswers) {
                print(userAnswers.questionAnswer);
              },
              paddingAround: EdgeInsets.all(16.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: greybackground),
              child: TextButton.icon(
                onPressed: _randomizeQuizData,
                icon: Icon(Icons.refresh),
                label: Text(
                  'Coba lagi', // Display the score here
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
