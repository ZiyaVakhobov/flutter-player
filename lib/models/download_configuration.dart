class DownloadConfiguration {
  String url;
  int percent;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['url'] = url;
    map['percent'] = percent;
    return map;
  }

  @override
  String toString() {
    return 'DownloadConfiguration{url: $url, percent: $percent}';
  }

  DownloadConfiguration({
    required this.url,
    this.percent = 0,
  });
}
