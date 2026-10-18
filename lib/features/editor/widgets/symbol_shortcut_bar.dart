import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';

class SymbolShortcutBar extends StatelessWidget {
  final ValueChanged<String> onSymbolTap;
  final VoidCallback? onTabTap;
  final VoidCallback? onUndoTap;
  final VoidCallback? onRedoTap;

  const SymbolShortcutBar({
    super.key,
    required this.onSymbolTap,
    this.onTabTap,
    this.onUndoTap,
    this.onRedoTap,
  });

  static const List<String> _symbols = [
    'Tab',
    '{',
    '}',
    '(',
    ')',
    '[',
    ']',
    ';',
    '=',
    ':',
    '"',
    "'",
    '<',
    '>',
    '+',
    '-',
    '*',
    '/',
    '%',
    '!',
    '&',
    '|',
    '#',
    '_',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      color: AppColors.surfaceDark,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _symbols.length,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        itemBuilder: (context, index) {
          final symbol = _symbols[index];
          return Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Material(
              color: AppColors.surfaceVariantDark,
              borderRadius: BorderRadius.circular(6),
              child: InkWell(
                borderRadius: BorderRadius.circular(6),
                onTap: () {
                  if (symbol == 'Tab') {
                    onTabTap?.call();
                  } else {
                    onSymbolTap(symbol);
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  alignment: Alignment.center,
                  child: Text(
                    symbol,
                    style: const TextStyle(
                      color: AppColors.textPrimaryDark,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'JetBrains Mono',
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
