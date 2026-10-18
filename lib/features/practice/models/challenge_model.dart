class TestCase {
  final String input;
  final String expectedOutput;
  final bool isHidden;

  const TestCase({
    required this.input,
    required this.expectedOutput,
    this.isHidden = false,
  });

  Map<String, dynamic> toJson() => {
        'input': input,
        'expectedOutput': expectedOutput,
        'isHidden': isHidden,
      };

  factory TestCase.fromJson(Map<String, dynamic> json) => TestCase(
        input: json['input'] as String,
        expectedOutput: json['expectedOutput'] as String,
        isHidden: json['isHidden'] as bool? ?? false,
      );
}

class Challenge {
  final String id;
  final String title;
  final String difficulty; // Beginner, Intermediate, Advanced
  final String category;
  final String description;
  final String inputFormat;
  final String outputFormat;
  final String constraints;
  final List<TestCase> testCases;
  final String starterCode;
  final String defaultLanguageId;
  final String hint;
  final String solutionExplanation;
  final bool isCompleted;

  const Challenge({
    required this.id,
    required this.title,
    required this.difficulty,
    required this.category,
    required this.description,
    required this.inputFormat,
    required this.outputFormat,
    required this.constraints,
    required this.testCases,
    required this.starterCode,
    required this.defaultLanguageId,
    required this.hint,
    required this.solutionExplanation,
    this.isCompleted = false,
  });

  Challenge copyWith({
    bool? isCompleted,
  }) {
    return Challenge(
      id: id,
      title: title,
      difficulty: difficulty,
      category: category,
      description: description,
      inputFormat: inputFormat,
      outputFormat: outputFormat,
      constraints: constraints,
      testCases: testCases,
      starterCode: starterCode,
      defaultLanguageId: defaultLanguageId,
      hint: hint,
      solutionExplanation: solutionExplanation,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'difficulty': difficulty,
        'category': category,
        'description': description,
        'inputFormat': inputFormat,
        'outputFormat': outputFormat,
        'constraints': constraints,
        'testCases': testCases.map((t) => t.toJson()).toList(),
        'starterCode': starterCode,
        'defaultLanguageId': defaultLanguageId,
        'hint': hint,
        'solutionExplanation': solutionExplanation,
        'isCompleted': isCompleted,
      };

  factory Challenge.fromJson(Map<String, dynamic> json) => Challenge(
        id: json['id'] as String,
        title: json['title'] as String,
        difficulty: json['difficulty'] as String,
        category: json['category'] as String,
        description: json['description'] as String,
        inputFormat: json['inputFormat'] as String,
        outputFormat: json['outputFormat'] as String,
        constraints: json['constraints'] as String,
        testCases: (json['testCases'] as List<dynamic>?)
                ?.map((t) => TestCase.fromJson(t as Map<String, dynamic>))
                .toList() ??
            [],
        starterCode: json['starterCode'] as String,
        defaultLanguageId: json['defaultLanguageId'] as String,
        hint: json['hint'] as String? ?? '',
        solutionExplanation: json['solutionExplanation'] as String? ?? '',
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}
