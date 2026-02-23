import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Consistent app bar used across all screens (except Splash and Home).
/// Deep forest green background, white title/back arrow, optional action icon.
class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBackPressed;
  final Widget? actionIcon;

  const AppBarWidget({
    super.key,
    required this.title,
    this.onBackPressed,
    this.actionIcon,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppTheme.primaryColor,
      elevation: 0,
      leading: onBackPressed != null
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: onBackPressed,
            )
          : Navigator.canPop(context)
          ? IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new,
                color: Colors.white,
                size: 20,
              ),
              onPressed: () => Navigator.pop(context),
            )
          : null,
      title: Text(
        title,
        style: AppTheme.headingSmall.copyWith(
          color: Colors.white,
          fontSize: 18,
        ),
      ),
      centerTitle: true,
      actions: actionIcon != null ? [actionIcon!] : null,
    );
  }
}
