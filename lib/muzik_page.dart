import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:meditationapp/Muzik.dart';
import 'package:meditationapp/favori_manager.dart'; 

class MuzikPage extends StatefulWidget {
  final Muzik muzik;

  const MuzikPage({Key? key, required this.muzik}) : super(key: key);

  @override
  _MuzikPageState createState() => _MuzikPageState();
}

class _MuzikPageState extends State<MuzikPage> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool favorideMi = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    favoriKontrolEt();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      if (!mounted) return;
      setState(() => _isPlaying = false);
    } else {
      try {
        await _audioPlayer.setUrl(widget.muzik.previewUrl);
        await _audioPlayer.play();
        if (!mounted) return;
        setState(() => _isPlaying = true);
      } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Müzik çalarken hata oluştu")),
        );
      }
    }
  }

  void favoriKontrolEt() async {
    final favoriler = await FavoriManager.favorileriGetir();
    setState(() {
      favorideMi = favoriler.any((item) =>
          item.title == widget.muzik.title &&
          item.artist == widget.muzik.artist);
    });
  }

  void favoriDegistir() async {
    if (favorideMi) {
      await FavoriManager.favoriCikar(widget.muzik);
    } else {
      await FavoriManager.favoriEkle(widget.muzik);
    }
    favoriKontrolEt();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.muzik.title),
        actions: [
          IconButton(
            icon: Icon(
              favorideMi ? Icons.favorite : Icons.favorite_border,
              color: Colors.red,
            ),
            onPressed: favoriDegistir,
          )
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(widget.muzik.albumCover),
            const SizedBox(height: 20),
            Text(widget.muzik.artist, style: TextStyle(fontSize: 20)),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _playPause,
              child: Text(_isPlaying ? 'Duraklat' : 'Dinle'),
            ),
          ],
        ),
      ),
    );
  }
}
