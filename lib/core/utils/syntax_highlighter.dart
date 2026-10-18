import 'package:flutter/material.dart';
import 'package:flutter_highlight/themes/atom-one-dark.dart';
import 'package:flutter_highlight/themes/atom-one-light.dart';
import 'package:flutter_highlight/themes/dracula.dart';
import 'package:flutter_highlight/themes/vs2015.dart';

class SyntaxHighlighterUtils {
  static String mapLanguageToHighlight(String langId) {
    switch (langId.toLowerCase()) {
      case 'python':
      case 'py':
        return 'python';
      case 'java':
        return 'java';
      case 'c':
        return 'cpp';
      case 'cpp':
      case 'c++':
        return 'cpp';
      case 'javascript':
      case 'js':
        return 'javascript';
      case 'typescript':
      case 'ts':
        return 'typescript';
      case 'dart':
        return 'dart';
      case 'php':
        return 'php';
      case 'csharp':
      case 'c#':
      case 'cs':
        return 'cs';
      case 'go':
      case 'golang':
        return 'go';
      case 'rust':
      case 'rs':
        return 'rust';
      case 'ruby':
      case 'rb':
        return 'ruby';
      case 'kotlin':
      case 'kt':
        return 'kotlin';
      case 'swift':
        return 'swift';
      case 'sql':
        return 'sql';
      case 'html':
        return 'xml';
      case 'css':
        return 'css';
      case 'json':
        return 'json';
      default:
        return 'plaintext';
    }
  }

  static Map<String, TextStyle> getTheme(String themeName, {bool isDark = true}) {
    switch (themeName.toLowerCase()) {
      case 'dracula':
        return draculaTheme;
      case 'vs2015':
        return vs2015Theme;
      case 'light':
        return atomOneLightTheme;
      case 'atomonedark':
      default:
        return isDark ? atomOneDarkTheme : atomOneLightTheme;
    }
  }
}
