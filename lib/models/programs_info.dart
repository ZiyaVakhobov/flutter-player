import 'package:udevs_video_player/models/movie.dart';
import 'package:udevs_video_player/models/tv_program.dart';

class ProgramsInfo {
  String? day;
  List<TvProgram>? tvPrograms;

  ProgramsInfo.fromJson(dynamic json) {
    day = json['day'];
    if (json['tvPrograms'] != null) {
      tvPrograms = [];
      json['tvPrograms'].forEach((v) {
        tvPrograms?.add(TvProgram.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['day'] = day;
    if (tvPrograms != null) {
      map['tvPrograms'] = tvPrograms?.map((v) => v.toJson()).toList();
    }
    return map;
  }

  ProgramsInfo({
    this.day,
    this.tvPrograms,
  });
}
