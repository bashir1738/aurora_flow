import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_theme.dart';
import 'glass_card.dart';

class NavItem {
  const NavItem(this.icon, this.label);

  final IconData icon;
  final String label;
}

/// Floating navigation bar whose highlight morphs between destinations.
class MorphBottomNav extends StatelessWidget {
  const MorphBottomNav({
    super.key,
    required this.items,
    required this.index,
    required this.onChanged,
  });

  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 18),
      child: GlassCard(
        padding: const EdgeInsets.all(6),
        radius: 32,
        blur: 24,
        child: SizedBox(
          height: 62,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final slot = constraints.maxWidth / items.length;
              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 420),
                    curve: Curves.easeOutCubic,
                    left: index * slot + 3,
                    top: 3,
                    bottom: 3,
                    width: slot - 6,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(26),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.violet.withValues(alpha: 0.95),
                            AppColors.pink.withValues(alpha: 0.8),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.violet.withValues(alpha: 0.45),
                            blurRadius: 22,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      for (var i = 0; i < items.length; i++)
                        Expanded(
                          child: Semantics(
                            selected: i == index,
                            button: true,
                            label: items[i].label,
                            child: GestureDetector(
                              key: ValueKey('nav-${items[i].label}'),
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                HapticFeedback.selectionClick();
                                onChanged(i);
                              },
                              child: _NavButton(
                                item: items[i],
                                selected: i == index,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.item, required this.selected});

  final NavItem item;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedScale(
          scale: selected ? 1.12 : 1,
          duration: const Duration(milliseconds: 380),
          curve: Curves.easeOutBack,
          child: TweenAnimationBuilder<Color?>(
            tween: ColorTween(
              end: selected ? Colors.white : AppColors.textMuted,
            ),
            duration: const Duration(milliseconds: 320),
            builder: (context, color, _) => Icon(
              item.icon,
              size: 20,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 3),
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 320),
          style: TextStyle(
            fontSize: 9.5,
            height: 1.1,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            letterSpacing: 0.2,
            color: selected ? Colors.white : AppColors.textMuted,
          ),
          child: Text(item.label),
        ),
      ],
    );
  }
}
