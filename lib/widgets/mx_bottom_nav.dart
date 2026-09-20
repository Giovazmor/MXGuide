import 'package:flutter/material.dart';

import '../core/theme/app_theme.dart';

/// Bottom nav del rediseño: barra en pastilla (rosa) con 4 íconos y un
/// botón (+) circular flotando arriba al centro para agregar fotos y
/// reseñas de lugares.
class MXBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onAddPressed;

  const MXBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final barColor = isDark ? AppColors.accentPlumDark : AppColors.accentPink;
    final selectedColor = isDark ? Colors.white : AppColors.ink;
    final unselectedColor = isDark ? Colors.white70 : Colors.white.withOpacity(0.8);
    final fabColor = isDark ? AppColors.primaryDark : AppColors.primary;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SizedBox(
          height: 68,
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                left: 0,
                right: 0,
                top: 14,
                bottom: 0,
                child: Container(
                  decoration: BoxDecoration(
                    color: barColor,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.18),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavIcon(
                        icon: Icons.home_rounded,
                        selected: currentIndex == 0,
                        selectedColor: selectedColor,
                        unselectedColor: unselectedColor,
                        onTap: () => onTabSelected(0),
                      ),
                      _NavIcon(
                        icon: Icons.place_rounded,
                        selected: currentIndex == 1,
                        selectedColor: selectedColor,
                        unselectedColor: unselectedColor,
                        onTap: () => onTabSelected(1),
                      ),
                      const SizedBox(width: 48),
                      _NavIcon(
                        icon: Icons.bookmark_rounded,
                        selected: currentIndex == 2,
                        selectedColor: selectedColor,
                        unselectedColor: unselectedColor,
                        onTap: () => onTabSelected(2),
                      ),
                      _NavIcon(
                        icon: Icons.person_rounded,
                        selected: currentIndex == 3,
                        selectedColor: selectedColor,
                        unselectedColor: unselectedColor,
                        onTap: () => onTabSelected(3),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                top: 0,
                child: Material(
                  color: fabColor,
                  shape: const CircleBorder(),
                  elevation: 4,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: onAddPressed,
                    child: const Padding(
                      padding: EdgeInsets.all(15),
                      child: Icon(Icons.add, color: Colors.white, size: 24),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final Color selectedColor;
  final Color unselectedColor;
  final VoidCallback onTap;

  const _NavIcon({
    required this.icon,
    required this.selected,
    required this.selectedColor,
    required this.unselectedColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      icon: Icon(icon, color: selected ? selectedColor : unselectedColor, size: 26),
    );
  }
}
