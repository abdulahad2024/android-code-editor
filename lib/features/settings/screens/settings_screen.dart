import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsState = ref.watch(settingsProvider);
    final settingsNotifier = ref.read(settingsProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Editor Preferences & Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('Theme & Display', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          ListTile(
            tileColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text('Theme Mode', style: TextStyle(color: Colors.white)),
            subtitle: Text(
              settingsState.themeMode == ThemeMode.dark ? 'Developer Dark (Default)' : 'Developer Light',
              style: const TextStyle(color: AppColors.textSecondaryDark),
            ),
            trailing: Switch(
              value: settingsState.themeMode == ThemeMode.dark,
              activeColor: AppColors.primaryBlue,
              onChanged: (_) => settingsNotifier.toggleTheme(),
            ),
          ),
          const SizedBox(height: 16),

          const Text('Editor Configuration', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          ListTile(
            tileColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: Text('Font Size: ${settingsState.fontSize.toInt()} px', style: const TextStyle(color: Colors.white)),
            subtitle: Slider(
              value: settingsState.fontSize,
              min: 10,
              max: 28,
              divisions: 18,
              activeColor: AppColors.primaryBlue,
              onChanged: (val) => settingsNotifier.updateFontSize(val),
            ),
          ),
          const SizedBox(height: 8),

          SwitchListTile(
            tileColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text('Show Line Numbers', style: TextStyle(color: Colors.white)),
            value: settingsState.showLineNumbers,
            activeColor: AppColors.primaryBlue,
            onChanged: (_) => settingsNotifier.toggleLineNumbers(),
          ),
          const SizedBox(height: 8),

          SwitchListTile(
            tileColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            title: const Text('Line Wrapping', style: TextStyle(color: Colors.white)),
            value: settingsState.isLineWrapEnabled,
            activeColor: AppColors.primaryBlue,
            onChanged: (_) => settingsNotifier.toggleLineWrap(),
          ),
          const SizedBox(height: 24),

          const Text('Data & Storage', style: TextStyle(color: AppColors.primaryBlue, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),

          ListTile(
            tileColor: AppColors.surfaceDark,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: const Icon(Icons.delete_outline, color: AppColors.accentRed),
            title: const Text('Clear All Local Workspace Data', style: TextStyle(color: AppColors.accentRed)),
            onTap: () async {
              final storage = await ref.read(localStorageProvider.future);
              await storage.clearAll();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Local storage cleared.')),
                );
              }
            },
          ),
          const SizedBox(height: 24),

          const Center(
            child: Text(
              'CodeVerse v${AppConstants.appVersion}\nBuilt with Flutter & Riverpod',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textMutedDark, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
