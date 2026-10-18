import 'package:uuid/uuid.dart';
import 'source_file.dart';

class Project {
  final String id;
  String name;
  String description;
  String primaryLanguageId;
  List<SourceFile> files;
  DateTime createdAt;
  DateTime updatedAt;
  bool isFavorite;
  bool isCloudSynced;

  Project({
    String? id,
    required this.name,
    this.description = '',
    required this.primaryLanguageId,
    required this.files,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.isFavorite = false,
    this.isCloudSynced = false,
  })  : id = id ?? const Uuid().v4(),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Project copyWith({
    String? name,
    String? description,
    String? primaryLanguageId,
    List<SourceFile>? files,
    DateTime? updatedAt,
    bool? isFavorite,
    bool? isCloudSynced,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      primaryLanguageId: primaryLanguageId ?? this.primaryLanguageId,
      files: files ?? this.files,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      isFavorite: isFavorite ?? this.isFavorite,
      isCloudSynced: isCloudSynced ?? this.isCloudSynced,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'primaryLanguageId': primaryLanguageId,
      'files': files.map((f) => f.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isFavorite': isFavorite,
      'isCloudSynced': isCloudSynced,
    };
  }

  factory Project.fromJson(Map<String, dynamic> json) {
    return Project(
      id: json['id'] as String?,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      primaryLanguageId: json['primaryLanguageId'] as String,
      files: (json['files'] as List<dynamic>?)
              ?.map((f) => SourceFile.fromJson(f as Map<String, dynamic>))
              .toList() ??
          [],
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
      isFavorite: json['isFavorite'] as bool? ?? false,
      isCloudSynced: json['isCloudSynced'] as bool? ?? false,
    );
  }
}
