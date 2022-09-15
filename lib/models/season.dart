import 'package:udevs_video_player/models/movie.dart';

class Season {
  String title;
  List<Movie> movies;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['title'] = title;
    map['movies'] = movies.map((v) => v.toJson()).toList();
    return map;
  }

  @override
  String toString() {
    return 'Season{title: $title, movies: $movies}';
  }

  Season({
    required this.title,
    required this.movies,
  });
}
