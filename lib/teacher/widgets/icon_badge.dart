import 'package:flutter/material.dart';

/// Rounded tinted square/circle holding an icon.
class IconBadge extends StatelessWidget {
  final IconData icon;
  final Color color;
  final double size;
  final bool circular;

  const IconBadge({
    super.key,
    required this.icon,
    required this.color,
    this.size = 44,
    this.circular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        shape: circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circular ? null : BorderRadius.circular(12),
      ),
      child: Icon(icon, color: color, size: size * 0.5),
    );
  }
}
