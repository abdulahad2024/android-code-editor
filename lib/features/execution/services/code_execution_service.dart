import '../models/execution_request.dart';
import '../models/execution_result.dart';

abstract class CodeExecutionService {
  Future<ExecutionResult> executeCode(ExecutionRequest request);
}
