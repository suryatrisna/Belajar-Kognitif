import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../global_variabel.dart';
import 'home.dart';

void main() {
  runApp(const BelajarAngka());
}

class BelajarAngka extends StatelessWidget {
  const BelajarAngka({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, home: BelajarAngkaPage(
    ));
  }
}

class BelajarAngkaPage extends StatefulWidget {
  const BelajarAngkaPage({super.key});

  @override
  State<BelajarAngkaPage> createState() => _BelajarAngkaPage();
}

class _BelajarAngkaPage extends State<BelajarAngkaPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    // TODO: implement dispose
    _audioPlayer.dispose();
    super.dispose();
  }

  final List<String> angkaImage = [
    'image/angka/Angka-0.png',
    'image/angka/Angka-1.png',
    'image/angka/Angka-2.png',
    'image/angka/Angka-3.png',
    'image/angka/Angka-4.png',
    'image/angka/Angka-5.png',
    'image/angka/Angka-6.png',
    'image/angka/Angka-7.png',
    'image/angka/Angka-8.png',
    'image/angka/Angka-9.png',
    'image/angka/Angka-10.png',
  ];

  final List<String> angkaAudio = [
    'audio/angka/angka-0.mp3',
    'audio/angka/angka-1.mp3',
    'audio/angka/angka-2.mp3',
    'audio/angka/angka-3.mp3',
    'audio/angka/angka-4.mp3',
    'audio/angka/angka-5.mp3',
    'audio/angka/angka-6.mp3',
    'audio/angka/angka-7.mp3',
    'audio/angka/angka-8.mp3',
    'audio/angka/angka-9.mp3',
    'audio/angka/angka-10.mp3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
              icon: Icon(
                size: 41.0,
                Icons.close_outlined,
                color: Colors.black,
              ),
              onPressed: () {
                // do something
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Home()));
              },
            ),
          )
        ],
      ),
      backgroundColor: primary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 125,
                child: Text(
                  'Pengenalan\nAngka',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.montserrat(
                    color: Colors.black,
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 11, // Total number of pages (A-Z)
                  onPageChanged: (int index) {
                    setState(() {
                      _currentPageIndex = index;
                    });
                  },
                  itemBuilder: (BuildContext context, int index) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            angkaImage[index],
                            width: 200, // Adjust image size as needed
                            height: 200,
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Text(
                            "Angka " + index.toString(),
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 17.0,
                          ),
                          IconButton(
                              onPressed: () async {
                                AudioCache.instance = AudioCache(prefix: '');
                                final player = AudioPlayer();
                                await player
                                    .play(AssetSource(angkaAudio[index]));
                              },
                              icon: Image.asset(
                                'image/icon/volume-1.png',
                                width: 50,
                                height: 40,
                              )),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      IconButton(
                          onPressed: () {
                            if (_currentPageIndex > 0) {
                              _pageController.previousPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            }
                          },
                          icon: Image.asset(
                            'image/icon/previous.png',
                            width: 70,
                            height: 70,
                          )),
                      Spacer(
                        flex: 1,
                      ),
                      IconButton(
                          onPressed: () {
                            if (_currentPageIndex < 25) {
                              _pageController.nextPage(
                                  duration: Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            }
                          },
                          icon: Image.asset(
                            'image/icon/next.png',
                            width: 70,
                            height: 70,
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
