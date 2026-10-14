class Movie {
  final String id;
  final String title;
  final String ageRating;
  final String runtime;
  final String description;
  final String screeningTime;
  final double price;
  final String posterPath;

  const Movie({
    required this.id,
    required this.title,
    required this.ageRating,
    required this.runtime,
    required this.description,
    required this.screeningTime,
    required this.price,
    required this.posterPath,
  });

  // Price shown as pounds with two decimals, e.g. £7.50
  String get formattedPrice => '£${price.toStringAsFixed(2)}';

  // True for U and PG films
  bool get isChildFriendly => ageRating == 'U' || ageRating == 'PG';

  // True only for 18-rated films
  bool get isAdultOnly => ageRating == '18';
}
