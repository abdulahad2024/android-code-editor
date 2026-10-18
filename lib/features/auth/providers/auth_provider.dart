import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';
import '../../../core/storage/secure_storage_service.dart';

class AuthState {
  final User? user;
  final bool isAuthenticated;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.user,
    this.isAuthenticated = false,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    User? user,
    bool? isAuthenticated,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      user: user ?? this.user,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final SecureStorageService _secureStorage = SecureStorageService();

  AuthNotifier() : super(AuthState()) {
    checkAuth();
  }

  Future<void> checkAuth() async {
    final token = await _secureStorage.getToken();
    if (token != null && token.isNotEmpty) {
      // Demo active session
      state = state.copyWith(
        isAuthenticated: true,
        user: const User(
          id: 'user_101',
          name: 'Alex Developer',
          email: 'alex.codeverse@dev.io',
          solvedChallengesCount: 12,
          createdProjectsCount: 5,
          currentStreakDays: 4,
        ),
      );
    }
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.isNotEmpty && password.length >= 6) {
      await _secureStorage.saveToken('codeverse_demo_jwt_token_xyz');
      final user = User(
        id: 'user_101',
        name: email.split('@').first.toUpperCase(),
        email: email,
        solvedChallengesCount: 12,
        createdProjectsCount: 5,
        currentStreakDays: 4,
      );
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Invalid credentials. Password must be at least 6 characters.',
      );
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    await Future.delayed(const Duration(milliseconds: 800));

    if (name.isNotEmpty && email.contains('@') && password.length >= 6) {
      await _secureStorage.saveToken('codeverse_demo_jwt_token_xyz');
      final user = User(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        email: email,
        solvedChallengesCount: 0,
        createdProjectsCount: 0,
        currentStreakDays: 1,
      );
      state = state.copyWith(
        user: user,
        isAuthenticated: true,
        isLoading: false,
      );
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Please enter a valid name, email, and password (min 6 chars).',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await _secureStorage.deleteToken();
    state = AuthState(isAuthenticated: false);
  }
}

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier();
});
