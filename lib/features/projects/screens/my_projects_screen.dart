import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../editor/providers/editor_provider.dart';
import '../../languages/models/language_config.dart';
import '../providers/projects_provider.dart';

class MyProjectsScreen extends ConsumerStatefulWidget {
  const MyProjectsScreen({super.key});

  @override
  ConsumerState<MyProjectsScreen> createState() => _MyProjectsScreenState();
}

class _MyProjectsScreenState extends ConsumerState<MyProjectsScreen> {
  String _searchQuery = '';
  bool _showFavoritesOnly = false;

  void _showCreateProjectDialog() {
    final nameController = TextEditingController();
    final descController = TextEditingController();
    String selectedLangId = 'python';

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            backgroundColor: AppColors.surfaceDark,
            title: const Text('Create New Project', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextField(
                    controller: nameController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Project Name'),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: descController,
                    style: const TextStyle(color: Colors.white),
                    decoration: const InputDecoration(labelText: 'Description (Optional)'),
                  ),
                  const SizedBox(height: 16),
                  const Text('Primary Language:', style: TextStyle(color: AppColors.textSecondaryDark)),
                  const SizedBox(height: 6),
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
                  final name = nameController.text.trim();
                  if (name.isNotEmpty) {
                    final newProj = ref.read(projectsProvider.notifier).createProject(
                          name: name,
                          description: descController.text.trim(),
                          languageId: selectedLangId,
                        );
                    Navigator.pop(context);
                    ref.read(editorProvider.notifier).loadProject(newProj);
                    context.go('/editor');
                  }
                },
                child: const Text('Create & Open', style: TextStyle(color: Colors.black)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final projects = ref.watch(projectsProvider);
    final projectsNotifier = ref.read(projectsProvider.notifier);

    final filteredProjects = projects.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.primaryLanguageId.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesFav = !_showFavoritesOnly || p.isFavorite;
      return matchesSearch && matchesFav;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('My Projects'),
        actions: [
          IconButton(
            icon: Icon(
              _showFavoritesOnly ? Icons.star : Icons.star_border,
              color: _showFavoritesOnly ? AppColors.accentAmber : AppColors.textMutedDark,
            ),
            tooltip: 'Filter Favorites',
            onPressed: () => setState(() => _showFavoritesOnly = !_showFavoritesOnly),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryBlue,
        foregroundColor: Colors.black,
        onPressed: _showCreateProjectDialog,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // Search Field
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search projects by name or language...',
                prefixIcon: const Icon(Icons.search, color: AppColors.textMutedDark),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: AppColors.textMutedDark),
                        onPressed: () => setState(() => _searchQuery = ''),
                      )
                    : null,
              ),
              onChanged: (val) => setState(() => _searchQuery = val),
            ),
          ),

          // Projects List
          Expanded(
            child: filteredProjects.isEmpty
                ? EmptyStateWidget(
                    icon: Icons.folder_open,
                    title: 'No Projects Found',
                    description: _searchQuery.isNotEmpty
                        ? 'No projects match "$_searchQuery".'
                        : 'Create your first project to start coding!',
                    buttonLabel: 'Create Project',
                    onButtonPressed: _showCreateProjectDialog,
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: filteredProjects.length,
                    itemBuilder: (context, index) {
                      final project = filteredProjects[index];
                      final lang = LanguageConfig.getById(project.primaryLanguageId);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: AppCard(
                          onTap: () {
                            ref.read(editorProvider.notifier).loadProject(project);
                            context.go('/editor');
                          },
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(lang.iconAsset, style: const TextStyle(fontSize: 20)),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      project.name,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: AppColors.textPrimaryDark,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      project.isFavorite ? Icons.star : Icons.star_border,
                                      color: project.isFavorite ? AppColors.accentAmber : AppColors.textMutedDark,
                                    ),
                                    onPressed: () => projectsNotifier.toggleFavorite(project.id),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete_outline, color: AppColors.accentRed),
                                    onPressed: () => projectsNotifier.deleteProject(project.id),
                                  ),
                                ],
                              ),
                              if (project.description.isNotEmpty) ...[
                                const SizedBox(height: 4),
                                Text(
                                  project.description,
                                  style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                                ),
                              ],
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Text(
                                    '${project.files.length} file(s)',
                                    style: const TextStyle(color: AppColors.textMutedDark, fontSize: 12),
                                  ),
                                  const Spacer(),
                                  Text(
                                    'Updated ${project.updatedAt.day}/${project.updatedAt.month}/${project.updatedAt.year}',
                                    style: const TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
