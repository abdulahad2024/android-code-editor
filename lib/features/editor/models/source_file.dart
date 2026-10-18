import 'package:uuid/uuid.dart';

class SourceFile {
  final String id;
  String name;
  String content;
  String languageId;
  DateTime updatedAt;
  bool isUnsaved;

  SourceFile({
    String? id,
    required this.name,
    required this.content,
    required this.languageId,
    DateTime? updatedAt,
    this.isUnsaved = false,
  })  : id = id ?? const Uuid().v4(),
        updatedAt = updatedAt ?? DateTime.now();

  SourceFile copyWith({
    String? name,
    String? content,
    String? languageId,
    DateTime? updatedAt,
    bool? isUnsaved,
  }) {
    return SourceFile(
      id: id,
      name: name ?? this.name,
      content: content ?? this.content,
      languageId: languageId ?? this.languageId,
      updatedAt: updatedAt ?? DateTime.now(),
      isUnsaved: isUnsaved ?? this.isUnsaved,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'content': content,
      'languageId': languageId,
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory SourceFile.fromJson(Map<String, dynamic> json) {
    return SourceFile(
      id: json['id'] as String?,
      name: json['name'] as String,
      content: json['content'] as String,
      languageId: json['languageId'] as String,
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isUnsaved: false,
    );
  }
}
