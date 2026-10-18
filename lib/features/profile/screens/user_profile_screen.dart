import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../auth/providers/auth_provider.dart';

class UserProfileScreen extends ConsumerWidget {
  const UserProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;

    return Scaffold(
      backgroundColor: AppColors.backgroundDark,
      appBar: AppBar(
        title: const Text('Developer Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: authState.isAuthenticated && user != null
          ? SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: AppColors.primaryBlue.withOpacity(0.2),
                    child: Text(
                      user.name.substring(0, 1).toUpperCase(),
                      style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    user.name,
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  Text(
                    user.email,
                    style: const TextStyle(fontSize: 14, color: AppColors.textSecondaryDark),
                  ),
                  const SizedBox(height: 24),

                  // Stats Row
                  Row(
                    children: [
                      Expanded(
                        child: AppCard(
                          child: Column(
                            children: [
                              Text(
                                '${user.solvedChallengesCount}',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.accentGreen),
                              ),
                              const SizedBox(height: 4),
                              const Text('Solved', style: TextStyle(fontSize: 12, color: AppColors.textMutedDark)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppCard(
                          child: Column(
                            children: [
                              Text(
                                '${user.createdProjectsCount}',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.primaryBlue),
                              ),
                              const SizedBox(height: 4),
                              const Text('Projects', style: TextStyle(fontSize: 12, color: AppColors.textMutedDark)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppCard(
                          child: Column(
                            children: [
                              Text(
                                '${user.currentStreakDays} 🔥',
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.accentAmber),
                              ),
                              const SizedBox(height: 4),
                              const Text('Day Streak', style: TextStyle(fontSize: 12, color: AppColors.textMutedDark)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),

                  AppButton(
                    label: 'Sign Out',
                    icon: Icons.logout,
                    isPrimary: false,
                    width: double.infinity,
                    color: AppColors.accentRed.withOpacity(0.2),
                    onPressed: () {
                      ref.read(authProvider.notifier).logout();
                      context.go('/auth');
                    },
                  ),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_circle_outlined, size: 64, color: AppColors.textMutedDark),
                    const SizedBox(height: 16),
                    const Text(
                      'Account Sync & Cloud Storage',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Sign in to synchronize your coding projects and practice stats across devices.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.textSecondaryDark),
                    ),
                    const SizedBox(height: 24),
                    AppButton(
                      label: 'Sign In / Create Account',
                      icon: Icons.login,
                      onPressed: () => context.push('/auth'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
