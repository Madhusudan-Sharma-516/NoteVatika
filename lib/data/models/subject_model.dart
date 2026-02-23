class SubjectModel {
  final String id;
  final String courseId;
  final String name;
  final String code;
  final String icon;

  SubjectModel({
    required this.id,
    required this.courseId,
    required this.name,
    required this.code,
    required this.icon,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as String,
      courseId: json['courseId'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      icon: json['icon'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'courseId': courseId,
    'name': name,
    'code': code,
    'icon': icon,
  };
}
