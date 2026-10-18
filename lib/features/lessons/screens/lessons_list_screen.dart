import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../providers/lessons_provider.dart';

class LessonsListScreen extends ConsumerWidget {
  const LessonsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lessons = ref.watch(lessonsProvider);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Learning Lessons'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: lessons.length,
        itemBuilder: (context, index) {
          final lesson = lessons[index];

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              onTap: () => context.push('/lessons/detail/${lesson.id}'),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          lesson.category,
                          style: const TextStyle(
                            color: AppColors.primaryBlue,
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: Icon(
                          lesson.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: lesson.isBookmarked ? AppColors.accentViolet : AppColors.textMutedDark,
                          size: 20,
                        ),
                        onPressed: () => ref.read(lessonsProvider.notifier).toggleBookmark(lesson.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    lesson.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textPrimaryDark,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    lesson.description,
                    style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.timer_outlined, size: 14, color: AppColors.textMutedDark),
                      const SizedBox(width: 4),
                      Text(
                        '${lesson.estimatedMinutes} min read',
                        style: const TextStyle(color: AppColors.textMutedDark, fontSize: 12),
                      ),
                      const Spacer(),
                      if (lesson.isCompleted)
                        const Row(
                          children: [
                            Icon(Icons.check_circle, size: 16, color: AppColors.accentGreen),
                            SizedBox(width: 4),
                            Text(
                              'Completed',
                              style: TextStyle(color: AppColors.accentGreen, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      else
                        const Text(
                          'Start Lesson →',
                          style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12),
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
