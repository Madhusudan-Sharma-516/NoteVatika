class CodeBlockModel {
  final String language;
  final String code;

  CodeBlockModel({required this.language, required this.code});

  factory CodeBlockModel.fromJson(Map<String, dynamic> json) {
    return CodeBlockModel(
      language: json['language'] as String,
      code: json['code'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'language': language, 'code': code};
}

class TableModel {
  final List<String> headers;
  final List<List<String>> rows;

  TableModel({required this.headers, required this.rows});

  factory TableModel.fromJson(Map<String, dynamic> json) {
    return TableModel(
      headers: List<String>.from(json['headers'] as List),
      rows: (json['rows'] as List)
          .map((row) => List<String>.from(row as List))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {'headers': headers, 'rows': rows};
}

class NoteModel {
  final String id;
  final String topicId;
  final String heading;
  final String subtitle;
  final String introduction;
  final List<String> keyPoints;
  final CodeBlockModel? codeBlock;
  final TableModel? table;
  final String? imagePath;
  final String imageCaption;
  final String summary;

  NoteModel({
    required this.id,
    required this.topicId,
    required this.heading,
    required this.subtitle,
    required this.introduction,
    required this.keyPoints,
    this.codeBlock,
    this.table,
    this.imagePath,
    required this.imageCaption,
    required this.summary,
  });

  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'] as String,
      topicId: json['topicId'] as String,
      heading: json['heading'] as String,
      subtitle: json['subtitle'] as String,
      introduction: json['introduction'] as String,
      keyPoints: List<String>.from(json['keyPoints'] as List),
      codeBlock: json['codeBlock'] != null
          ? CodeBlockModel.fromJson(json['codeBlock'] as Map<String, dynamic>)
          : null,
      table: json['table'] != null
          ? TableModel.fromJson(json['table'] as Map<String, dynamic>)
          : null,
      imagePath: json['imagePath'] as String?,
      imageCaption: (json['imageCaption'] as String?) ?? '',
      summary: json['summary'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'topicId': topicId,
    'heading': heading,
    'subtitle': subtitle,
    'introduction': introduction,
    'keyPoints': keyPoints,
    'codeBlock': codeBlock?.toJson(),
    'table': table?.toJson(),
    'imagePath': imagePath,
    'imageCaption': imageCaption,
    'summary': summary,
  };
}
