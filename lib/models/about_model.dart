class AboutModel {
  String group;
  String photo;
  String name;
  String? description;
  List<String?>? buttons;
  List<String?>? links;

  AboutModel({
    required this.group,
    required this.photo,
    required this.name,
    this.description,
    this.buttons,
    this.links,
  });

  factory AboutModel.fromJson(Map<String, dynamic> json) {
    var tGroup = json["group"] ?? "Credits";
    var tPhoto = json["photo"] ??
        "https://cdn1.iconfinder.com/data/icons/user-pictures/100/unknown-512.png";
    var tName = json["name"] ?? "Developer";
    var tDescription = json["description"]?.toString();
    var tButtons = json["buttons"];
    var tLinks = json["links"];
    tButtons = tButtons != null ? List<String>.from(tButtons) : null;
    tLinks = tLinks != null ? List<String>.from(tLinks) : null;

    return AboutModel(
        group: tGroup,
        photo: tPhoto,
        name: tName,
        description: tDescription,
        buttons: tButtons,
        links: tLinks);
  }
}
