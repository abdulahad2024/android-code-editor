import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../editor/providers/editor_provider.dart';
import '../../languages/models/language_config.dart';
import '../providers/practice_provider.dart';

class ChallengeDetailScreen extends ConsumerWidget {
  final String challengeId;

  const ChallengeDetailScreen({super.key, required this.challengeId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(practiceProvider);
    final challenge = challenges.firstWhere(
      (c) => c.id == challengeId,
      orElse: () => challenges.first,
    );

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: Text(challenge.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category & Difficulty Badges
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceVariantDark,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    challenge.category,
                    style: const TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.accentGreen.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    challenge.difficulty,
                    style: const TextStyle(color: AppColors.accentGreen, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Description
            const Text(
              'Problem Statement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            Text(
              challenge.description,
              style: const TextStyle(fontSize: 14, color: AppColors.textSecondaryDark, height: 1.5),
            ),
            const SizedBox(height: 20),

            // Input / Output Specs
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Input Format:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const SizedBox(height: 4),
                  Text(challenge.inputFormat, style: const TextStyle(color: AppColors.textSecondaryDark)),
                  const SizedBox(height: 12),
                  const Text('Output Format:', style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.primaryBlue)),
                  const SizedBox(height: 4),
                  Text(challenge.outputFormat, style: const TextStyle(color: AppColors.textSecondaryDark)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Sample Test Cases
            const Text(
              'Sample Test Cases',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            const SizedBox(height: 8),
            ...challenge.testCases.where((t) => !t.isHidden).map(
                  (testCase) => Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: AppCard(
                      backgroundColor: AppColors.editorBackground,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Input: ${testCase.input}', style: const TextStyle(fontFamily: 'JetBrains Mono', color: Colors.white)),
                          const SizedBox(height: 4),
                          Text('Expected Output: ${testCase.expectedOutput}', style: const TextStyle(fontFamily: 'JetBrains Mono', color: AppColors.accentGreen)),
                        ],
                      ),
                    ),
                  ),
                ),
            const SizedBox(height: 24),

            // Solve Button
            AppButton(
              label: 'Solve in Code Editor',
              icon: Icons.code,
              width: double.infinity,
              onPressed: () {
                final lang = LanguageConfig.getById(challenge.defaultLanguageId);
                ref.read(editorProvider.notifier).loadStandaloneFile(
                      title: '${challenge.id}.${lang.extension}',
                      code: challenge.starterCode,
                      languageId: challenge.defaultLanguageId,
                    );
                context.go('/editor');
              },
            ),
          ],
        ),
      ),
    );
  }
}
