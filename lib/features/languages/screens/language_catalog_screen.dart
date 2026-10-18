import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../editor/providers/editor_provider.dart';
import '../models/language_config.dart';

class LanguageCatalogScreen extends ConsumerWidget {
  const LanguageCatalogScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Programming Languages'),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: LanguageConfig.supportedLanguages.length,
        itemBuilder: (context, index) {
          final lang = LanguageConfig.supportedLanguages[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: AppCard(
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceVariantDark,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(lang.iconAsset, style: const TextStyle(fontSize: 24)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              lang.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.surfaceVariantDark,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                '.${lang.extension}',
                                style: const TextStyle(
                                  color: AppColors.primaryBlue,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'JetBrains Mono',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          lang.category,
                          style: const TextStyle(fontSize: 12, color: AppColors.textMutedDark),
                        ),
                      ],
                    ),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue.withOpacity(0.15),
                      foregroundColor: AppColors.primaryBlue,
                      elevation: 0,
                    ),
                    onPressed: () {
                      ref.read(editorProvider.notifier).loadStandaloneFile(
                            title: 'main.${lang.extension}',
                            code: lang.starterTemplate,
                            languageId: lang.id,
                          );
                      context.go('/editor');
                    },
                    child: const Text('Code Now'),
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
