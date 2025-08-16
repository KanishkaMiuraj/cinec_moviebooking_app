class Movie {
  final String id;
  final String title;
  final String genre;
  final String duration;
  final List<String> showtimes;
  final String synopsis;
  final String posterImage;

  Movie({
    required this.id,
    required this.title,
    required this.genre,
    required this.duration,
    required this.showtimes,
    required this.synopsis,
    required this.posterImage,
  });

  factory Movie.fromFirestore(Map<String, dynamic> data, String id) {
    return Movie(
      id: id,
      title: (data['title'] ?? '').toString(),
      genre: (data['genre'] ?? '').toString(),
      duration: (data['duration'] ?? '').toString(),
      showtimes: List<String>.from(data['showtimes'] ?? []),
      synopsis: (data['synopsis'] ?? '').toString(),
      posterImage: (data['posterImage'] ?? '').toString(),
    );
  }
}
