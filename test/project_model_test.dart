import 'package:flutter_test/flutter_test.dart';
import 'package:android_code_editor/features/editor/models/project_model.dart';
import 'package:android_code_editor/features/editor/models/source_file.dart';

void main() {
  group('Project and SourceFile Model Tests', () {
    test('SourceFile serialization and copyWith works correctly', () {
      final file = SourceFile(
        name: 'main.py',
        content: 'print("Hello")',
        languageId: 'python',
      );

      expect(file.name, 'main.py');
      expect(file.isUnsaved, false);

      final updated = file.copyWith(content: 'print("World")', isUnsaved: true);
      expect(updated.content, 'print("World")');
      expect(updated.isUnsaved, true);

      final json = file.toJson();
      final restored = SourceFile.fromJson(json);

      expect(restored.name, file.name);
      expect(restored.content, file.content);
      expect(restored.languageId, file.languageId);
    });

    test('Project creation and file management works', () {
      final file1 = SourceFile(name: 'index.py', content: 'x = 10', languageId: 'python');
      final project = Project(
        name: 'Test Project',
        primaryLanguageId: 'python',
        files: [file1],
      );

      expect(project.files.length, 1);
      expect(project.files.first.name, 'index.py');

      final json = project.toJson();
      final restored = Project.fromJson(json);

      expect(restored.name, project.name);
      expect(restored.primaryLanguageId, project.primaryLanguageId);
      expect(restored.files.length, 1);
    });
  });
}
