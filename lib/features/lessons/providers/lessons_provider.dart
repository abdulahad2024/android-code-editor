import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/lesson_model.dart';

class LessonsNotifier extends StateNotifier<List<Lesson>> {
  LessonsNotifier() : super(_initialLessons);

  static const List<Lesson> _initialLessons = [
    Lesson(
      id: 'lesson_py_vars',
      title: 'Python Variables & Dynamic Types',
      category: 'Language Fundamentals',
      description: 'Learn how Python handles numbers, strings, lists, and dynamic typing.',
      estimatedMinutes: 8,
      languageId: 'python',
      contentMarkdown: '''# Python Variables and Types

In Python, variables do not require explicit type declarations. The type is inferred automatically at runtime.

### Key Primitive Types:
- **int**: Whole numbers like `10`, `-5`
- **float**: Decimals like `3.14`, `0.0`
- **str**: Text sequences enclosed in single or double quotes
- **bool**: `True` or `False`

```python
x = 10
name = "CodeVerse"
is_awesome = True
print(f"Variable {name} of value {x} (Awesome: {is_awesome})")
```
''',
      sampleCode: '''x = 10
name = "CodeVerse"
is_awesome = True

print(f"Welcome to {name}!")
print(f"Value: {x}, Type: {type(x)}")
print(f"Awesome flag: {is_awesome}")
''',
    ),
    Lesson(
      id: 'lesson_py_loops',
      title: 'For & While Loops in Python',
      category: 'Control Flow',
      description: 'Master list iteration, range functions, break, and continue statements.',
      estimatedMinutes: 10,
      languageId: 'python',
      contentMarkdown: '''# Iteration in Python

Loops allow repeating blocks of code easily.

### Range Function:
`range(start, stop, step)` generates a sequence of numbers.

```python
for i in range(1, 6):
    print(f"Count: {i}")
```
''',
      sampleCode: '''# CodeVerse - Loop Demo
print("=== For Loop with Range ===")
for i in range(1, 6):
    print(f"Item #{i}")

print("\\n=== Iterating List ===")
tech_stack = ["Python", "Dart", "Java", "C++"]
for tech in tech_stack:
    print(f"Language: {tech}")
''',
    ),
    Lesson(
      id: 'lesson_java_oop',
      title: 'Java Object-Oriented Fundamentals',
      category: 'Object Oriented',
      description: 'Classes, Objects, Constructors, and Access Modifiers in Java.',
      estimatedMinutes: 12,
      languageId: 'java',
      contentMarkdown: '''# Classes and Objects in Java

Java is a strongly-typed Object-Oriented language. Everything resides inside a class.

### Key Concepts:
- **Class**: Blueprint for objects.
- **Constructor**: Special method to initialize instance fields.
- **Encapsulation**: Using `private` fields with public getters/setters.
''',
      sampleCode: '''public class Main {
    public static void main(String[] args) {
        Developer dev = new Developer("Alex", "Java");
        dev.introduce();
    }
}

class Developer {
    private String name;
    private String favoriteLanguage;

    public Developer(String name, String favoriteLanguage) {
        this.name = name;
        this.favoriteLanguage = favoriteLanguage;
    }

    public void introduce() {
        System.out.println("Hi, I am " + name + " and I code in " + favoriteLanguage + "!");
    }
}
''',
    ),
    Lesson(
      id: 'lesson_cpp_ptrs',
      title: 'C++ Pointers & Memory Allocation',
      category: 'Systems Programming',
      description: 'Understand memory addresses, raw pointers, and references.',
      estimatedMinutes: 15,
      languageId: 'cpp',
      contentMarkdown: '''# Pointers in C++

Pointers hold memory addresses of variables. The address-of operator `&` retrieves a variable's address, and the dereference operator `*` accesses the value at that address.
''',
      sampleCode: '''#include <iostream>

int main() {
    int score = 100;
    int* ptr = &score;

    std::cout << "Score value: " << score << std::endl;
    std::cout << "Score address: " << ptr << std::endl;
    std::cout << "Value via pointer: " << *ptr << std::endl;

    *ptr = 250;
    std::cout << "Updated Score value: " << score << std::endl;
    return 0;
}
''',
    ),
    Lesson(
      id: 'lesson_web_dom',
      title: 'HTML & JavaScript DOM Manipulation',
      category: 'Web Development',
      description: 'Interact with DOM elements using document.querySelector and event listeners.',
      estimatedMinutes: 10,
      languageId: 'html',
      contentMarkdown: '''# Interactive Web Pages

Combining HTML structure, CSS styling, and JavaScript logic to create dynamic user interfaces.
''',
      sampleCode: '''<!DOCTYPE html>
<html>
<head>
  <style>
    body { font-family: sans-serif; background: #0f172a; color: white; padding: 20px; }
    .box { padding: 20px; background: #1e293b; border-radius: 8px; margin-top: 10px; }
  </style>
</head>
<body>
  <h2>DOM Counter Example</h2>
  <div class="box">
    <h1 id="count">0</h1>
    <button onclick="increment()">Increment Counter</button>
  </div>
  <script>
    let val = 0;
    function increment() {
      val++;
      document.getElementById('count').innerText = val;
    }
  </script>
</body>
</html>
''',
    ),
  ];

  void toggleBookmark(String lessonId) {
    state = state.map((l) {
      if (l.id == lessonId) {
        return l.copyWith(isBookmarked: !l.isBookmarked);
      }
      return l;
    }).toList();
  }

  void toggleCompleted(String lessonId) {
    state = state.map((l) {
      if (l.id == lessonId) {
        return l.copyWith(isCompleted: !l.isCompleted);
      }
      return l;
    }).toList();
  }
}

final lessonsProvider = StateNotifierProvider<LessonsNotifier, List<Lesson>>((ref) {
  return LessonsNotifier();
});
