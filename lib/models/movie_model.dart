class Movie {
  String id;
  String title;
  int year;
  String director;
  String genre;
  String synopsis;
  String imageUrl;

  Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.director,
    required this.genre,
    required this.synopsis,
    required this.imageUrl,
  });

  // Convertir un documento de Firebase a objeto Movie
  factory Movie.fromFirestore(Map<String, dynamic> data, String documentId) {
    return Movie(
      id: documentId,
      title: data['title'] ?? '',
      year: data['year'] ?? 0,
      director: data['director'] ?? '',
      genre: data['genre'] ?? '',
      synopsis: data['synopsis'] ?? '',
      imageUrl: data['imageUrl'] ?? 'https://via.placeholder.com/150',
    );
  }

  // Convertir objeto Movie a JSON para Firebase
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'year': year,
      'director': director,
      'genre': genre,
      'synopsis': synopsis,
      'imageUrl': imageUrl,
    };
  }
}
