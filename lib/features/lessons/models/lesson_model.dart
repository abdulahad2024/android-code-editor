class Lesson {
  final String id;
  final String title;
  final String category;
  final String description;
  final String contentMarkdown;
  final String sampleCode;
  final String languageId;
  final int estimatedMinutes;
  final bool isCompleted;
  final bool isBookmarked;

  const Lesson({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.contentMarkdown,
    required this.sampleCode,
    required this.languageId,
    required this.estimatedMinutes,
    this.isCompleted = false,
    this.isBookmarked = false,
  });

  Lesson copyWith({
    bool? isCompleted,
    bool? isBookmarked,
  }) {
    return Lesson(
      id: id,
      title: title,
      category: category,
      description: description,
      contentMarkdown: contentMarkdown,
      sampleCode: sampleCode,
      languageId: languageId,
      estimatedMinutes: estimatedMinutes,
      isCompleted: isCompleted ?? this.isCompleted,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'category': category,
      'description': description,
      'contentMarkdown': contentMarkdown,
      'sampleCode': sampleCode,
      'languageId': languageId,
      'estimatedMinutes': estimatedMinutes,
      'isCompleted': isCompleted,
      'isBookmarked': isBookmarked,
    };
  }

  factory Lesson.fromJson(Map<String, dynamic> json) {
    return Lesson(
      id: json['id'] as String,
      title: json['title'] as String,
      category: json['category'] as String,
      description: json['description'] as String,
      contentMarkdown: json['contentMarkdown'] as String,
      sampleCode: json['sampleCode'] as String,
      languageId: json['languageId'] as String,
      estimatedMinutes: json['estimatedMinutes'] as int? ?? 10,
      isCompleted: json['isCompleted'] as bool? ?? false,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
    );
  }
}
