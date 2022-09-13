import 'dart:core';
import 'dart:ffi';

import 'package:udevs_video_player/models/season.dart';
import 'package:udevs_video_player/models/tv_program.dart';

class PlayerConfiguration {
  Map<String, String>? initialResolution;
  Map<String, String>? filmResolutions;
  String? qualityText;
  String? speedText;
  Int64? lastPosition;
  String? title;
  bool? isSerial;
  String? episodeButtonText;
  String? nextButtonText;
  List<Season>? seasons;
  bool? isLive;
  String? tvProgramsText;
  List<TvProgram>? tvPrograms;

  PlayerConfiguration.fromJson(dynamic json) {
    initialResolution = json['initialResolution'];
    filmResolutions = json['filmResolutions'];
    qualityText = json['qualityText'];
    speedText = json['speedText'];
    lastPosition = json['lastPosition'];
    title = json['title'];
    isSerial = json['isSerial'];
    episodeButtonText = json['episodeButtonText'];
    nextButtonText = json['nextButtonText'];
    if (json['seasons'] != null) {
      seasons = [];
      json['seasons'].forEach((v) {
        seasons?.add(Season.fromJson(v));
      });
    }
    isLive = json['isLive'];
    tvProgramsText = json['tvProgramsText'];
    if (json['tvPrograms'] != null) {
      tvPrograms = [];
      json['tvPrograms'].forEach((v) {
        tvPrograms?.add(TvProgram.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['initialResolution'] = initialResolution;
    map['filmResolutions'] = filmResolutions;
    map['qualityText'] = qualityText;
    map['speedText'] = speedText;
    map['lastPosition'] = lastPosition;
    map['title'] = title;
    map['isSerial'] = isSerial;
    map['episodeButtonText'] = episodeButtonText;
    map['nextButtonText'] = nextButtonText;
    if (seasons != null) {
      map['seasons'] = seasons?.map((v) => v.toJson()).toList();
    }
    map['isLive'] = isLive;
    map['tvProgramsText'] = tvProgramsText;
    if (tvPrograms != null) {
      map['tvPrograms'] = tvPrograms?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}
