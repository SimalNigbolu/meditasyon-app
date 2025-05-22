import 'dart:convert';
import 'package:http/http.dart' as http;
import 'Muzik.dart';

class MuzikService {
  Future<List<Muzik>> getMusicByCategory(String kategori) async {
    final String query = Uri.encodeComponent(kategori);
    final url = Uri.parse('https://api.deezer.com/search?q=$query');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> muzikListesi = data['data'];

      return muzikListesi.map((json) => Muzik.fromJson(json)).toList();
    } else {
      throw Exception('Müzikler alınamadı: ${response.statusCode}');
    }
  }
}
