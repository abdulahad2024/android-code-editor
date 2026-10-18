import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../editor/models/project_model.dart';
import '../../editor/models/source_file.dart';
import '../../languages/models/language_config.dart';
import '../../settings/providers/settings_provider.dart';

class ProjectsNotifier extends StateNotifier<List<Project>> {
  final LocalStorageService? _storage;

  ProjectsNotifier(this._storage) : super([]) {
    _loadProjects();
  }

  void _loadProjects() {
    if (_storage != null) {
      final listJson = _storage!.getJsonList(AppConstants.keyProjects);
      if (listJson != null && listJson.isNotEmpty) {
        state = listJson
            .map((e) => Project.fromJson(e as Map<String, dynamic>))
            .toList();
        return;
      }
    }

    // Default sample starter projects for immediate local practice
    state = [
      Project(
        id: 'proj_python_starter',
        name: 'Python Data Structures',
        description: 'Practice arrays, dictionaries, and search algorithms in Python.',
        primaryLanguageId: 'python',
        isFavorite: true,
        files: [
          SourceFile(
            id: 'file_py_main',
            name: 'main.py',
            languageId: 'python',
            content: '''# Python Data Structures Practice
def binary_search(arr, target):
    low = 0
    high = len(arr) - 1
    
    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == target:
            return mid
        elif arr[mid] < target:
            low = mid + 1
        else:
            high = mid - 1
    return -1

numbers = [2, 5, 8, 12, 16, 23, 38, 56, 72, 91]
target = 23
result = binary_search(numbers, target)

print(f"Array: {numbers}")
print(f"Target {target} found at index: {result}")
''',
          ),
          SourceFile(
            id: 'file_py_utils',
            name: 'helpers.py',
            languageId: 'python',
            content: '''def print_banner(title):
    print("=" * 40)
    print(title.center(40))
    print("=" * 40)
''',
          ),
        ],
      ),
      Project(
        id: 'proj_web_landing',
        name: 'Interactive Web Page',
        description: 'Live HTML, CSS, and JavaScript interactive playground.',
        primaryLanguageId: 'html',
        isFavorite: false,
        files: [
          SourceFile(
            id: 'file_html_index',
            name: 'index.html',
            languageId: 'html',
            content: '''<!DOCTYPE html>
<html>
<head>
  <style>
    body {
      background-color: #0f172a;
      color: #38bdf8;
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
      display: flex;
      flex-direction: column;
      align-items: center;
      justify-content: center;
      min-height: 100vh;
      margin: 0;
    }
    .card {
      background: #1e293b;
      padding: 30px;
      border-radius: 16px;
      border: 1px solid #334155;
      box-shadow: 0 10px 25px rgba(0,0,0,0.5);
      text-align: center;
    }
    button {
      background: #38bdf8;
      color: #0f172a;
      border: none;
      padding: 12px 24px;
      font-weight: bold;
      border-radius: 8px;
      cursor: pointer;
    }
  </style>
</head>
<body>
  <div class="card">
    <h1>CodeVerse Web Sandbox</h1>
    <p>Live previewing HTML, CSS, and JS right on your device!</p>
    <button onclick="changeColor()">Click Me</button>
  </div>
  <script>
    function changeColor() {
      document.querySelector('h1').style.color = '#4ade80';
      alert('Color updated successfully!');
    }
  </script>
</body>
</html>
''',
          ),
        ],
      ),
      Project(
        id: 'proj_java_algorithms',
        name: 'Java Sorting Algorithms',
        description: 'Bubble sort, quick sort, and merge sort benchmarks.',
        primaryLanguageId: 'java',
        isFavorite: false,
        files: [
          SourceFile(
            id: 'file_java_main',
            name: 'Main.java',
            languageId: 'java',
            content: '''public class Main {
    public static void main(String[] args) {
        int[] arr = {64, 34, 25, 12, 22, 11, 90};
        System.out.println("Original array:");
        printArray(arr);
        
        bubbleSort(arr);
        
        System.out.println("\\nSorted array:");
        printArray(arr);
    }

    static void bubbleSort(int[] arr) {
        int n = arr.length;
        for (int i = 0; i < n - 1; i++) {
            for (int j = 0; j < n - i - 1; j++) {
                if (arr[j] > arr[j + 1]) {
                    int temp = arr[j];
                    arr[j] = arr[j + 1];
                    arr[j + 1] = temp;
                }
            }
        }
    }

    static void printArray(int[] arr) {
        for (int val : arr) {
            System.out.print(val + " ");
        }
        System.out.println();
    }
}
''',
          ),
        ],
      ),
    ];
    _saveProjects();
  }

  void _saveProjects() {
    if (_storage != null) {
      _storage!.setJsonList(
        AppConstants.keyProjects,
        state.map((p) => p.toJson()).toList(),
      );
    }
  }

  Project createProject({
    required String name,
    required String description,
    required String languageId,
  }) {
    final lang = LanguageConfig.getById(languageId);
    final initialFile = SourceFile(
      name: 'main.${lang.extension}',
      content: lang.starterTemplate,
      languageId: lang.id,
    );

    final project = Project(
      name: name,
      description: description,
      primaryLanguageId: lang.id,
      files: [initialFile],
    );

    state = [project, ...state];
    _saveProjects();
    return project;
  }

  void toggleFavorite(String projectId) {
    state = state.map((p) {
      if (p.id == projectId) {
        return p.copyWith(isFavorite: !p.isFavorite);
      }
      return p;
    }).toList();
    _saveProjects();
  }

  void deleteProject(String projectId) {
    state = state.where((p) => p.id != projectId).toList();
    _saveProjects();
  }

  void updateProject(Project updatedProject) {
    state = state.map((p) => p.id == updatedProject.id ? updatedProject : p).toList();
    _saveProjects();
  }

  Project? getById(String id) {
    try {
      return state.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }
}

final projectsProvider = StateNotifierProvider<ProjectsNotifier, List<Project>>((ref) {
  final storageAsync = ref.watch(localStorageProvider);
  final storage = storageAsync.asData?.value;
  return ProjectsNotifier(storage);
});
