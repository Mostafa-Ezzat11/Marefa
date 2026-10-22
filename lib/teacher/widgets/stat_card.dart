import 'package:flutter/material.dart';

import '../../constants.dart';
import 'app_card.dart';
import 'icon_badge.dart';
import 'stat_item.dart';

class StatCard extends StatelessWidget {
  final StatItem item;

  const StatCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          IconBadge(icon: item.icon, color: item.color),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    item.value,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: AppColors.largeTextColor,
                    ),
                  ),
                ),
                Text(
                  item.label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}