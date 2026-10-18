import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class FindReplaceBar extends StatelessWidget {
  final String findText;
  final String replaceText;
  final ValueChanged<String> onFindChanged;
  final ValueChanged<String> onReplaceChanged;
  final VoidCallback onReplaceTap;
  final VoidCallback onCloseTap;

  const FindReplaceBar({
    super.key,
    required this.findText,
    required this.replaceText,
    required this.onFindChanged,
    required this.onReplaceChanged,
    required this.onReplaceTap,
    required this.onCloseTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      color: AppColors.surfaceDark,
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Find...',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  onChanged: onFindChanged,
                ),
                const SizedBox(height: 6),
                TextField(
                  style: const TextStyle(fontSize: 13, color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: 'Replace with...',
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  ),
                  onChanged: onReplaceChanged,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.find_replace, color: AppColors.primaryBlue),
            tooltip: 'Replace All',
            onPressed: onReplaceTap,
          ),
          IconButton(
            icon: const Icon(Icons.close, color: AppColors.textMutedDark),
            tooltip: 'Close Search',
            onPressed: onCloseTap,
          ),
        ],
      ),
    );
  }
}
