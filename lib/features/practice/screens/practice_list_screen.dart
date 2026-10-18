import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../providers/practice_provider.dart';

class PracticeListScreen extends ConsumerStatefulWidget {
  const PracticeListScreen({super.key});

  @override
  ConsumerState<PracticeListScreen> createState() => _PracticeListScreenState();
}

class _PracticeListScreenState extends ConsumerState<PracticeListScreen> {
  String _selectedDifficulty = 'All';

  @override
  Widget build(BuildContext context) {
    final challenges = ref.watch(practiceProvider);

    final filtered = challenges.where((c) {
      if (_selectedDifficulty == 'All') return true;
      return c.difficulty.toLowerCase() == _selectedDifficulty.toLowerCase();
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Practice & Challenges'),
      ),
      body: Column(
        children: [
          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: ['All', 'Beginner', 'Intermediate', 'Advanced'].map((diff) {
                final isSelected = _selectedDifficulty == diff;
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(diff),
                    selected: isSelected,
                    selectedColor: AppColors.primaryBlue,
                    backgroundColor: AppColors.surfaceDark,
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.black : AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                    ),
                    onSelected: (selected) {
                      if (selected) setState(() => _selectedDifficulty = diff);
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          // Challenges List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filtered.length,
              itemBuilder: (context, index) {
                final challenge = filtered[index];

                Color diffColor = AppColors.accentGreen;
                if (challenge.difficulty == 'Intermediate') diffColor = AppColors.accentAmber;
                if (challenge.difficulty == 'Advanced') diffColor = AppColors.accentRed;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    onTap: () => context.push('/practice/challenge/${challenge.id}'),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              challenge.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: AppColors.textPrimaryDark,
                              ),
                            ),
                            const Spacer(),
                            if (challenge.isCompleted)
                              const Icon(Icons.check_circle, color: AppColors.accentGreen, size: 18)
                            else
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                decoration: BoxDecoration(
                                  color: diffColor.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  challenge.difficulty,
                                  style: TextStyle(color: diffColor, fontSize: 11, fontWeight: FontWeight.bold),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          challenge.description,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: AppColors.textSecondaryDark, fontSize: 13),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          children: [
                            Text(
                              challenge.category,
                              style: const TextStyle(color: AppColors.primaryBlue, fontSize: 12),
                            ),
                            const Spacer(),
                            const Text(
                              'Solve Challenge →',
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
          ),
        ],
      ),
    );
  }
}
