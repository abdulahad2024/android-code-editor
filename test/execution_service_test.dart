import 'package:flutter_test/flutter_test.dart';
import 'package:android_code_editor/features/execution/models/execution_request.dart';
import 'package:android_code_editor/features/execution/services/judge0_execution_service.dart';

void main() {
  group('Code Execution Service Tests', () {
    late Judge0ExecutionService service;

    setUp(() {
      service = Judge0ExecutionService();
    });

    test('Executes Python print statement in sandbox fallback', () async {
      final request = ExecutionRequest(
        sourceCode: 'print("Hello CodeVerse!")',
        languageId: 'python',
        stdin: '',
      );

      final result = await service.executeCode(request);

      expect(result.isSuccess, true);
      expect(result.stdout, contains('Hello CodeVerse!'));
    });

    test('Executes JavaScript console.log in sandbox fallback', () async {
      final request = ExecutionRequest(
        sourceCode: 'console.log("Hello JS");',
        languageId: 'javascript',
      );

      final result = await service.executeCode(request);

      expect(result.isSuccess, true);
      expect(result.stdout, contains('Hello JS'));
    });
  });
}
