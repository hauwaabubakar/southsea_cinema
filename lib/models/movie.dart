class Movie {
  final String id;        
  final String title;
  final String ageRating;
  final String runtime;
  final String description;
  final String screeningTime;
  final double price;
  final String posterPath;
// final can't change after creation
  const Movie({
    required this.id,
    required this.title,
    required this.ageRating,
    required this.description,
    required this.runtime,
    required this.screeningTime,
    required this.price,
    required this.posterPath,
  });
}
