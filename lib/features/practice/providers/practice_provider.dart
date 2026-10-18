import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/challenge_model.dart';

class PracticeNotifier extends StateNotifier<List<Challenge>> {
  PracticeNotifier() : super(_initialChallenges);

  static const List<Challenge> _initialChallenges = [
    Challenge(
      id: 'chal_two_sum',
      title: 'Two Sum',
      difficulty: 'Beginner',
      category: 'Data Structures & Algorithms',
      description: '''Given an array of integers `nums` and an integer `target`, return indices of the two numbers such that they add up to `target`.

You may assume that each input would have exactly one solution, and you may not use the same element twice.''',
      inputFormat: 'First line contains space-separated integers for array. Second line contains target integer.',
      outputFormat: 'Print space-separated indices of the two elements.',
      constraints: '2 <= nums.length <= 10^4\n-10^9 <= nums[i] <= 10^9',
      defaultLanguageId: 'python',
      starterCode: '''# Write your solution in Python
def two_sum(nums, target):
    # Your code here
    seen = {}
    for i, num in enumerate(nums):
        diff = target - num
        if diff in seen:
            return [seen[diff], i]
        seen[num] = i
    return []

# Read sample input
if __name__ == "__main__":
    nums = [2, 7, 11, 15]
    target = 9
    res = two_sum(nums, target)
    print(f"{res[0]} {res[1]}")
''',
      testCases: [
        TestCase(input: '2 7 11 15\n9', expectedOutput: '0 1'),
        TestCase(input: '3 2 4\n6', expectedOutput: '1 2'),
        TestCase(input: '3 3\n6', expectedOutput: '0 1', isHidden: true),
      ],
      hint: 'A hash map can store compliment target - num to achieve O(N) time complexity.',
      solutionExplanation: 'Store values in a hash dictionary. For each element num, check if (target - num) is already present in the hash map.',
    ),
    Challenge(
      id: 'chal_reverse_string',
      title: 'Reverse String',
      difficulty: 'Beginner',
      category: 'String Operations',
      description: 'Write a function that takes a string as input and outputs the reversed string.',
      inputFormat: 'A single string value.',
      outputFormat: 'The reversed string.',
      constraints: '1 <= string.length <= 10^5',
      defaultLanguageId: 'python',
      starterCode: '''# Reverse String Challenge
def reverse_string(s):
    return s[::-1]

s = "CodeVerse"
print(reverse_string(s))
''',
      testCases: [
        TestCase(input: 'CodeVerse', expectedOutput: 'esreVedoC'),
        TestCase(input: 'hello', expectedOutput: 'olleh'),
        TestCase(input: 'racecar', expectedOutput: 'racecar', isHidden: true),
      ],
      hint: 'In Python, slice notation s[::-1] reverses a string in O(N).',
      solutionExplanation: 'Use pointers or slicing to reverse character array.',
    ),
    Challenge(
      id: 'chal_fizzbuzz',
      title: 'FizzBuzz Classic',
      difficulty: 'Beginner',
      category: 'Problem Solving',
      description: '''Print numbers from 1 to N. For multiples of 3, print "Fizz". For multiples of 5, print "Buzz". For multiples of both 3 and 5, print "FizzBuzz".''',
      inputFormat: 'Single integer N.',
      outputFormat: 'N lines containing the resulting strings.',
      constraints: '1 <= N <= 100',
      defaultLanguageId: 'python',
      starterCode: '''# FizzBuzz Problem
def fizz_buzz(n):
    for i in range(1, n + 1):
        if i % 3 == 0 and i % 5 == 0:
            print("FizzBuzz")
        elif i % 3 == 0:
            print("Fizz")
        elif i % 5 == 0:
            print("Buzz")
        else:
            print(i)

fizz_buzz(15)
''',
      testCases: [
        TestCase(input: '5', expectedOutput: '1\n2\nFizz\n4\nBuzz'),
      ],
      hint: 'Check divisibility by 15 (both 3 and 5) first!',
      solutionExplanation: 'Use standard modulo operations in a loop from 1 to N.',
    ),
    Challenge(
      id: 'chal_valid_parentheses',
      title: 'Valid Parentheses',
      difficulty: 'Intermediate',
      category: 'Data Structures & Algorithms',
      description: 'Given a string containing just the characters `(`, `)`, `{`, `}`, `[` and `]`, determine if the input string is valid.',
      inputFormat: 'A string of bracket characters.',
      outputFormat: 'Print "True" or "False".',
      constraints: '1 <= s.length <= 10^4',
      defaultLanguageId: 'python',
      starterCode: '''def isValid(s):
    stack = []
    mapping = {")": "(", "}": "{", "]": "["}
    for char in s:
        if char in mapping:
            top = stack.pop() if stack else '#'
            if mapping[char] != top:
                return False
        else:
            stack.append(char)
    return not stack

print(isValid("()[]{}"))
''',
      testCases: [
        TestCase(input: '()[]{}', expectedOutput: 'True'),
        TestCase(input: '(]', expectedOutput: 'False'),
      ],
      hint: 'Use a Stack LIFO data structure to balance open and close brackets.',
      solutionExplanation: 'Push open brackets to stack, pop on close bracket match.',
    ),
  ];

  void markChallengeCompleted(String challengeId) {
    state = state.map((c) {
      if (c.id == challengeId) {
        return c.copyWith(isCompleted: true);
      }
      return c;
    }).toList();
  }
}

final practiceProvider = StateNotifierProvider<PracticeNotifier, List<Challenge>>((ref) {
  return PracticeNotifier();
});
