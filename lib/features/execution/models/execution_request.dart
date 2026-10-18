class ExecutionRequest {
  final String sourceCode;
  final String languageId;
  final int? judge0LanguageId;
  final String stdin;
  final double cpuTimeLimit;
  final int memoryLimit;

  ExecutionRequest({
    required this.sourceCode,
    required this.languageId,
    this.judge0LanguageId,
    this.stdin = '',
    this.cpuTimeLimit = 5.0,
    this.memoryLimit = 128000,
  });

  Map<String, dynamic> toJudge0Payload() {
    return {
      'source_code': sourceCode,
      'language_id': judge0LanguageId ?? 71, // Python 3 default
      'stdin': stdin,
      'cpu_time_limit': cpuTimeLimit,
      'memory_limit': memoryLimit,
    };
  }
}
