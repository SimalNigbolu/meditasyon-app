import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:meditationapp/Muzik.dart';

class RastgeleMuzikKart extends StatefulWidget {
  const RastgeleMuzikKart({super.key});

  @override
  State<RastgeleMuzikKart> createState() => _RastgeleMuzikKartState();
}

class _RastgeleMuzikKartState extends State<RastgeleMuzikKart> {
  final kategori = {
    "Mutlu": "happy",
    "Üzgün": "sad",
    "Relax": "relax",
    "Stresli": "stress",
    "Odaklanma": "focus",
    "Motive": "motivated",
    "Uyku": "sleep",
    "Duygusal": "emotional"
  };

  Muzik? muzik;
  bool yukleniyor = false;
  bool oynuyor = false;

  late AudioPlayer _player;

  Duration _sure = Duration.zero;
  Duration _konum = Duration.zero;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _player.durationStream.listen((d) {
      if (d != null) setState(() => _sure = d);
    });

    _player.positionStream.listen((p) {
      setState(() => _konum = p);
    });

    _player.playerStateStream.listen((state) {
      setState(() => oynuyor = state.playing);
    });

    muzikGetir();
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

    void muzikGetir() async {
  setState(() => yukleniyor = false);
  try {
    final randomKategori = kategori.values.toList()..shuffle();
    final secilen = randomKategori.first;

    final response = await http.get(Uri.parse("https://api.deezer.com/search?q=$secilen"));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['data'];
      if (data.isNotEmpty) {
        final secilenJson = data.first;
        final yeniMuzik = Muzik.fromJson(secilenJson);

        print("Seçilen müzik preview URL: ${yeniMuzik.previewUrl}");

        if (yeniMuzik.previewUrl.isEmpty) {
          print("Preview URL boş, başka müzik deneniyor...");
          
        } else {
          setState(() {
            muzik = yeniMuzik;
          });
          await _player.setUrl(muzik!.previewUrl);
          await _player.play();
        }
      } else {
        print("API'den dönen data boş.");
      }
    } else {
      print("API çağrısı başarısız: ${response.statusCode}");
    }
  } catch (e) {
    print("Hata oluştu: $e");
  } finally {
    setState(() => yukleniyor = false);
  }
}




  void _togglePlayPause() async {
    if (oynuyor) {
      await _player.pause();
    } else {
      await _player.play();
    }
  }

  String _formatTime(Duration d) {
    String iki(int n) => n.toString().padLeft(2, '0');
    return '${iki(d.inMinutes)}:${iki(d.inSeconds % 60)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Rastgele Müzik"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: yukleniyor
          ? const Center(child: CircularProgressIndicator())
          : muzik == null
              ? const Center(child: Text("Henüz müzik yok"))
              : Column(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(16),
                        child: Card(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Image.network(muzik!.albumCover, height: 200),
                                const SizedBox(height: 16),
                                Text(muzik!.artist, style: const TextStyle(fontSize: 20)),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: muzikGetir,
                                  child: const Text("Yeni Müzik Getir"),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      color: Colors.grey[200],
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Slider(
                            value: _konum.inSeconds.toDouble().clamp(0, _sure.inSeconds.toDouble()),
                            min: 0,
                            max: _sure.inSeconds.toDouble() > 0 ? _sure.inSeconds.toDouble() : 1,
                            onChanged: (value) {
                              _player.seek(Duration(seconds: value.toInt()));
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(_formatTime(_konum)),
                              Text(_formatTime(_sure)),
                            ],
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton.icon(
                            onPressed: _togglePlayPause,
                            icon: Icon(oynuyor ? Icons.pause : Icons.play_arrow),
                            label: Text(oynuyor ? "Durdur" : "Oynat"),
                          ),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
    );
  }
}
