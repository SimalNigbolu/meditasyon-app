class Muzik {
  final String title;
  final String artist;
  final String albumCover;
  final String previewUrl;
 

  Muzik({
    required this.title,
    required this.artist,
    required this.albumCover,
    required this.previewUrl,
    
  });

  factory Muzik.fromJson(Map<String, dynamic> json) {
    return Muzik(
      title: json['title'] ?? '',
      artist: json['artist']['name'] ?? '',
      albumCover: json['album']['cover_medium'] ?? '',
      previewUrl: json['preview'] ?? '', 
      
    );
  }
}
