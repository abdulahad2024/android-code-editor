import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/storage/local_storage_service.dart';
import '../../settings/providers/settings_provider.dart';
import '../models/snippet_model.dart';

class SnippetsNotifier extends StateNotifier<List<Snippet>> {
  final LocalStorageService? _storage;

  SnippetsNotifier(this._storage) : super([]) {
    _loadSnippets();
  }

  void _loadSnippets() {
    if (_storage != null) {
      final jsonList = _storage!.getJsonList(AppConstants.keySnippets);
      if (jsonList != null && jsonList.isNotEmpty) {
        state = jsonList
            .map((e) => Snippet.fromJson(e as Map<String, dynamic>))
            .toList();
        return;
      }
    }

    state = [
      Snippet(
        id: 'snip_1',
        title: 'Python Binary Search Template',
        languageId: 'python',
        tags: 'algorithm, search, python',
        code: '''def binary_search(arr, target):
    low, high = 0, len(arr) - 1
    while low <= high:
        mid = (low + high) // 2
        if arr[mid] == target: return mid
        elif arr[mid] < target: low = mid + 1
        else: high = mid - 1
    return -1''',
      ),
      Snippet(
        id: 'snip_2',
        title: 'Fast I/O Java Scanner Template',
        languageId: 'java',
        tags: 'java, input, Competitive Programming',
        code: '''import java.io.*;
import java.util.*;

public class Solution {
    public static void main(String[] args) throws IOException {
        BufferedReader br = new BufferedReader(new InputStreamReader(System.in));
        StringTokenizer st = new StringTokenizer(br.readLine());
        int n = Integer.parseInt(st.nextToken());
        System.out.println("Read N: " + n);
    }
}''',
      ),
      Snippet(
        id: 'snip_3',
        title: 'C++ Fast Read Template',
        languageId: 'cpp',
        tags: 'cpp, i/o, template',
        code: '''#include <iostream>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    cout << "Fast I/O Ready\\n";
    return 0;
}''',
      ),
    ];
    _saveSnippets();
  }

  void _saveSnippets() {
    if (_storage != null) {
      _storage!.setJsonList(
        AppConstants.keySnippets,
        state.map((s) => s.toJson()).toList(),
      );
    }
  }

  void addSnippet({
    required String title,
    required String code,
    required String languageId,
    String tags = '',
  }) {
    final snippet = Snippet(
      title: title,
      code: code,
      languageId: languageId,
      tags: tags,
    );
    state = [snippet, ...state];
    _saveSnippets();
  }

  void deleteSnippet(String id) {
    state = state.where((s) => s.id != id).toList();
    _saveSnippets();
  }
}

final snippetsProvider = StateNotifierProvider<SnippetsNotifier, List<Snippet>>((ref) {
  final storageAsync = ref.watch(localStorageProvider);
  final storage = storageAsync.asData?.value;
  return SnippetsNotifier(storage);
});
