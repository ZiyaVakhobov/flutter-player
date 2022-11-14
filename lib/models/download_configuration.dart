class DownloadConfiguration {
  String url;

  Map<String, dynamic> toJson() {
    var map = <String, dynamic>{};
    map['url'] = url;
    return map;
  }


  @override
  String toString() {
    return 'DownloadConfiguration{url: $url}';
  }

  DownloadConfiguration({required this.url});
}