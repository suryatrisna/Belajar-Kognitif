import 'dart:ui';
import 'package:belajarkognitif/global_variabel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(Home());
}

class Home extends StatelessWidget {
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
    'image/menu_1.png',
    'image/menu_2.png',
    'image/menu_3.png',
    'image/menu_4.png',
  ];
  final List<String> menuTitles = [
    'Belajar Huruf',
    'Belajar Angka',
    'Belajar Warna',
    'Game',
  ];

  final List<String> menuIcon = [
    'image/icon_1.png',
    'image/icon_2.png',
    'image/icon_3.png',
    'image/icon_4.png',
  ];

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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                children: <TextSpan>[
                  TextSpan(text: 'HO', style: TextStyle(color: redbase)),
                  TextSpan(text: 'ME'),
                ])),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                padding: EdgeInsets.all(4.0),
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                    border: Border(
                        bottom: Divider.createBorderSide(context,
                            color: Colors.white, width: 0.0)),
                    image: DecorationImage(
                        image: AssetImage('image/bg.jpg'), fit: BoxFit.cover)),
                child: Container()),
            ListTile(
              title: Text(
                'Home',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.home),
              onTap: () {
                // Action untuk item 1
              },
            ),
            ListTile(
              title: Text(
                'Saved',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.bookmark),
              onTap: () {
                // Action untuk item 2
              },
            ),
            ListTile(
              title: Text(
                'Messeges',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.message_rounded),
              onTap: () {
                // Action untuk item 3
              },
            ),
            ListTile(
              title: Text(
                'News',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              leading: Icon(Icons.newspaper),
              onTap: () {
                // Action untuk item 4
              },
            ),
          ],
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
                image: AssetImage('image/Home_bg.png'), fit: BoxFit.cover)),
        child: Center(
          child: ListView(
            children: List.generate(4, (index) {
              return ClipRect(
                child: new BackdropFilter(
                    filter: new ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        new Container(
                          margin: EdgeInsets.all(20),
                          width: 332.0,
                          height: 241.0,
                          decoration: new BoxDecoration(
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
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                        Container(
                          width: 332.0,
                          height: 70.0,
                          decoration: new BoxDecoration(
                              color: greybase,
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Text(
                                  menuTitles[index],
                                  // Menggunakan judul sesuai dengan index card
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                                Spacer(),
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
              );
            }),
          ),
        ),
      ),
    );
  }
}
