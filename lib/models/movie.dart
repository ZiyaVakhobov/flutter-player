
class Movie {
  String title;
  String description;
  String image;
  int duration;
  Map<String, String> resolutions;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['description'] = description;
    map['image'] = image;
    map['duration'] = duration;
    map['resolutions'] = resolutions;
    return map;
  }

  Movie({
    required this.title,
    required this.description,
    required this.image,
    required this.duration,
    required this.resolutions,
  });
}
