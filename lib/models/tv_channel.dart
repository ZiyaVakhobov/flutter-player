class TvChannel {
  String id;
  String image;
  String name;
  Map<String, String> resolutions;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['id'] = id;
    map['image'] = image;
    map['name'] = name;
    map['resolutions'] = resolutions;
    return map;
  }

  TvChannel({
    required this.id,
    required this.image,
    required this.name,
    required this.resolutions,
  });
}
