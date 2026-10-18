import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../languages/models/language_config.dart';
import '../models/project_model.dart';
import '../models/source_file.dart';
import '../../projects/providers/projects_provider.dart';

class EditorState {
  final Project? activeProject;
  final String? activeFileId;
  final List<String> openFileIds;
  final String currentCode;
  final String activeLanguageId;
  final bool isUnsaved;
  final String findText;
  final String replaceText;
  final bool isFindReplaceOpen;

  EditorState({
    this.activeProject,
    this.activeFileId,
    this.openFileIds = const [],
    this.currentCode = '',
    this.activeLanguageId = 'python',
    this.isUnsaved = false,
    this.findText = '',
    this.replaceText = '',
    this.isFindReplaceOpen = false,
  });

  SourceFile? get activeFile {
    if (activeProject == null || activeFileId == null) return null;
    try {
      return activeProject!.files.firstWhere((f) => f.id == activeFileId);
    } catch (_) {
      return null;
    }
  }

  EditorState copyWith({
    Project? activeProject,
    String? activeFileId,
    List<String>? openFileIds,
    String? currentCode,
    String? activeLanguageId,
    bool? isUnsaved,
    String? findText,
    String? replaceText,
    bool? isFindReplaceOpen,
  }) {
    return EditorState(
      activeProject: activeProject ?? this.activeProject,
      activeFileId: activeFileId ?? this.activeFileId,
      openFileIds: openFileIds ?? this.openFileIds,
      currentCode: currentCode ?? this.currentCode,
      activeLanguageId: activeLanguageId ?? this.activeLanguageId,
      isUnsaved: isUnsaved ?? this.isUnsaved,
      findText: findText ?? this.findText,
      replaceText: replaceText ?? this.replaceText,
      isFindReplaceOpen: isFindReplaceOpen ?? this.isFindReplaceOpen,
    );
  }
}

class EditorNotifier extends StateNotifier<EditorState> {
  final Ref _ref;

  EditorNotifier(this._ref) : super(EditorState());

  void loadProject(Project project, {String? fileId}) {
    final activeFile = (fileId != null
            ? project.files.firstWhere((f) => f.id == fileId, orElse: () => project.files.first)
            : project.files.first);

    state = EditorState(
      activeProject: project,
      activeFileId: activeFile.id,
      openFileIds: [activeFile.id],
      currentCode: activeFile.content,
      activeLanguageId: activeFile.languageId,
      isUnsaved: activeFile.isUnsaved,
    );
  }

  void loadStandaloneFile({required String title, required String code, required String languageId}) {
    final standaloneFile = SourceFile(
      name: title,
      content: code,
      languageId: languageId,
    );
    final standaloneProject = Project(
      name: title,
      primaryLanguageId: languageId,
      files: [standaloneFile],
    );

    state = EditorState(
      activeProject: standaloneProject,
      activeFileId: standaloneFile.id,
      openFileIds: [standaloneFile.id],
      currentCode: code,
      activeLanguageId: languageId,
      isUnsaved: false,
    );
  }

  void switchToFile(String fileId) {
    if (state.activeProject == null) return;
    try {
      final file = state.activeProject!.files.firstWhere((f) => f.id == fileId);
      final openList = List<String>.from(state.openFileIds);
      if (!openList.contains(fileId)) {
        openList.add(fileId);
      }

      state = state.copyWith(
        activeFileId: file.id,
        openFileIds: openList,
        currentCode: file.content,
        activeLanguageId: file.languageId,
        isUnsaved: file.isUnsaved,
      );
    } catch (_) {}
  }

  void closeTab(String fileId) {
    final openList = List<String>.from(state.openFileIds)..remove(fileId);
    if (openList.isEmpty) {
      state = state.copyWith(
        activeFileId: null,
        openFileIds: [],
        currentCode: '',
      );
      return;
    }
    final nextFileId = openList.last;
    switchToFile(nextFileId);
    state = state.copyWith(openFileIds: openList);
  }

  void updateCode(String newCode) {
    if (state.currentCode == newCode) return;
    state = state.copyWith(
      currentCode: newCode,
      isUnsaved: true,
    );

    if (state.activeProject != null && state.activeFileId != null) {
      final updatedFiles = state.activeProject!.files.map((f) {
        if (f.id == state.activeFileId) {
          return f.copyWith(content: newCode, isUnsaved: true);
        }
        return f;
      }).toList();

      final updatedProject = state.activeProject!.copyWith(files: updatedFiles);
      state = state.copyWith(activeProject: updatedProject);
    }
  }

  void saveCurrentFile() {
    if (state.activeProject == null || state.activeFileId == null) return;

    final updatedFiles = state.activeProject!.files.map((f) {
      if (f.id == state.activeFileId) {
        return f.copyWith(content: state.currentCode, isUnsaved: false);
      }
      return f;
    }).toList();

    final updatedProject = state.activeProject!.copyWith(files: updatedFiles);
    state = state.copyWith(activeProject: updatedProject, isUnsaved: false);

    _ref.read(projectsProvider.notifier).updateProject(updatedProject);
  }

  void changeLanguage(String newLangId) {
    final lang = LanguageConfig.getById(newLangId);
    state = state.copyWith(activeLanguageId: lang.id);

    if (state.activeProject != null && state.activeFileId != null) {
      final updatedFiles = state.activeProject!.files.map((f) {
        if (f.id == state.activeFileId) {
          return f.copyWith(languageId: lang.id);
        }
        return f;
      }).toList();

      final updatedProject = state.activeProject!.copyWith(
        primaryLanguageId: lang.id,
        files: updatedFiles,
      );
      state = state.copyWith(activeProject: updatedProject);
    }
  }

  void addNewFile(String fileName) {
    if (state.activeProject == null) return;
    final ext = fileName.contains('.') ? fileName.split('.').last : 'py';
    final lang = LanguageConfig.getByExtension(ext);

    final newFile = SourceFile(
      name: fileName,
      content: lang.starterTemplate,
      languageId: lang.id,
    );

    final updatedFiles = [...state.activeProject!.files, newFile];
    final updatedProject = state.activeProject!.copyWith(files: updatedFiles);

    state = state.copyWith(activeProject: updatedProject);
    _ref.read(projectsProvider.notifier).updateProject(updatedProject);
    switchToFile(newFile.id);
  }

  void deleteFile(String fileId) {
    if (state.activeProject == null || state.activeProject!.files.length <= 1) return;

    final updatedFiles = state.activeProject!.files.where((f) => f.id != fileId).toList();
    final updatedProject = state.activeProject!.copyWith(files: updatedFiles);

    state = state.copyWith(activeProject: updatedProject);
    _ref.read(projectsProvider.notifier).updateProject(updatedProject);

    closeTab(fileId);
  }

  void toggleFindReplace() {
    state = state.copyWith(isFindReplaceOpen: !state.isFindReplaceOpen);
  }

  void setFindReplaceText(String find, String replace) {
    state = state.copyWith(findText: find, replaceText: replace);
  }

  void performReplace() {
    if (state.findText.isEmpty) return;
    final newCode = state.currentCode.replaceAll(state.findText, state.replaceText);
    updateCode(newCode);
  }
}

final editorProvider = StateNotifierProvider<EditorNotifier, EditorState>((ref) {
  return EditorNotifier(ref);
});
