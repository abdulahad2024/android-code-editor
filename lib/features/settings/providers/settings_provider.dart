import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/storage/local_storage_service.dart';

class SettingsState {
  final ThemeMode themeMode;
  final double fontSize;
  final String fontFamily;
  final bool isLineWrapEnabled;
  final bool showLineNumbers;
  final bool autoIndent;
  final String preferredLanguageId;

  SettingsState({
    this.themeMode = ThemeMode.dark,
    this.fontSize = AppConstants.defaultFontSize,
    this.fontFamily = AppConstants.defaultFontFamily,
    this.isLineWrapEnabled = AppConstants.defaultLineWrap,
    this.showLineNumbers = AppConstants.defaultShowLineNumbers,
    this.autoIndent = AppConstants.defaultAutoIndent,
    this.preferredLanguageId = AppConstants.defaultLanguageId,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    double? fontSize,
    String? fontFamily,
    bool? isLineWrapEnabled,
    bool? showLineNumbers,
    bool? autoIndent,
    String? preferredLanguageId,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      fontSize: fontSize ?? this.fontSize,
      fontFamily: fontFamily ?? this.fontFamily,
      isLineWrapEnabled: isLineWrapEnabled ?? this.isLineWrapEnabled,
      showLineNumbers: showLineNumbers ?? this.showLineNumbers,
      autoIndent: autoIndent ?? this.autoIndent,
      preferredLanguageId: preferredLanguageId ?? this.preferredLanguageId,
    );
  }

  Map<String, dynamic> toJson() => {
        'themeMode': themeMode.name,
        'fontSize': fontSize,
        'fontFamily': fontFamily,
        'isLineWrapEnabled': isLineWrapEnabled,
        'showLineNumbers': showLineNumbers,
        'autoIndent': autoIndent,
        'preferredLanguageId': preferredLanguageId,
      };

  factory SettingsState.fromJson(Map<String, dynamic> json) => SettingsState(
        themeMode: ThemeMode.values.firstWhere(
          (e) => e.name == json['themeMode'],
          orElse: () => ThemeMode.dark,
        ),
        fontSize: (json['fontSize'] as num?)?.toDouble() ?? AppConstants.defaultFontSize,
        fontFamily: json['fontFamily'] as String? ?? AppConstants.defaultFontFamily,
        isLineWrapEnabled: json['isLineWrapEnabled'] as bool? ?? AppConstants.defaultLineWrap,
        showLineNumbers: json['showLineNumbers'] as bool? ?? AppConstants.defaultShowLineNumbers,
        autoIndent: json['autoIndent'] as bool? ?? AppConstants.defaultAutoIndent,
        preferredLanguageId: json['preferredLanguageId'] as String? ?? AppConstants.defaultLanguageId,
      );
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final LocalStorageService? _storage;

  SettingsNotifier(this._storage) : super(SettingsState()) {
    _loadSettings();
  }

  void _loadSettings() {
    if (_storage != null) {
      final json = _storage!.getJsonObject(AppConstants.keyUserSettings);
      if (json != null) {
        state = SettingsState.fromJson(json);
      }
    }
  }

  Future<void> _saveSettings() async {
    if (_storage != null) {
      await _storage!.setJsonObject(AppConstants.keyUserSettings, state.toJson());
    }
  }

  void toggleTheme() {
    state = state.copyWith(
      themeMode: state.themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark,
    );
    _saveSettings();
  }

  void updateFontSize(double newSize) {
    state = state.copyWith(fontSize: newSize.clamp(10.0, 32.0));
    _saveSettings();
  }

  void toggleLineWrap() {
    state = state.copyWith(isLineWrapEnabled: !state.isLineWrapEnabled);
    _saveSettings();
  }

  void toggleLineNumbers() {
    state = state.copyWith(showLineNumbers: !state.showLineNumbers);
    _saveSettings();
  }

  void updatePreferredLanguage(String langId) {
    state = state.copyWith(preferredLanguageId: langId);
    _saveSettings();
  }
}

final localStorageProvider = FutureProvider<LocalStorageService>((ref) async {
  return await LocalStorageService.init();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final storageAsync = ref.watch(localStorageProvider);
  final storage = storageAsync.asData?.value;
  return SettingsNotifier(storage);
});
