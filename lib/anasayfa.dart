import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meditationapp/RastgeleMuzikler.dart';
import 'package:meditationapp/hesabimSayfasi.dart';
import 'package:meditationapp/muzigimSayfasi.dart';
import 'package:meditationapp/muzik_listesi.dart';


final Map<String, String> kategoriMap = {
  "Mutlu": "happy",
  "Üzgün": "sad",
  "Relax": "relax",
  "Stresli": "stress",
  "Odaklanma": "focus",
  "Motive": "motivated",
  "Uyku": "sleep",
  "Duygusal": "emotional"
};

class Anasayfa extends StatefulWidget {
  const Anasayfa({Key? key}) : super(key: key);

  @override
  _AnasayfaState createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  Map<String, String?> kapakResimleri = {};
  int _currentIndex = 0;

  final List<Widget> _sayfalar = [
  AnasayfaIcerik(),
  MuzigimSayfasi(), 
  HesabimSayfasi(),
];


  @override
  void initState() {
    super.initState();
    kategoriMap.forEach((kategoriAdi, apiKelime) {
      _muzikGetir(kategoriAdi, apiKelime);
    });
  }

  Future<void> _muzikGetir(String kategoriAdi, String apiKelime) async {
    final response = await http.get(Uri.parse('https://api.deezer.com/search?q=$apiKelime'));

    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body)['data'];
      if (data.isNotEmpty) {
        final kapakUrl = data.first['album']['cover_medium'];
        setState(() {
          kapakResimleri[kategoriAdi] = kapakUrl;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Kapak resimleri getirilemedi")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: deprecated_member_use
    return WillPopScope(
      onWillPop: () async {
        if (_currentIndex != 0) {
          setState(() {
            _currentIndex = 0;
          });
          return false; 
        }
        return true; 
      },
      child: Scaffold(
      
        body: _sayfalar[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Anasayfa',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Müziğim',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: 'Hesabım',
            ),
          ],
        ),
      ),
    );
  }
}

class SoulStateModel {
  final IconData iconData;
  final String text;
  final Color color;

  const SoulStateModel({
    required this.iconData,
    required this.text,
    required this.color,

  });
}

class AnasayfaIcerik extends StatelessWidget {

  final List<SoulStateModel> soulStateCards = [
SoulStateModel(iconData: Icons.sentiment_very_satisfied, text: 'Mutlu', color:  Color(0xffEF5DA8)),
SoulStateModel(iconData: Icons.sentiment_very_dissatisfied, text: 'Üzgün', color:  Color(0xffA7A8F5)),
SoulStateModel(iconData: Icons.sentiment_very_satisfied, text: 'Relax', color:  Color(0xffEF5DA8)),
SoulStateModel(iconData: Icons.sentiment_very_dissatisfied, text: 'Stresli', color:  Color(0xffA7A8F5)),
SoulStateModel(iconData: Icons.sentiment_very_satisfied, text: 'Odaklanma', color:  Color(0xffEF5DA8)),
SoulStateModel(iconData: Icons.sentiment_very_satisfied, text: 'Mutlu', color:  Color(0xffA7A8F5)),
SoulStateModel(iconData: Icons.sentiment_very_dissatisfied, text: 'Üzgün', color:  Color(0xffEF5DA8)),
SoulStateModel(iconData: Icons.sentiment_very_satisfied, text: 'Relax', color:  Color(0xffA7A8F5)),

  ]; 
 
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            user == null
                ? const CircularProgressIndicator()
                : Padding(
                    padding: const EdgeInsets.only(top: 60),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Hoş geldin, ${user.displayName ?? 'Misafir'}!',
                          style: GoogleFonts.alegreya(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 30),
                        Text(
                          'Bugün Hangi Ruh Halindesin?',
                          style: GoogleFonts.alegreya(
                              color: Color(0xff371B34), fontSize: 18),
                        ),
                      ],
                    ),
                  ),
            const SizedBox(height: 70),

            SizedBox(
              height: 150,
              child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 16),
              shrinkWrap: true,
              itemCount: soulStateCards.length,
              itemBuilder: (context, index) => ruhHaliKart(context, soulStateCards[index]),
            ),
            ),

           

            const SizedBox(height: 30),

           
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: const Color(0xffFCDDEC),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Rastgele Meditasyon Müziği",
                              style: GoogleFonts.alegreya(
                                color: Color(0xff371B34),
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Spacer(),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const RastgeleMuzikKart(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                "Başlat",
                                style: GoogleFonts.alegreya(color: Color(0xffEF5DA8)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        right: 10,
                        top: 50,
                        child: Image.asset(
                          'resimler/icon.png',
                          width: 70,
                          height: 70,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget ruhHaliKart(BuildContext context, SoulStateModel soulStateModel) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MuzikListesi(
              kategori: kategoriMap[soulStateModel.text]!,
              kategoriAdi: soulStateModel.text,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          children: [
            Card(
              color: soulStateModel.color,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Icon(soulStateModel.iconData, size: 36, color: Colors.white),
              ),
            ),
            const SizedBox(height: 8),
            Text(soulStateModel.text, style: const TextStyle(color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}
