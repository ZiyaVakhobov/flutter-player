class TvCategories {
  const TvCategories({
    required this.id,
    required this.title,
  });

  final String id;
  final String title;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }

  @override
  String toString() => 'TvCategories{id: $id, title: $title}';
}
