class NotesInfo {
  int id;
  String title;
  String description;

  NotesInfo({this.id, this.title, this.description});

  factory NotesInfo.fromMap(Map<String, dynamic> json) => NotesInfo(
      id: json['id'], title: json['title'], description: json['description']);

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
      };
}
