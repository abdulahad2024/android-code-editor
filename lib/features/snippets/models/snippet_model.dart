import 'package:uuid/uuid.dart';

class Snippet {
  final String id;
  String title;
  String code;
  String languageId;
  String tags;
  DateTime createdAt;

  Snippet({
    String? id,
    required this.title,
    required this.code,
    required this.languageId,
    this.tags = '',
    DateTime? createdAt,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'code': code,
      'languageId': languageId,
      'tags': tags,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory Snippet.fromJson(Map<String, dynamic> json) {
    return Snippet(
      id: json['id'] as String?,
      title: json['title'] as String,
      code: json['code'] as String,
      languageId: json['languageId'] as String,
      tags: json['tags'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
