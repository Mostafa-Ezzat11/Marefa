import 'package:flutter/material.dart';
import '../models/stat_item.dart';
import 'stat_card.dart';

/// 2-column grid of [StatCard]s. Used in Home and Earnings pages.
class StatsGrid extends StatelessWidget {
  final List<StatItem> items;

  const StatsGrid({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 78,
      ),
      itemBuilder: (_, index) => StatCard(item: items[index]),
    );
  }
}
