import 'package:flutter/material.dart';
import 'package:marefa/constants.dart';

// Warm beige used for the switcher background.
const Color _trackColor = Color(0xFFE9E0CF);

/// Switcher: 0 = Videos, 1 = Course Files.
class ContentTabSwitcher extends StatelessWidget {
  const ContentTabSwitcher({
    super.key,
    required this.selectedIndex,
    required this.onChanged,
    required this.videoCount,
    required this.fileCount,
  });

  final int selectedIndex;
  final ValueChanged<int> onChanged;
  final int videoCount;
  final int fileCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: _trackColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _TabItem(
            icon: Icons.play_arrow_rounded,
            label: 'Videos',
            count: videoCount,
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
          _TabItem(
            icon: Icons.insert_drive_file_outlined,
            label: 'Material',
            count: fileCount,
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ],
      ),
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.icon,
    required this.label,
    required this.count,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final int count;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected
        ? Colors.white
        : AppColors.largeTextColor.withValues(alpha: 0.7);

    return Expanded(
      child: Material(
        color: selected ? AppColors.primaryColor : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 18, color: foreground),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: foreground,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white.withValues(alpha: 0.25)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: selected ? Colors.white : AppColors.largeTextColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}