import 'package:flutter/material.dart';
import '../../constants.dart';
import 'app_card.dart';
import 'earnings_bar_chart.dart';
import '../models/earnings_period.dart';

class EarningsOverviewCard extends StatelessWidget {
  final List<EarningsPeriod> periods;
  final EarningsPeriod selected;
  final ValueChanged<EarningsPeriod> onPeriodChanged;

  const EarningsOverviewCard({
    super.key,
    required this.periods,
    required this.selected,
    required this.onPeriodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Earnings Overview',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.largeTextColor,
                ),
              ),
              _buildPeriodMenu(),
            ],
          ),
          const SizedBox(height: 20),
          EarningsBarChart(
            labels: selected.chartLabels,
            values: selected.chartValues,
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodMenu() {
    return PopupMenuButton<EarningsPeriod>(
      onSelected: onPeriodChanged,
      itemBuilder: (_) => periods
          .map((p) => PopupMenuItem(value: p, child: Text(p.label)))
          .toList(),
      child: Row(
        children: [
          Text(
            selected.label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          Icon(
            Icons.keyboard_arrow_down_rounded,
            size: 18,
            color: Colors.grey.shade600,
          ),
        ],
      ),
    );
  }
}
