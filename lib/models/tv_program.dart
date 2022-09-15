class TvProgram {
  String scheduledTime;
  String programTitle;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['scheduledTime'] = scheduledTime;
    map['programTitle'] = programTitle;
    return map;
  }

  TvProgram({
    required this.scheduledTime,
    required this.programTitle,
  });
}
