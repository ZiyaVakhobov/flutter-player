import 'dart:ffi';

class Movie {
  String? title;
  String? description;
  String? image;
  Int64? duration;
  Map<String, String>? resolutions;

  Movie.fromJson(dynamic json) {
    title = json['title'];
    description = json['description'];
    image = json['image'];
    duration = json['duration'];
    resolutions = json['resolutions'];
  }

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
    this.title,
    this.description,
    this.image,
    this.duration,
    this.resolutions,
  });
}
