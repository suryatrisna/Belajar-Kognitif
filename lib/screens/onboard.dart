import 'package:audioplayers/audioplayers.dart';
import 'package:belajarkognitif/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:belajarkognitif/global_variabel.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({super.key});

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  RichText(
                      text: TextSpan(
                          style: TextStyle(
                              fontFamily: 'SuperCosmic', fontSize: 64),
                          children: <TextSpan>[
                        TextSpan(text: 'P', style: TextStyle(color: redbase)),
                        TextSpan(text: 'LAY\n'),
                        TextSpan(text: 'A'),
                        TextSpan(text: 'N', style: TextStyle(color: redbase)),
                        TextSpan(text: 'D\n'),
                        TextSpan(text: 'LEA'),
                        TextSpan(text: 'R', style: TextStyle(color: redbase)),
                        TextSpan(text: 'N'),
                      ])),
                  SizedBox(
                    height: 16,
                  ),
                  Image(
                    image: AssetImage(
                      'image/onboard/book.png',
                    ),
                    height: 266,
                    width: 266,
                  ),
                  SizedBox(
                    height: 27,
                  ),
                  TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => Home()));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: yellowbase,
                        ),
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        child: Text(
                          'MULAI',
                          style: GoogleFonts.montserrat(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ))
                ],
              )))),
    );
  }
}
