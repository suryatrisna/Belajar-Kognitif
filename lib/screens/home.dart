import 'dart:ui';
import 'package:belajarkognitif/global_variabel.dart';
import 'package:belajarkognitif/screens/belajar-angka.dart';
import 'package:belajarkognitif/screens/belajar-huruf.dart';
import 'package:belajarkognitif/screens/belajar-warna.dart';
import 'package:belajarkognitif/screens/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const Home());
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final List<String> menuImages = [
    'image/home/menu_1.png',
    'image/home/menu_2.png',
    'image/home/menu_3.png',
    'image/home/menu_4.png',
  ];
  final List<String> menuTitles = [
    'Belajar Huruf',
    'Belajar Angka',
    'Belajar Warna',
    'Game',
  ];

  final List<String> menuIcon = [
    'image/icon/icon_1.png',
    'image/icon/icon_2.png',
    'image/icon/icon_3.png',
    'image/icon/icon_4.png',
  ];

// Define the screens corresponding to each menu item
  final List<Widget Function(BuildContext)> menuScreenBuilders = [
    (BuildContext context) => BelajarHuruf(),
    (BuildContext context) => BelajarAngka(),
    (BuildContext context) => BelajarWarna(),
    (BuildContext context) => Game(),
  ];

  MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                children: <TextSpan>[
                  TextSpan(text: 'HO', style: TextStyle(color: redbase)),
                  const TextSpan(text: 'ME'),
                ])),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                padding: const EdgeInsets.all(4.0),
                margin: const EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: Divider.createBorderSide(context,
                            color: Colors.white, width: 0.0)),
                    image: const DecorationImage(
                        image: AssetImage('image/menudrawer/bg.jpg'),
                        fit: BoxFit.cover)),
                child: Container()),
            ListTile(
              title: const Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.home),
              onTap: () {
                // Action untuk item 1
              },
            ),
            ListTile(
              title: const Text(
                'Saved',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.bookmark),
              onTap: () {
                // Action untuk item 2
              },
            ),
            ListTile(
              title: const Text(
                'Messeges',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.message_rounded),
              onTap: () {
                // Action untuk item 3
              },
            ),
            ListTile(
              title: const Text(
                'News',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: const Icon(Icons.newspaper),
              onTap: () {
                // Action untuk item 4
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('image/home/Home_bg.png'),
                fit: BoxFit.cover)),
        child: Center(
          child: ListView.builder(
            itemCount: menuTitles.length,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  // Navigate to the corresponding screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: menuScreenBuilders[index],
                    ),
                  );
                },
                child: ClipRect(
                  child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                      child: Stack(
                        alignment: AlignmentDirectional.bottomCenter,
                        children: [
                          Container(
                            margin: const EdgeInsets.all(20),
                            width: 332.0,
                            height: 241.0,
                            decoration: BoxDecoration(
                                color: Colors.grey.shade200.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(27)),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  menuImages[index],
                                  // Mengambil path gambar sesuai dengan index card
                                  width: 160,
                                  height: 150,
                                ),
                                const SizedBox(height: 10),
                              ],
                            ),
                          ),
                          Container(
                            width: 332.0,
                            height: 70.0,
                            decoration: BoxDecoration(
                                color: greybase,
                                borderRadius: BorderRadius.circular(12)),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Text(
                                    menuTitles[index],
                                    // Menggunakan judul sesuai dengan index card
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const Spacer(),
                                  Image.asset(
                                    menuIcon[index],
                                    width: 40,
                                    height: 40,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      )),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
