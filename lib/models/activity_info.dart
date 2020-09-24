class ActivityInfo {
  int id;

  DateTime activityDateTime;
  String title;
  String description;
  int isPending;

  ActivityInfo({
    this.id,
    this.title,
    this.description,
    this.activityDateTime,
    this.isPending,
  });
  factory ActivityInfo.fromMap(Map<String, dynamic> json) => ActivityInfo(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        activityDateTime: DateTime.parse(json["activityDateTime"]),
        isPending: json["isPending"],
      );
  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "activityDateTime": activityDateTime.toIso8601String(),
        "isPending": isPending,
      };
}
