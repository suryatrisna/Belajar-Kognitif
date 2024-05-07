import 'package:belajarkognitif/global_variabel.dart';
import 'package:belajarkognitif/screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:audioplayers/audioplayers.dart';

void main() {
  runApp(const BelajarHuruf());
}

class BelajarHuruf extends StatelessWidget {
  const BelajarHuruf({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: BelajarHurufPage());
  }
}

class BelajarHurufPage extends StatefulWidget {
  const BelajarHurufPage({super.key});

  @override
  State<BelajarHurufPage> createState() => _BelajarHurufPage();
}

class _BelajarHurufPage extends State<BelajarHurufPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  AudioPlayer _audioPlayer = AudioPlayer();

  @override
  void dispose() {
    // TODO: implement dispose
    _audioPlayer.dispose();
    super.dispose();
  }

  final List<String> hurufImage = [
    'image/huruf/letter-a.png',
    'image/huruf/letter-b.png',
    'image/huruf/letter-c.png',
    'image/huruf/letter-d.png',
    'image/huruf/letter-e.png',
    'image/huruf/letter-f.png',
    'image/huruf/letter-g.png',
    'image/huruf/letter-h.png',
    'image/huruf/letter-i.png',
    'image/huruf/letter-j.png',
    'image/huruf/letter-k.png',
    'image/huruf/letter-l.png',
    'image/huruf/letter-m.png',
    'image/huruf/letter-n.png',
    'image/huruf/letter-o.png',
    'image/huruf/letter-p.png',
    'image/huruf/letter-q.png',
    'image/huruf/letter-r.png',
    'image/huruf/letter-s.png',
    'image/huruf/letter-t.png',
    'image/huruf/letter-u.png',
    'image/huruf/letter-v.png',
    'image/huruf/letter-w.png',
    'image/huruf/letter-x.png',
    'image/huruf/letter-y.png',
    'image/huruf/letter-z.png',
  ];

  final List<String> hurufAudio = [
    'audio/huruf/huruf-A.mp3',
    'audio/huruf/huruf-B.mp3',
    'audio/huruf/huruf-C.mp3',
    'audio/huruf/huruf-D.mp3',
    'audio/huruf/huruf-E.mp3',
    'audio/huruf/huruf-F.mp3',
    'audio/huruf/huruf-G.mp3',
    'audio/huruf/huruf-H.mp3',
    'audio/huruf/huruf-I.mp3',
    'audio/huruf/huruf-J.mp3',
    'audio/huruf/huruf-K.mp3',
    'audio/huruf/huruf-L.mp3',
    'audio/huruf/huruf-M.mp3',
    'audio/huruf/huruf-N.mp3',
    'audio/huruf/huruf-O.mp3',
    'audio/huruf/huruf-P.mp3',
    'audio/huruf/huruf-Q.mp3',
    'audio/huruf/huruf-R.mp3',
    'audio/huruf/huruf-S.mp3',
    'audio/huruf/huruf-T.mp3',
    'audio/huruf/huruf-U.mp3',
    'audio/huruf/huruf-V.mp3',
    'audio/huruf/huruf-W.mp3',
    'audio/huruf/huruf-X.mp3',
    'audio/huruf/huruf-Y.mp3',
    'audio/huruf/huruf-Z.mp3',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Text(
                'Pengenalan\nHuruf',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  color: Colors.black,
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: 26, // Total number of pages (A-Z)
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
                            hurufImage[index],
                            width: 200, // Adjust image size as needed
                            height: 200,
                          ),
                          SizedBox(
                            height: 94.0,
                          ),
                          Text(
                            "Huruf " +
                                String.fromCharCode('A'.codeUnitAt(0) + index),
                            style: GoogleFonts.montserrat(
                              color: Colors.black,
                              fontSize: 40,
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
                                    .play(AssetSource(hurufAudio[index]));
                              },
                              icon: Image.asset(
                                'image/icon/volume-1.png',
                                width: 65,
                                height: 47,
                              )),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                height: 200,
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
                            width: 75,
                            height: 75,
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
                            width: 75,
                            height: 75,
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
