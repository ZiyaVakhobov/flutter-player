import 'package:udevs_video_player/models/movie.dart';

class Season {
  String? title;
  List<Movie>? movies;

  Season.fromJson(dynamic json) {
    title = json['title'];
    if (json['movies'] != null) {
      movies = [];
      json['movies'].forEach((v) {
        movies?.add(Movie.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['title'] = title;
    if (movies != null) {
      map['movies'] = movies?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  Season({
    this.title,
    this.movies,
  });
}
