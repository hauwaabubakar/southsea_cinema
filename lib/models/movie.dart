// The model for ONE film (Worksheets 3, 4 and 6).
//
// Every field is final, so a Movie cannot change once it is created.
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
  String get formattedPrice {
    return '£${price.toStringAsFixed(2)}';
  }

  // True for U and PG films
  bool get isChildFriendly {
    return ageRating == 'U' || ageRating == 'PG';
  }

  // True only for 18-rated films
  bool get isAdultOnly {
    return ageRating == '18';
  }

  // Worksheet 6: builds a Movie from ONE decoded JSON object (a Map).
  //
  // "factory" lets a constructor run some code first and then return the
  // new Movie. Map<String, dynamic> means the keys are text and the values
  // can be different types. Dart can't know json['title'] is text, so
  // "as String" checks it, and throws an error if the data is wrong.
  factory Movie.fromJson(Map<String, dynamic> json) {
    final String id = json['id'] as String;
    final String title = json['title'] as String;
    final String ageRating = json['ageRating'] as String;
    final String runtime = json['runtime'] as String;
    final String description = json['description'] as String;
    final String screeningTime = json['screeningTime'] as String;
    // num accepts a whole number (5) or a decimal (7.50). toDouble() makes
    // sure our model always gets a double.
    final num priceNumber = json['price'] as num;
    final double price = priceNumber.toDouble();
    final String posterPath = json['posterPath'] as String;

    return Movie(
      id: id,
      title: title,
      ageRating: ageRating,
      runtime: runtime,
      description: description,
      screeningTime: screeningTime,
      price: price,
      posterPath: posterPath,
    );
  }

  // Worksheet 6: the reverse. It returns a Map, not JSON text. jsonEncode
  // could turn this map into text, but we only need it for the tests.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{
      'id': id,
      'title': title,
      'ageRating': ageRating,
      'runtime': runtime,
      'description': description,
      'screeningTime': screeningTime,
      'price': price,
      'posterPath': posterPath,
    };
    return data;
  }
}
