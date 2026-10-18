import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../editor/providers/editor_provider.dart';
import '../../languages/models/language_config.dart';
import '../providers/snippets_provider.dart';

class CodeSnippetsScreen extends ConsumerStatefulWidget {
  const CodeSnippetsScreen({super.key});

  @override
  ConsumerState<CodeSnippetsScreen> createState() => _CodeSnippetsScreenState();
}

class _CodeSnippetsScreenState extends ConsumerState<CodeSnippetsScreen> {
  void _showAddSnippetDialog() {
    final titleController = TextEditingController();
    final codeController = TextEditingController();
    final tagsController = TextEditingController();
    String selectedLangId = 'python';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            title: const Text('New Snippet', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: titleController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Title'),
                  ),
                  const SizedBox(height: 12),
                  DropdownButton<String>(
                    value: selectedLangId,
                    isExpanded: true,
                    dropdownColor: AppColors.surfaceVariantDark,
                    items: LanguageConfig.supportedLanguages.map((lang) {
                      return DropdownMenuItem<String>(
                        value: lang.id,
                        child: Text('${lang.iconAsset} ${lang.name}', style: const TextStyle(color: Colors.white)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setDialogState(() => selectedLangId = val);
                    },
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: tagsController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Tags (comma separated)'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: codeController,
                    maxLines: 5,
                    style: const TextStyle(color: Colors.white, fontFamily: 'JetBrains Mono'),
                    decoration: const InputDecoration(labelText: 'Snippet Code'),
                  ),
                ],
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
                  final title = titleController.text.trim();
                  final code = codeController.text.trim();
                  if (title.isNotEmpty && code.isNotEmpty) {
                    ref.read(snippetsProvider.notifier).addSnippet(
                          title: title,
                          code: code,
                          languageId: selectedLangId,
                          tags: tagsController.text.trim(),
                        );
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Snippet', style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final snippets = ref.watch(snippetsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Code Snippets'),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.black,
        onPressed: _showAddSnippetDialog,
        child: const Icon(Icons.add),
      ),
      body: snippets.isEmpty
          ? EmptyStateWidget(
              icon: Icons.bookmark_border,
              title: 'No Snippets Saved',
              description: 'Save reusable code templates and algorithms for fast insertion.',
              buttonLabel: 'Add Snippet',
              onButtonPressed: _showAddSnippetDialog,
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: snippets.length,
              itemBuilder: (context, index) {
                final snippet = snippets[index];
                final lang = LanguageConfig.getById(snippet.languageId);

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(lang.iconAsset, style: const TextStyle(fontSize: 18)),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                snippet.title,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.copy, size: 18, color: AppColors.textMutedDark),
                              onPressed: () {
                                Clipboard.setData(ClipboardData(text: snippet.code));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Snippet copied to clipboard')),
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.accentRed),
                              onPressed: () => ref.read(snippetsProvider.notifier).deleteSnippet(snippet.id),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.editorBackground,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: SelectableText(
                            snippet.code,
                            maxLines: 4,
                            style: const TextStyle(fontFamily: 'JetBrains Mono', fontSize: 12, color: AppColors.textPrimaryDark),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            if (snippet.tags.isNotEmpty)
                              Text(
                                snippet.tags,
                                style: const TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                              ),
                            const Spacer(),
                            TextButton(
                              onPressed: () {
                                ref.read(editorProvider.notifier).loadStandaloneFile(
                                      title: '${snippet.title.replaceAll(' ', '_')}.${lang.extension}',
                                      code: snippet.code,
                                      languageId: snippet.languageId,
                                    );
                                context.go('/editor');
                              },
                              child: const Text('Open in Editor', style: TextStyle(color: AppColors.primaryBlue, fontSize: 12)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
