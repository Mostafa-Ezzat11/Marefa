import 'package:flutter/material.dart';
import '../../constants.dart';
import '../widgets/app_card.dart';
import '../widgets/earnings_overview_card.dart';
import '../widgets/earnings_period.dart';
import '../widgets/stat_item.dart';
import '../widgets/stats_grid.dart';
import '../widgets/primary_button.dart';
import 'payout_methods_page.dart';

class EarningsPage extends StatefulWidget {
  const EarningsPage({super.key});

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  // Replace with real data from your API / state management.
  static const _stats = [
    StatItem(
      icon: Icons.account_balance_wallet_rounded,
      color: AppColors.primaryColor,
      value: 'EGP 2,480',
      label: 'Total Earnings',
    ),
    StatItem(
      icon: Icons.calendar_month_rounded,
      color: AppColors.blue,
      value: 'EGP 680',
      label: 'This Month',
    ),
    StatItem(
      icon: Icons.hourglass_bottom_rounded,
      color: AppColors.orangeColor,
      value: 'EGP 320',
      label: 'Pending Payouts',
    ),
    StatItem(
      icon: Icons.shopping_bag_rounded,
      color: AppColors.primaryColor,
      value: '52',
      label: 'Total Sales',
    ),
  ];

  static const _periods = [
    EarningsPeriod(
      label: 'Last 7 days',
      chartLabels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'],
      chartValues: [120, 210, 150, 260, 190, 340, 280],
    ),
    EarningsPeriod(
      label: 'Last 30 days',
      chartLabels: [
        '1', '3', '6', '9', '12', '15', '18', '21', '24', '27', '30'
      ],
      chartValues: [90, 210, 130, 110, 200, 170, 260, 230, 150, 240, 380],
    ),
  ];

  late EarningsPeriod _selectedPeriod = _periods[1];

  void _openPayoutMethods() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const PayoutMethodsPage(availableBalance: 360),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(),
              const SizedBox(height: 16),
              const StatsGrid(items: _stats),
              const SizedBox(height: 20),
              AppCard(
                padding: const EdgeInsets.all(18),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Text('Available to Withdraw', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.primaryColor)),
                  const SizedBox(height: 4),
                  const Text('EGP 360.00', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: AppColors.largeTextColor)),
                  const SizedBox(height: 16),
                  PrimaryButton(
                    text: 'Request Payout',
                    icon: Icons.north_east_rounded,
                    onPressed: _openPayoutMethods,
                  ),
                ]),
              ),
              const SizedBox(height: 20),
              EarningsOverviewCard(
                periods: _periods,
                selected: _selectedPeriod,
                onPeriodChanged: (p) => setState(() => _selectedPeriod = p),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        const Text(
          'Sales Overview',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: AppColors.largeTextColor,
          ),
        ),
        const Spacer(),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.more_vert_rounded,
              color: AppColors.largeTextColor),
        ),
      ],
    );
  }
}
