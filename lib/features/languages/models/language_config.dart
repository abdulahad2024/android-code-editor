class LanguageConfig {
  final String id;
  final String name;
  final String extension;
  final int? judge0Id;
  final bool isWebPreviewSupported;
  final String iconAsset;
  final String starterTemplate;
  final String category;

  const LanguageConfig({
    required this.id,
    required this.name,
    required this.extension,
    this.judge0Id,
    this.isWebPreviewSupported = false,
    required this.iconAsset,
    required this.starterTemplate,
    required this.category,
  });

  static const List<LanguageConfig> supportedLanguages = [
    LanguageConfig(
      id: 'python',
      name: 'Python 3',
      extension: 'py',
      judge0Id: 71,
      iconAsset: '🐍',
      category: 'General Purpose',
      starterTemplate: '''# CodeVerse - Python Starter
def main():
    print("Hello from CodeVerse Python!")
    name = input("Enter your name: ") if False else "Developer"
    print(f"Welcome to CodeVerse, {name}!")

if __name__ == "__main__":
    main()
''',
    ),
    LanguageConfig(
      id: 'java',
      name: 'Java',
      extension: 'java',
      judge0Id: 62,
      iconAsset: '☕',
      category: 'Object Oriented',
      starterTemplate: '''// CodeVerse - Java Starter
public class Main {
    public static void main(String[] args) {
        System.out.println("Hello from CodeVerse Java!");
    }
}
''',
    ),
    LanguageConfig(
      id: 'cpp',
      name: 'C++',
      extension: 'cpp',
      judge0Id: 54,
      iconAsset: '⚡',
      category: 'Systems',
      starterTemplate: '''// CodeVerse - C++ Starter
#include <iostream>

int main() {
    std::cout << "Hello from CodeVerse C++!" << std::endl;
    return 0;
}
''',
    ),
    LanguageConfig(
      id: 'c',
      name: 'C',
      extension: 'c',
      judge0Id: 50,
      iconAsset: '🔧',
      category: 'Systems',
      starterTemplate: '''// CodeVerse - C Starter
#include <stdio.stdio>
#include <stdio.h>

int main() {
    printf("Hello from CodeVerse C!\\n");
    return 0;
}
''',
    ),
    LanguageConfig(
      id: 'javascript',
      name: 'JavaScript (Node.js)',
      extension: 'js',
      judge0Id: 63,
      isWebPreviewSupported: true,
      iconAsset: '📜',
      category: 'Web & Scripting',
      starterTemplate: '''// CodeVerse - JavaScript Starter
function greet(name = "Developer") {
    console.log(`Hello from CodeVerse JavaScript, \${name}!`);
}

greet();
''',
    ),
    LanguageConfig(
      id: 'typescript',
      name: 'TypeScript',
      extension: 'ts',
      judge0Id: 74,
      iconAsset: '📘',
      category: 'Web',
      starterTemplate: '''// CodeVerse - TypeScript Starter
interface User {
    name: string;
    role: string;
}

const user: User = { name: "CodeVerse User", role: "Developer" };
console.log(`Hello \${user.name} (\${user.role})!`);
''',
    ),
    LanguageConfig(
      id: 'dart',
      name: 'Dart',
      extension: 'dart',
      judge0Id: 90,
      iconAsset: '🎯',
      category: 'Mobile & Web',
      starterTemplate: '''// CodeVerse - Dart Starter
void main() {
  print('Hello from CodeVerse Dart!');
  final languages = ['Python', 'Dart', 'Java', 'C++'];
  print('Supported languages: \${languages.join(", ")}');
}
''',
    ),
    LanguageConfig(
      id: 'php',
      name: 'PHP',
      extension: 'php',
      judge0Id: 68,
      iconAsset: '🐘',
      category: 'Web Backend',
      starterTemplate: '''<?php
// CodeVerse - PHP Starter
echo "Hello from CodeVerse PHP!\\n";
?>
''',
    ),
    LanguageConfig(
      id: 'csharp',
      name: 'C#',
      extension: 'cs',
      judge0Id: 51,
      iconAsset: '🔷',
      category: 'Enterprise',
      starterTemplate: '''// CodeVerse - C# Starter
using System;

class Program {
    static void Main() {
        Console.WriteLine("Hello from CodeVerse C#!");
    }
}
''',
    ),
    LanguageConfig(
      id: 'go',
      name: 'Go',
      extension: 'go',
      judge0Id: 60,
      iconAsset: '🐹',
      category: 'Cloud & Systems',
      starterTemplate: '''// CodeVerse - Go Starter
package main

import "fmt"

func main() {
    fmt.Println("Hello from CodeVerse Go!")
}
''',
    ),
    LanguageConfig(
      id: 'rust',
      name: 'Rust',
      extension: 'rs',
      judge0Id: 73,
      iconAsset: '🦀',
      category: 'Systems',
      starterTemplate: '''// CodeVerse - Rust Starter
fn main() {
    println!("Hello from CodeVerse Rust!");
}
''',
    ),
    LanguageConfig(
      id: 'ruby',
      name: 'Ruby',
      extension: 'rb',
      judge0Id: 72,
      iconAsset: '💎',
      category: 'Scripting',
      starterTemplate: '''# CodeVerse - Ruby Starter
puts "Hello from CodeVerse Ruby!"
''',
    ),
    LanguageConfig(
      id: 'kotlin',
      name: 'Kotlin',
      extension: 'kt',
      judge0Id: 78,
      iconAsset: '🟪',
      category: 'Android & JVM',
      starterTemplate: '''// CodeVerse - Kotlin Starter
fun main() {
    println("Hello from CodeVerse Kotlin!")
}
''',
    ),
    LanguageConfig(
      id: 'swift',
      name: 'Swift',
      extension: 'swift',
      judge0Id: 83,
      iconAsset: '🐦',
      category: 'iOS & Systems',
      starterTemplate: '''// CodeVerse - Swift Starter
print("Hello from CodeVerse Swift!")
''',
    ),
    LanguageConfig(
      id: 'sql',
      name: 'SQL (SQLite)',
      extension: 'sql',
      judge0Id: 82,
      iconAsset: '🗄️',
      category: 'Database',
      starterTemplate: '''-- CodeVerse - SQL Starter
CREATE TABLE users (id INTEGER PRIMARY KEY, name TEXT, role TEXT);
INSERT INTO users (name, role) VALUES ('Alice', 'Developer'), ('Bob', 'Designer');
SELECT * FROM users;
''',
    ),
    LanguageConfig(
      id: 'html',
      name: 'HTML5 / CSS / JS',
      extension: 'html',
      isWebPreviewSupported: true,
      iconAsset: '🌐',
      category: 'Web Frontend',
      starterTemplate: '''<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      background-color: #0f172a;
      color: #f8fafc;
      text-align: center;
      padding: 40px 20px;
    }
    h1 { color: #38bdf8; }
    button {
      background: #818cf8;
      border: none;
      color: white;
      padding: 12px 24px;
      font-size: 16px;
      border-radius: 8px;
      cursor: pointer;
    }
    button:hover { background: #6366f1; }
  </style>
</head>
<body>
  <h1>Welcome to CodeVerse Web Preview</h1>
  <p>Live interactive HTML, CSS, and JavaScript rendering!</p>
  <button onclick="alert('Hello from CodeVerse Live Web Preview!')">Click Me!</button>
</body>
</html>
''',
    ),
    LanguageConfig(
      id: 'css',
      name: 'CSS3',
      extension: 'css',
      isWebPreviewSupported: true,
      iconAsset: '🎨',
      category: 'Web Frontend',
      starterTemplate: '''/* CodeVerse - CSS Starter */
body {
  background-color: #0f172a;
  color: #38bdf8;
  font-family: sans-serif;
}
''',
    ),
  ];

  static LanguageConfig getById(String id) {
    return supportedLanguages.firstWhere(
      (l) => l.id == id.toLowerCase(),
      orElse: () => supportedLanguages.first,
    );
  }

  static LanguageConfig getByExtension(String ext) {
    final cleanExt = ext.replaceAll('.', '').toLowerCase();
    return supportedLanguages.firstWhere(
      (l) => l.extension == cleanExt,
      orElse: () => supportedLanguages.first,
    );
  }
}
