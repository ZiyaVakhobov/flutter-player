class TvProgram {
  String? scheduledTime;
  String? programTitle;

  TvProgram.fromJson(dynamic json) {
    scheduledTime = json['scheduledTime'];
    programTitle = json['programTitle'];
  }

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['scheduledTime'] = scheduledTime;
    map['programTitle'] = programTitle;
    return map;
  }

  TvProgram({
    this.scheduledTime,
    this.programTitle,
  });
}
