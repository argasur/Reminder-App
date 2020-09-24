class CategoryInfo {
  int id;
  String title;

  CategoryInfo({this.id, this.title});

  factory CategoryInfo.fromMap(Map<String, dynamic> json) =>
      CategoryInfo(id: json['id'], title: json['title']);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
      };
}
