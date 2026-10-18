import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/empty_state_widget.dart';
import '../../execution/providers/execution_provider.dart';

class ExecutionHistoryScreen extends ConsumerWidget {
  const ExecutionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final execState = ref.watch(executionProvider);
    final history = execState.history;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Execution Runs History'),
        actions: [
          if (history.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_sweep, color: AppColors.textMutedDark),
              tooltip: 'Clear History',
              onPressed: () => ref.read(executionProvider.notifier).clearHistory(),
            ),
        ],
      ),
      body: history.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.history,
              title: 'No Run Logs Yet',
              description: 'Your code execution history and compilation outputs will appear here.',
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final run = history[index];

                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              run.isSuccess ? Icons.check_circle : Icons.error,
                              color: run.isSuccess ? AppColors.accentGreen : AppColors.accentRed,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              run.statusDescription,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: run.isSuccess ? AppColors.accentGreen : AppColors.accentRed,
                              ),
                            ),
                            const Spacer(),
                            Text(
                              '${run.timestamp.hour}:${run.timestamp.minute.toString().padLeft(2, '0')}',
                              style: const TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                            ),
                          ],
                        ),
                        if (run.stdout != null && run.stdout!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.editorBackground,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: SelectableText(
                              run.stdout!,
                              maxLines: 3,
                              style: GoogleFonts.jetBrainsMono(fontSize: 11, color: AppColors.textPrimaryDark),
                            ),
                          ),
                        ],
                        if (run.executionTime != null) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Duration: ${run.executionTime} • Memory: ${run.memoryUsedKb ?? 0} KB',
                            style: const TextStyle(color: AppColors.textMutedDark, fontSize: 11),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
