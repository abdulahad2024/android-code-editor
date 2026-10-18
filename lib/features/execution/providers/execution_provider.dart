import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../languages/models/language_config.dart';
import '../../settings/providers/settings_provider.dart';
import '../models/execution_request.dart';
import '../models/execution_result.dart';
import '../services/judge0_execution_service.dart';

class ExecutionState {
  final bool isExecuting;
  final ExecutionResult? lastResult;
  final String stdin;
  final List<ExecutionResult> history;
  final String? activeConsoleTab; // 'output', 'stdin', 'errors', 'details'

  ExecutionState({
    this.isExecuting = false,
    this.lastResult,
    this.stdin = '',
    this.history = const [],
    this.activeConsoleTab = 'output',
  });

  ExecutionState copyWith({
    bool? isExecuting,
    ExecutionResult? lastResult,
    String? stdin,
    List<ExecutionResult>? history,
    String? activeConsoleTab,
  }) {
    return ExecutionState(
      isExecuting: isExecuting ?? this.isExecuting,
      lastResult: lastResult ?? this.lastResult,
      stdin: stdin ?? this.stdin,
      history: history ?? this.history,
      activeConsoleTab: activeConsoleTab ?? this.activeConsoleTab,
    );
  }
}

class ExecutionNotifier extends StateNotifier<ExecutionState> {
  final Judge0ExecutionService _executionService = Judge0ExecutionService();
  final LocalStorageService? _storage;

  ExecutionNotifier(this._storage) : super(ExecutionState()) {
    _loadHistory();
  }

  void _loadHistory() {
    if (_storage != null) {
      final jsonList = _storage!.getJsonList(AppConstants.keyExecutionHistory);
      if (jsonList != null && jsonList.isNotEmpty) {
        state = state.copyWith(
          history: jsonList
              .map((e) => ExecutionResult.fromJson(e as Map<String, dynamic>))
              .toList(),
        );
      }
    }
  }

  void _saveHistory() {
    if (_storage != null) {
      _storage!.setJsonList(
        AppConstants.keyExecutionHistory,
        state.history.take(30).map((e) => e.toJson()).toList(),
      );
    }
  }

  void setStdin(String input) {
    state = state.copyWith(stdin: input);
  }

  void setConsoleTab(String tab) {
    state = state.copyWith(activeConsoleTab: tab);
  }

  Future<ExecutionResult> runCode({
    required String code,
    required String languageId,
  }) async {
    state = state.copyWith(
      isExecuting: true,
      activeConsoleTab: 'output',
    );

    final lang = LanguageConfig.getById(languageId);
    final request = ExecutionRequest(
      sourceCode: code,
      languageId: lang.id,
      judge0LanguageId: lang.judge0Id,
      stdin: state.stdin,
    );

    final result = await _executionService.executeCode(request);

    final updatedHistory = [result, ...state.history];
    state = state.copyWith(
      isExecuting: false,
      lastResult: result,
      history: updatedHistory,
    );

    _saveHistory();
    return result;
  }

  void clearConsole() {
    state = state.copyWith(lastResult: null);
  }

  void clearHistory() {
    state = state.copyWith(history: []);
    _saveHistory();
  }
}

final executionProvider = StateNotifierProvider<ExecutionNotifier, ExecutionState>((ref) {
  final storageAsync = ref.watch(localStorageProvider);
  final storage = storageAsync.asData?.value;
  return ExecutionNotifier(storage);
});
