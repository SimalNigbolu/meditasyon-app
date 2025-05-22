import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:meditationapp/Muzik.dart'; 

class FavoriManager {
  static const String keyFavoriler = 'favori_muzikler';


  static Future<void> favoriEkle(Muzik muzik) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriler = prefs.getStringList(keyFavoriler) ?? [];

    bool varMi = favoriler.any((element) {
      final map = jsonDecode(element);
      return map['title'] == muzik.title && map['artist'] == muzik.artist;
    });
    if (!varMi) {
      favoriler.add(jsonEncode({
        'title': muzik.title,
        'artist': muzik.artist,
        'albumCover': muzik.albumCover,
        'previewUrl': muzik.previewUrl,
        
      }));
      await prefs.setStringList(keyFavoriler, favoriler);
    }
  }

  static Future<void> favoriCikar(Muzik muzik) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriler = prefs.getStringList(keyFavoriler) ?? [];
    favoriler.removeWhere((element) {
      final map = jsonDecode(element);
      return map['title'] == muzik.title && map['artist'] == muzik.artist;
    });
    await prefs.setStringList(keyFavoriler, favoriler);
  }

 
  static Future<List<Muzik>> favorileriGetir() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favoriler = prefs.getStringList(keyFavoriler) ?? [];
    return favoriler.map((e) {
      final map = jsonDecode(e);
      return Muzik(
        title: map['title'],
        artist: map['artist'],
        albumCover: map['albumCover'],
        previewUrl: map['previewUrl'],
        
      );
    }).toList();
  }
}
