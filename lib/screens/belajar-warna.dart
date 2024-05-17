import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../global_variabel.dart';
import 'home.dart';

class BelajarWarna extends StatelessWidget {
  final AudioPlayer backgroundAudioPlayer;

  const BelajarWarna({Key? key, required this.backgroundAudioPlayer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BelajarWarnaPage(backgroundAudioPlayer: backgroundAudioPlayer));
  }
}

class BelajarWarnaPage extends StatefulWidget {
  final AudioPlayer backgroundAudioPlayer; // Tambahkan atribut

  const BelajarWarnaPage({Key? key, required this.backgroundAudioPlayer})
      : super(key: key);

  @override
  State<BelajarWarnaPage> createState() => _BelajarWarnaPage();
}

class _BelajarWarnaPage extends State<BelajarWarnaPage> {
  PageController _pageController = PageController(initialPage: 0);
  int _currentPageIndex = 0;
  AudioPlayer _audioPlayer = AudioPlayer();
  bool _isBackgroundAudioPlaying =
      false; // Untuk menyimpan status pemutaran latar belakang

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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

  void _playWarnaAudio(int index) async {
    _pauseBackgroundAudio(); // Pause latar belakang saat memainkan suara angka
    AudioCache.instance = AudioCache(prefix: '');
    final player = AudioPlayer();
    await player.play(AssetSource(warnaAudio[index]));
    await player.onPlayerComplete.first; // Tunggu sampai suara angka selesai
    _resumeBackgroundAudio(); // Lanjutkan latar belakang setelah suara angka selesai
  }

  @override
  void dispose() {
    // TODO: implement dispose

    _audioPlayer.dispose();
    super.dispose();
  }

  final List<String> warnaImage = [
    'image/warna/warna-merah.png',
    'image/warna/warna-jingga.png',
    'image/warna/warna-kuning.png',
    'image/warna/warna-hijau.png',
    'image/warna/warna-biru.png',
    'image/warna/warna-nila.png',
    'image/warna/warna-ungu.png',
    'image/warna/warna-putih.png',
  ];

  final List<String> warnaAudio = [
    'audio/warna/warna-merah.mp3',
    'audio/warna/warna-jingga.mp3',
    'audio/warna/warna-kuning.mp3',
    'audio/warna/warna-hijau.mp3',
    'audio/warna/warna-biru.mp3',
    'audio/warna/warna-nila.mp3',
    'audio/warna/warna-ungu.mp3',
    'audio/warna/warna-putih.mp3',
  ];

  final List<String> colorNames = [
    'Merah',
    'Jingga',
    'Kuning',
    'Hijau',
    'Biru',
    'Nila',
    'Ungu',
    'Putih',
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
                  'Pengenalan\nWarna',
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
                  itemCount: 8, // Total number of pages (A-Z)
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
                            warnaImage[index],
                            width: 200, // Adjust image size as needed
                            height: 200,
                          ),
                          SizedBox(
                            height: 50.0,
                          ),
                          Text(
                            "Warna " +
                                colorNames[
                                    index], // Display color name from the list
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
                                _playWarnaAudio(index);
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
