import 'package:udevs_video_player/models/tv_program.dart';

class ProgramsInfo {
  String day;
  List<TvProgram> tvPrograms;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['day'] = day;
    map['tvPrograms'] = tvPrograms.map((v) => v.toJson()).toList();
    return map;
  }

  ProgramsInfo({
    required this.day,
    required this.tvPrograms,
  });
}
