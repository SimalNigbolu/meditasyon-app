import 'package:flutter/material.dart';
import 'package:meditationapp/Muzik.dart';
import 'package:meditationapp/favori_manager.dart';
import 'package:meditationapp/muzik_page.dart'; 

class MuzigimSayfasi extends StatefulWidget {
  @override
  _MuzigimSayfasiState createState() => _MuzigimSayfasiState();
}

class _MuzigimSayfasiState extends State<MuzigimSayfasi> {
  List<Muzik> favoriler = [];

  @override
  void initState() {
    super.initState();
    favorileriYukle();
  }

  Future<void> favorileriYukle() async {
    final liste = await FavoriManager.favorileriGetir();
    setState(() {
      favoriler = liste;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Favori Müziklerim")),
      body: favoriler.isEmpty
          ? Center(child: Text("Henüz favori müzik yok"))
          : ListView.builder(
              itemCount: favoriler.length,
              itemBuilder: (context, index) {
                final muzik = favoriler[index];
                return ListTile(
                  leading: Image.network(muzik.albumCover),
                  title: Text(muzik.title),
                  subtitle: Text(muzik.artist),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => MuzikPage(muzik: muzik),
                      ),
                    ).then((_) => favorileriYukle()); 
                  },
                );
              },
            ),
    );
  }
}
