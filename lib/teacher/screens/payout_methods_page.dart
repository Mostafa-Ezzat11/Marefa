import 'package:flutter/material.dart';

import '../../constants.dart';
import '../widgets/app_card.dart';
import '../widgets/primary_button.dart';

class PayoutMethodsPage extends StatefulWidget {
  const PayoutMethodsPage({super.key, this.availableBalance = 360});

  final double availableBalance;

  @override
  State<PayoutMethodsPage> createState() => _PayoutMethodsPageState();
}

class _PayoutMethod {
  const _PayoutMethod({
    required this.name,
    required this.details,
    required this.icon,
  });

  final String name;
  final String details;
  final IconData icon;
}

class _PayoutMethodsPageState extends State<PayoutMethodsPage> {
  final List<_PayoutMethod> _methods = [
    const _PayoutMethod(
      name: 'Vodafone Cash',
      details: '010 •••• 4821',
      icon: Icons.phone_android_rounded,
    ),
    const _PayoutMethod(
      name: 'Visa',
      details: '•••• •••• •••• 3094',
      icon: Icons.credit_card_rounded,
    ),
  ];

  int _selectedIndex = 0;

  Future<void> _addMethod() async {
    final formKey = GlobalKey<FormState>();
    final accountController = TextEditingController();
    final nameController = TextEditingController();
    String type = 'Vodafone Cash';

    final method = await showModalBottomSheet<_PayoutMethod>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
      builder: (sheetContext) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            8,
            20,
            20 + MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Add payout method',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: type,
                  decoration: const InputDecoration(
                    labelText: 'Payment method',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Vodafone Cash',
                      child: Text('Vodafone Cash'),
                    ),
                    DropdownMenuItem(
                      value: 'Visa',
                      child: Text('Visa / Mastercard'),
                    ),
                    DropdownMenuItem(
                      value: 'Bank account',
                      child: Text('Bank account'),
                    ),
                  ],
                  onChanged: (value) {
                    if (value != null)
                      setSheetState(() => type = value);
                  },
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Account holder name',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().isEmpty
                      ? 'Enter the account holder name'
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: accountController,
                  keyboardType: type == 'Vodafone Cash'
                      ? TextInputType.phone
                      : TextInputType.text,
                  decoration: InputDecoration(
                    labelText: switch (type) {
                      'Vodafone Cash' => 'Wallet number',
                      'Visa' => 'Card number',
                      _ => 'Account number or IBAN',
                    },
                    border: const OutlineInputBorder(),
                  ),
                  validator: (value) =>
                      value == null || value.trim().length < 6
                      ? 'Enter valid account details'
                      : null,
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  text: 'Save payout method',
                  icon: Icons.add_card_rounded,
                  onPressed: () {
                    if (!formKey.currentState!.validate()) return;
                    final rawDetails = accountController.text.trim();
                    final isWallet = type == 'Vodafone Cash';
                    final maskedDetails = isWallet
                        ? _maskPhone(rawDetails)
                        : '•••• ${rawDetails.substring(rawDetails.length - 4)}';
                    Navigator.pop(
                      sheetContext,
                      _PayoutMethod(
                        name: type,
                        details:
                            '${nameController.text.trim()} • $maskedDetails',
                        icon: switch (type) {
                          'Vodafone Cash' =>
                            Icons.phone_android_rounded,
                          'Visa' => Icons.credit_card_rounded,
                          _ => Icons.account_balance_rounded,
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );

    accountController.dispose();
    nameController.dispose();
    if (method == null || !mounted) return;
    setState(() {
      _methods.add(method);
      _selectedIndex = _methods.length - 1;
    });
  }

  String _maskPhone(String phone) {
    if (phone.length <= 4) return phone;
    return '${phone.substring(0, 3)} •••• ${phone.substring(phone.length - 4)}';
  }

  void _requestPayout() {
    if (_methods.isEmpty) return;
    final method = _methods[_selectedIndex];
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        icon: Icon(
          Icons.check_circle_outline_rounded,
          color: AppColors.primaryColor,
          size: 36,
        ),
        title: const Text('Confirm withdrawal request'),
        content: Text(
          'We will send EGP ${widget.availableBalance.toStringAsFixed(2)} to ${method.name} (${method.details}).',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Back'),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    'Your withdrawal request has been submitted',
                  ),
                ),
              );
            },
            child: const Text('Confirm'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        title: const Text('Withdraw earnings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          AppCard(
            padding: EdgeInsets.zero,
            child: Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.primaryColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Available balance',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'EGP ${widget.availableBalance.toStringAsFixed(2)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Choose a payout method',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: _addMethod,
                icon: const Icon(Icons.add),
                label: const Text('Add new'),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ...List.generate(_methods.length, (index) {
            final method = _methods[index];
            final selected = index == _selectedIndex;
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => setState(() => _selectedIndex = index),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      width: 1.5,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(2),
                    child: AppCard(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          Icon(
                            method.icon,
                            color: AppColors.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  method.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.largeTextColor,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  method.details,
                                  style: TextStyle(
                                    color: AppColors.subTextColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            selected
                                ? Icons.radio_button_checked
                                : Icons.radio_button_off,
                            color: selected
                                ? AppColors.primaryColor
                                : AppColors.subTextColor,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
          const SizedBox(height: 20),
          PrimaryButton(
            text: 'Confirm withdrawal',
            icon: Icons.payments_rounded,
            onPressed: _requestPayout,
          ),
          const SizedBox(height: 12),
          Text(
            'Please make sure your payout details are correct before confirming.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.subTextColor,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
