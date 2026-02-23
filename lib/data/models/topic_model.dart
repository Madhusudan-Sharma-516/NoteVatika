class TopicModel {
  final String id;
  final String subjectId;
  final String name;
  final String icon;

  TopicModel({
    required this.id,
    required this.subjectId,
    required this.name,
    required this.icon,
  });

  factory TopicModel.fromJson(Map<String, dynamic> json) {
    return TopicModel(
      id: json['id'] as String,
      subjectId: json['subjectId'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'subjectId': subjectId,
    'name': name,
    'icon': icon,
  };
}
