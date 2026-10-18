import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class AppBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AppBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onTap,
      backgroundColor: AppColors.surfaceDark,
      indicatorColor: AppColors.primaryBlue.withOpacity(0.2),
      height: 65,
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.dashboard_outlined, color: AppColors.textMutedDark),
          selectedIcon: Icon(Icons.dashboard, color: AppColors.primaryBlue),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.code_outlined, color: AppColors.textMutedDark),
          selectedIcon: Icon(Icons.code, color: AppColors.primaryBlue),
          label: 'Editor',
        ),
        NavigationDestination(
          icon: Icon(Icons.folder_open_outlined, color: AppColors.textMutedDark),
          selectedIcon: Icon(Icons.folder_open, color: AppColors.primaryBlue),
          label: 'Projects',
        ),
        NavigationDestination(
          icon: Icon(Icons.psychology_outlined, color: AppColors.textMutedDark),
          selectedIcon: Icon(Icons.psychology, color: AppColors.primaryBlue),
          label: 'Practice',
        ),
        NavigationDestination(
          icon: Icon(Icons.menu_book_outlined, color: AppColors.textMutedDark),
          selectedIcon: Icon(Icons.menu_book, color: AppColors.primaryBlue),
          label: 'Lessons',
        ),
      ],
    );
  }
}
