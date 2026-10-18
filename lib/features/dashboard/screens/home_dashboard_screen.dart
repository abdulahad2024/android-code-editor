import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';
import '../../editor/providers/editor_provider.dart';
import '../../languages/models/language_config.dart';
import '../../practice/providers/practice_provider.dart';
import '../../projects/providers/projects_provider.dart';

class HomeDashboardScreen extends ConsumerWidget {
  const HomeDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final projects = ref.watch(projectsProvider);
    final challenges = ref.watch(practiceProvider);

    final recentProjects = projects.take(3).toList();
    final dailyChallenge = challenges.first;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Header Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Welcome back, ${authState.user?.name ?? "Developer"}! 👋',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimaryDark,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Write, compile, and master code anytime.',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.textSecondaryDark,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                        child: Text(
                          (authState.user?.name ?? 'D').substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Quick Language Launchers
            SliverToBoxAdapter(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 8),
                    child: Text(
                      'Quick Code Launcher',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: LanguageConfig.supportedLanguages.take(8).length,
                      itemBuilder: (context, index) {
                        final lang = LanguageConfig.supportedLanguages[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ActionChip(
                            avatar: Text(lang.iconAsset, style: const TextStyle(fontSize: 14)),
                            label: Text(lang.name),
                            backgroundColor: AppColors.surfaceDark,
                            side: const BorderSide(color: AppColors.surfaceVariantDark),
                            labelStyle: const TextStyle(
                              color: AppColors.textPrimaryDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                            onPressed: () {
                              ref.read(editorProvider.notifier).loadStandaloneFile(
                                    title: 'quick_${lang.id}.${lang.extension}',
                                    code: lang.starterTemplate,
                                    languageId: lang.id,
                                  );
                              context.go('/editor');
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Daily Coding Challenge Card
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: AppCard(
                  backgroundColor: AppColors.surfaceDark,
                  border: Border.all(color: AppColors.primaryBlue.withOpacity(0.4)),
                  onTap: () => context.push('/practice/challenge/${dailyChallenge.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              '⚡ Daily Challenge',
                              style: TextStyle(
                                color: AppColors.primaryBlue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Text(
                            dailyChallenge.difficulty,
                            style: const TextStyle(
                              color: AppColors.accentGreen,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        dailyChallenge.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimaryDark,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        dailyChallenge.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppColors.textSecondaryDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Recent Workspace Projects
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Row(
                  children: [
                    const Text(
                      'Recent Projects',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () => context.go('/projects'),
                      child: const Text('View All', style: TextStyle(color: AppColors.primaryBlue)),
                    ),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final project = recentProjects[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: AppCard(
                        onTap: () {
                          ref.read(editorProvider.notifier).loadProject(project);
                          context.go('/editor');
                        },
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariantDark,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.code, color: AppColors.primaryBlue),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    project.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15,
                                      color: AppColors.textPrimaryDark,
                                    ),
                                  ),
                                  Text(
                                    '${project.files.length} file(s) • ${project.primaryLanguageId.toUpperCase()}',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMutedDark,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right, color: AppColors.textMutedDark),
                          ],
                        ),
                      ),
                    );
                  },
                  childCount: recentProjects.length,
                ),
              ),
            ),

            // Quick Utilities Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Explore & Practice',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimaryDark,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: AppCard(
                            onTap: () => context.push('/snippets'),
                            child: const Column(
                              children: [
                                Icon(Icons.bookmark_outline, color: AppColors.accentViolet, size: 28),
                                SizedBox(height: 8),
                                Text(
                                  'Snippets',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppCard(
                            onTap: () => context.push('/history'),
                            child: const Column(
                              children: [
                                Icon(Icons.history, color: AppColors.accentAmber, size: 28),
                                SizedBox(height: 8),
                                Text(
                                  'Runs Log',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppCard(
                            onTap: () => context.push('/languages'),
                            child: const Column(
                              children: [
                                Icon(Icons.translate, color: AppColors.accentCyan, size: 28),
                                SizedBox(height: 8),
                                Text(
                                  'Languages',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
