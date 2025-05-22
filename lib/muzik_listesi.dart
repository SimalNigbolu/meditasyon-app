import 'package:flutter/material.dart';
import 'package:meditationapp/Muzik.dart';
import 'package:meditationapp/muzik_page.dart';
import 'package:meditationapp/muzik_service.dart';

class MuzikListesi extends StatelessWidget {
  final String kategori;
  final String kategoriAdi;

  const MuzikListesi({Key? key, required this.kategori, required this.kategoriAdi,}) : super(key: key);
  
  

  Future<List<Muzik>> _muzikleriGetir() async {
    return await MuzikService().getMusicByCategory(kategori);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$kategoriAdi Müzikleri')),
      body: FutureBuilder<List<Muzik>>(
        future: _muzikleriGetir(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Hata: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Müzik bulunamadı.'));
          }

          final muzikListesi = snapshot.data!;

          return ListView.builder(
            itemCount: muzikListesi.length,
            itemBuilder: (context, index) {
              final muzik = muzikListesi[index];
              return ListTile(
                leading: Image.network(muzik.albumCover),
                title: Text(muzik.title),
                subtitle: Text(muzik.artist),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MuzikPage(muzik: muzik),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
