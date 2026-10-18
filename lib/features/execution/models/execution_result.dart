enum ExecutionStatusType {
  pending,
  inQueue,
  processing,
  accepted,
  wrongAnswer,
  timeLimitExceeded,
  compilationError,
  runtimeError,
  internalError,
  networkError,
}

class ExecutionResult {
  final ExecutionStatusType status;
  final String statusDescription;
  final String? stdout;
  final String? stderr;
  final String? compileOutput;
  final String? executionTime;
  final int? memoryUsedKb;
  final DateTime timestamp;

  ExecutionResult({
    required this.status,
    required this.statusDescription,
    this.stdout,
    this.stderr,
    this.compileOutput,
    this.executionTime,
    this.memoryUsedKb,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  bool get isSuccess => status == ExecutionStatusType.accepted;
  bool get hasError =>
      status == ExecutionStatusType.compilationError ||
      status == ExecutionStatusType.runtimeError ||
      status == ExecutionStatusType.wrongAnswer ||
      status == ExecutionStatusType.timeLimitExceeded ||
      status == ExecutionStatusType.networkError ||
      status == ExecutionStatusType.internalError;

  Map<String, dynamic> toJson() {
    return {
      'status': status.name,
      'statusDescription': statusDescription,
      'stdout': stdout,
      'stderr': stderr,
      'compileOutput': compileOutput,
      'executionTime': executionTime,
      'memoryUsedKb': memoryUsedKb,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory ExecutionResult.fromJson(Map<String, dynamic> json) {
    return ExecutionResult(
      status: ExecutionStatusType.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ExecutionStatusType.internalError,
      ),
      statusDescription: json['statusDescription'] ?? '',
      stdout: json['stdout'],
      stderr: json['stderr'],
      compileOutput: json['compileOutput'],
      executionTime: json['executionTime'],
      memoryUsedKb: json['memoryUsedKb'],
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  factory ExecutionResult.fromJudge0Response(Map<String, dynamic> json) {
    final statusObj = json['status'] as Map<String, dynamic>?;
    final statusId = statusObj?['id'] as int? ?? 0;
    final description = statusObj?['description'] as String? ?? 'Executed';

    ExecutionStatusType type = ExecutionStatusType.accepted;
    if (statusId == 1 || statusId == 2) {
      type = ExecutionStatusType.inQueue;
    } else if (statusId == 3) {
      type = ExecutionStatusType.accepted;
    } else if (statusId == 4) {
      type = ExecutionStatusType.wrongAnswer;
    } else if (statusId == 5) {
      type = ExecutionStatusType.timeLimitExceeded;
    } else if (statusId == 6) {
      type = ExecutionStatusType.compilationError;
    } else if (statusId >= 7 && statusId <= 12) {
      type = ExecutionStatusType.runtimeError;
    } else {
      type = ExecutionStatusType.internalError;
    }

    return ExecutionResult(
      status: type,
      statusDescription: description,
      stdout: json['stdout'] as String?,
      stderr: json['stderr'] as String?,
      compileOutput: json['compile_output'] as String?,
      executionTime: json['time'] != null ? '${json['time']}s' : null,
      memoryUsedKb: json['memory'] as int?,
    );
  }
}
