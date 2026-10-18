import 'package:flutter/material.dart';
import '../../../app/theme/app_colors.dart';
import '../../languages/models/language_config.dart';

class EditorToolbar extends StatelessWidget {
  final String title;
  final String activeLanguageId;
  final bool isUnsaved;
  final ValueChanged<String> onLanguageChanged;
  final VoidCallback onSaveTap;
  final VoidCallback onRunTap;
  final VoidCallback onSearchTap;
  final VoidCallback? onWebPreviewTap;
  final VoidCallback? onNewFileTap;

  const EditorToolbar({
    super.key,
    required this.title,
    required this.activeLanguageId,
    required this.isUnsaved,
    required this.onLanguageChanged,
    required this.onSaveTap,
    required this.onRunTap,
    required this.onSearchTap,
    this.onWebPreviewTap,
    this.onNewFileTap,
  });

  @override
  Widget build(BuildContext context) {
    final activeLang = LanguageConfig.getById(activeLanguageId);

    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        border: Border(
          bottom: BorderSide(
            color: Colors.white.withOpacity(0.06),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // File icon badge
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: AppColors.primaryBlue.withOpacity(0.25),
              ),
            ),
            child: Text(
              activeLang.iconAsset,
              style: const TextStyle(fontSize: 14),
            ),
          ),
          const SizedBox(width: 10),

          // Title + unsaved indicator
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      letterSpacing: 0.2,
                      color: AppColors.textPrimaryDark,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (isUnsaved)
                  Container(
                    margin: const EdgeInsets.only(left: 6),
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.accentAmber,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accentAmber.withOpacity(0.6),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // Language picker as a pill chip (PopupMenu => menu width is independent of the chip)
          PopupMenuButton<String>(
            tooltip: 'Language',
            padding: EdgeInsets.zero,
            initialValue: activeLang.id,
            color: AppColors.surfaceVariantDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            onSelected: onLanguageChanged,
            itemBuilder: (context) {
              return LanguageConfig.supportedLanguages.map((lang) {
                final selected = lang.id == activeLang.id;
                return PopupMenuItem<String>(
                  value: lang.id,
                  height: 40,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(lang.iconAsset, style: const TextStyle(fontSize: 14)),
                      const SizedBox(width: 10),
                      Text(
                        lang.name,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight:
                          selected ? FontWeight.bold : FontWeight.normal,
                          color: selected
                              ? AppColors.primaryBlue
                              : AppColors.textPrimaryDark,
                        ),
                      ),
                      if (selected) ...[
                        const SizedBox(width: 10),
                        const Icon(Icons.check_rounded,
                            size: 16, color: AppColors.primaryBlue),
                      ],
                    ],
                  ),
                );
              }).toList();
            },
            child: Container(
              height: 28,
              padding: const EdgeInsets.only(left: 10, right: 4),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.10),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppColors.primaryBlue.withOpacity(0.30),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    activeLang.extension.toUpperCase(),
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                      color: AppColors.primaryBlue,
                      fontFamily: 'JetBrains Mono',
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primaryBlue,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(width: 6),

          // Thin divider
          Container(
            width: 1,
            height: 20,
            color: Colors.white.withOpacity(0.08),
          ),

          const SizedBox(width: 4),

          // Search
          _ToolbarIconButton(
            icon: Icons.search_rounded,
            color: AppColors.textSecondaryDark,
            tooltip: 'Find / Replace',
            onTap: onSearchTap,
          ),

          // Save
          _ToolbarIconButton(
            icon: Icons.save_outlined,
            color: isUnsaved ? AppColors.accentAmber : AppColors.textMutedDark,
            tooltip: 'Save File',
            highlight: isUnsaved ? AppColors.accentAmber : null,
            onTap: onSaveTap,
          ),

          // Web preview
          if (activeLang.isWebPreviewSupported && onWebPreviewTap != null)
            _ToolbarIconButton(
              icon: Icons.preview_outlined,
              color: AppColors.accentCyan,
              tooltip: 'Live Web Preview',
              highlight: AppColors.accentCyan,
              onTap: onWebPreviewTap!,
            ),

          // Overflow menu
          PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
            icon: const Icon(Icons.more_vert_rounded,
                color: AppColors.textMutedDark, size: 20),
            color: AppColors.surfaceVariantDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.white.withOpacity(0.08)),
            ),
            onSelected: (value) {
              if (value == 'new_file') {
                onNewFileTap?.call();
              }
            },
            itemBuilder: (context) => [
              if (onNewFileTap != null)
                const PopupMenuItem<String>(
                  value: 'new_file',
                  child: Row(
                    children: [
                      Icon(Icons.add_circle_outline,
                          color: AppColors.primaryBlue, size: 18),
                      SizedBox(width: 10),
                      Text('New File',
                          style: TextStyle(color: Colors.white, fontSize: 13)),
                    ],
                  ),
                ),
            ],
          ),

          const SizedBox(width: 6),

          // Run button with soft glow
          Container(
            height: 32,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: AppColors.accentGreen.withOpacity(0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.accentGreen,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              onPressed: onRunTap,
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text(
                'Run',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 12,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Small rounded icon button with ripple and optional soft highlight.
class _ToolbarIconButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String tooltip;
  final VoidCallback onTap;
  final Color? highlight;

  const _ToolbarIconButton({
    required this.icon,
    required this.color,
    required this.tooltip,
    required this.onTap,
    this.highlight,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1),
        child: Material(
          color: highlight?.withOpacity(0.10) ?? Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            borderRadius: BorderRadius.circular(8),
            onTap: onTap,
            child: SizedBox(
              width: 32,
              height: 32,
              child: Icon(icon, color: color, size: 20),
            ),
          ),
        ),
      ),
    );
  }
}