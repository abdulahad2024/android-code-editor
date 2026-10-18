import 'package:flutter/material.dart';
import 'package:flutter_highlight/flutter_highlight.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/utils/syntax_highlighter.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../editor/providers/editor_provider.dart';
import '../providers/lessons_provider.dart';

class LessonDetailScreen extends ConsumerWidget {
  final String lessonId;

  const LessonDetailScreen({super.key, required this.lessonId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonsProvider);
    final lesson = lessons.firstWhere(
      (l) => l.id == lessonId,
      orElse: () => lessons.first,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(lesson.title),
        actions: [
          IconButton(
            icon: Icon(
              lesson.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: lesson.isBookmarked ? AppColors.accentViolet : AppColors.textMutedDark,
            ),
            onPressed: () => ref.read(lessonsProvider.notifier).toggleBookmark(lesson.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Tag
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                lesson.category,
                style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12),
              ),
            ),
            const SizedBox(height: 16),

            // Content Body Text
            Text(
              lesson.contentMarkdown,
              style: const TextStyle(fontSize: 15, color: AppColors.textPrimaryDark, height: 1.6),
            ),
            const SizedBox(height: 20),

            // Code Example Card
            const Text(
              'Code Example:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            AppCard(
              backgroundColor: AppColors.editorBackground,
              child: HighlightView(
                lesson.sampleCode,
                language: SyntaxHighlighterUtils.mapLanguageToHighlight(lesson.languageId),
                theme: SyntaxHighlighterUtils.getTheme('atomonedark', isDark: true),
                padding: const EdgeInsets.all(12),
                textStyle: GoogleFonts.jetBrainsMono(fontSize: 13),
              ),
            ),
            const SizedBox(height: 24),

            // Actions
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: 'Try in Editor',
                    icon: Icons.play_arrow,
                    onPressed: () {
                      ref.read(editorProvider.notifier).loadStandaloneFile(
                            title: '${lesson.id}.py',
                            code: lesson.sampleCode,
                            languageId: lesson.languageId,
                          );
                      context.go('/editor');
                    },
                  ),
                ),
                const SizedBox(width: 12),
                IconButton.filledTonal(
                  icon: Icon(
                    lesson.isCompleted ? Icons.check_circle : Icons.check_circle_outline,
                    color: lesson.isCompleted ? AppColors.accentGreen : AppColors.textMutedDark,
                  ),
                  onPressed: () => ref.read(lessonsProvider.notifier).toggleCompleted(lesson.id),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
