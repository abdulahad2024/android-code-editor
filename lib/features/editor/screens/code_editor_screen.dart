import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../execution/providers/execution_provider.dart';
import '../../settings/providers/settings_provider.dart';
import '../providers/editor_provider.dart';
import '../widgets/code_editor_widget.dart';
import '../widgets/editor_toolbar.dart';
import '../widgets/find_replace_bar.dart';
import '../widgets/symbol_shortcut_bar.dart';
import '../widgets/web_preview_dialog.dart';
import '../../execution/widgets/execution_console_widget.dart';

class CodeEditorScreen extends ConsumerStatefulWidget {
  const CodeEditorScreen({super.key});

  @override
  ConsumerState<CodeEditorScreen> createState() => _CodeEditorScreenState();
}

class _CodeEditorScreenState extends ConsumerState<CodeEditorScreen> {
  bool _isConsoleVisible = false;

  void _showNewFileDialog() {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surfaceDark,
        title: const Text('Create New File', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: nameController,
          autofocus: true,
          style: const TextStyle(color: Colors.white),
          decoration: const InputDecoration(
            hintText: 'e.g., utils.py or script.js',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMutedDark)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryBlue),
            onPressed: () {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                ref.read(editorProvider.notifier).addNewFile(name);
                Navigator.pop(context);
              }
            },
            child: const Text('Create', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editorState = ref.watch(editorProvider);
    final editorNotifier = ref.read(editorProvider.notifier);
    final settingsState = ref.watch(settingsProvider);
    final execState = ref.watch(executionProvider);
    final execNotifier = ref.read(executionProvider.notifier);

    final activeFile = editorState.activeFile;

    return Scaffold(
      backgroundColor: AppColors.editorBackground,
      body: SafeArea(
        child: Column(
          children: [
            // Editor Main Header Toolbar
            EditorToolbar(
              title: activeFile?.name ?? editorState.activeProject?.name ?? 'Untitled.py',
              activeLanguageId: editorState.activeLanguageId,
              isUnsaved: editorState.isUnsaved,
              onLanguageChanged: (langId) => editorNotifier.changeLanguage(langId),
              onSaveTap: () {
                editorNotifier.saveCurrentFile();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('File saved successfully')),
                );
              },
              onSearchTap: () => editorNotifier.toggleFindReplace(),
              onNewFileTap: editorState.activeProject != null ? _showNewFileDialog : null,
              onWebPreviewTap: () {
                showDialog(
                  context: context,
                  builder: (context) => WebPreviewDialog(htmlContent: editorState.currentCode),
                );
              },
              onRunTap: () async {
                setState(() => _isConsoleVisible = true);
                await execNotifier.runCode(
                  code: editorState.currentCode,
                  languageId: editorState.activeLanguageId,
                );
              },
            ),

            // Tab Bar for Open Files
            if (editorState.activeProject != null && editorState.openFileIds.isNotEmpty)
              Container(
                height: 38,
                color: AppColors.surfaceDark,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: editorState.activeProject!.files.length,
                  itemBuilder: (context, index) {
                    final file = editorState.activeProject!.files[index];
                    final isActive = file.id == editorState.activeFileId;

                    return GestureDetector(
                      onTap: () => editorNotifier.switchToFile(file.id),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.editorBackground : AppColors.surfaceDark,
                          border: Border(
                            top: BorderSide(
                              color: isActive ? AppColors.primaryBlue : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              file.name,
                              style: TextStyle(
                                fontSize: 13,
                                color: isActive ? AppColors.textPrimaryDark : AppColors.textMutedDark,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            if (file.isUnsaved)
                              Container(
                                margin: const EdgeInsets.only(left: 4),
                                width: 6,
                                height: 6,
                                decoration: const BoxDecoration(
                                  color: AppColors.accentAmber,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

            // Find & Replace Floating Panel
            if (editorState.isFindReplaceOpen)
              FindReplaceBar(
                findText: editorState.findText,
                replaceText: editorState.replaceText,
                onFindChanged: (val) => editorNotifier.setFindReplaceText(val, editorState.replaceText),
                onReplaceChanged: (val) => editorNotifier.setFindReplaceText(editorState.findText, val),
                onReplaceTap: () => editorNotifier.performReplace(),
                onCloseTap: () => editorNotifier.toggleFindReplace(),
              ),

            // Main Code Editor Workspace Area
            Expanded(
              child: CodeEditorWidget(
                code: editorState.currentCode,
                languageId: editorState.activeLanguageId,
                fontSize: settingsState.fontSize,
                showLineNumbers: settingsState.showLineNumbers,
                isLineWrap: settingsState.isLineWrapEnabled,
                onCodeChanged: (newCode) => editorNotifier.updateCode(newCode),
              ),
            ),

            // Quick Programming Symbol Shortcuts Keyboard Bar
            SymbolShortcutBar(
              onSymbolTap: (symbol) {
                final current = editorState.currentCode;
                editorNotifier.updateCode(current + symbol);
              },
              onTabTap: () {
                final current = editorState.currentCode;
                editorNotifier.updateCode('$current    ');
              },
            ),

            // Run Execution Console Drawer
            if (_isConsoleVisible)
              ExecutionConsoleWidget(
                result: execState.lastResult,
                isExecuting: execState.isExecuting,
                stdin: execState.stdin,
                onStdinChanged: (val) => execNotifier.setStdin(val),
                onRunTap: () {
                  execNotifier.runCode(
                    code: editorState.currentCode,
                    languageId: editorState.activeLanguageId,
                  );
                },
                onClearTap: () => execNotifier.clearConsole(),
                onCloseTap: () => setState(() => _isConsoleVisible = false),
              ),
          ],
        ),
      ),
    );
  }
}
