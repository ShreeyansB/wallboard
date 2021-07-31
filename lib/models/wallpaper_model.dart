class WallpaperModel {
  String name;
  String url;
  String? author;
  String? thumbnail;
  String? collection;
  String? size;
  String? dimensions;
  bool? downloadable;
  String? license;

  WallpaperModel(
      {required this.name,
      required this.url,
      this.author,
      this.thumbnail,
      this.collection,
      this.size,
      this.dimensions,
      this.downloadable,
      this.license});

  static WallpaperModel? fromJson(Map<String, dynamic> json) {
    if (json['name'] != null && json['url'] != null) {
      var result = WallpaperModel(
          name: json['name'],
          url: json['url'],
          author: json['author'],
          thumbnail: json['thumbnail'],
          collection: json['collection'],
          size: json['size'],
          dimensions: json['dimensions'],
          downloadable: json['downloadable'],
          license: json['license']);
      if (result.downloadable! is bool) result.downloadable = true;
      return result;
    } else {
      return null;
    }
  }
}
