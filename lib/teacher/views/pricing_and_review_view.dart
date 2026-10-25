import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:marefa/constants.dart';
import 'package:marefa/teacher/widgets/course_action_button.dart';
import 'package:marefa/teacher/widgets/course_step_indicator.dart';
import 'package:marefa/teacher/widgets/save_draft_button.dart';
import 'package:marefa/teacher/views/course_submition_review_view.dart';

enum PriceType { paid, free }

class PricingReviewview extends StatefulWidget {
  const PricingReviewview({super.key});

  @override
  State<PricingReviewview> createState() => _PricingReviewviewstate();
}

class _PricingReviewviewstate extends State<PricingReviewview> {
  final _formKey = GlobalKey<FormState>();
  final _priceController = TextEditingController();

  PriceType _priceType = PriceType.paid;
  bool _agreedToTerms = false;

  bool get _isFree => _priceType == PriceType.free;

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  void _onPriceTypeChanged(PriceType type) {
    setState(() {
      _priceType = type;
      if (type == PriceType.free) {
        _priceController.clear();
        FocusScope.of(context).unfocus();
      }
    });
  }

  void _onSubmit() {
    if (!_formKey.currentState!.validate()) return;

    //final price = _isFree ? 0.0 : double.parse(_priceController.text);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => SubmittedReviewview()),
    );
  }

  // void _onSaveDraft() {
  //   final price = _isFree ? 0.0 : double.tryParse(_priceController.text);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.backgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: AppColors.largeTextColor,
        ),
        titleTextStyle: const TextStyle(
          color: AppColors.largeTextColor,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Pricing & review',
          style: TextStyle(
            color: AppColors.largeTextColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: CourseStepIndicator(currentStep: 2),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    const _PricingHeader(),
                    const SizedBox(height: 30),

                    _PriceTypeSelector(
                      selected: _priceType,
                      onChanged: _onPriceTypeChanged,
                    ),
                    const SizedBox(height: 20),
                    _PriceField(
                      controller: _priceController,
                      enabled: !_isFree,
                    ),
                    const SizedBox(height: 270),

                    _TermsCheckbox(
                      value: _agreedToTerms,
                      onChanged: (v) =>
                          setState(() => _agreedToTerms = v ?? false),
                    ),
                  ],
                ),
              ),
              _BottomActions(
                canSubmit: _agreedToTerms,
                onSubmit: _onSubmit,
                // onSaveDraft: _onSaveDraft,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Header
class _PricingHeader extends StatelessWidget {
  const _PricingHeader();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ready to share your knowledge?',
          style: textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.largeTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Set a fair price, check the details, and send your updates for review.',
          style: textTheme.bodySmall?.copyWith(
            color: AppColors.largeTextColor.withOpacity(0.65),
          ),
        ),
      ],
    );
  }
}

// Price type option: Paid / Free
class _PriceTypeSelector extends StatelessWidget {
  const _PriceTypeSelector({
    required this.selected,
    required this.onChanged,
  });

  final PriceType selected;
  final ValueChanged<PriceType> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<PriceType>(
      segments: const [
        ButtonSegment(
          value: PriceType.paid,
          label: Text('Add price'),
          icon: Icon(Icons.attach_money),
        ),
        ButtonSegment(
          value: PriceType.free,
          label: Text('Free'),
          icon: Icon(Icons.card_giftcard),
        ),
      ],
      selected: {selected},
      showSelectedIcon: false,
      onSelectionChanged: (set) => onChanged(set.first),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? AppColors.primaryColor
              : Colors.white,
        ),
        foregroundColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? Colors.white
              : AppColors.largeTextColor,
        ),
        side: const WidgetStatePropertyAll(
          BorderSide(color: AppColors.borderColor),
        ),
      ),
    );
  }
}

// Price text field (LE currency on the side)
class _PriceField extends StatelessWidget {
  const _PriceField({
    required this.controller,
    required this.enabled,
  });

  final TextEditingController controller;
  final bool enabled;

  String? _validate(String? value) {
    if (!enabled) return null;
    if (value == null || value.trim().isEmpty) return 'Enter a price';
    final price = double.tryParse(value);
    if (price == null || price <= 0) return 'Enter a valid price';
    return null;
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Course price',
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: AppColors.largeTextColor,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          enabled: enabled,
          cursorColor: AppColors.primaryColor,
          style: const TextStyle(color: AppColors.largeTextColor),
          keyboardType: const TextInputType.numberWithOptions(
            decimal: true,
          ),
          inputFormatters: [
            FilteringTextInputFormatter.allow(
              RegExp(r'^\d*\.?\d{0,2}'),
            ),
          ],
          validator: _validate,
          decoration: InputDecoration(
            filled: true,
            fillColor: enabled
                ? Colors.white
                : AppColors.borderColor.withOpacity(0.6),
            hintText: enabled ? '0.00' : 'Free',
            suffixText: 'LE',
            suffixStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.primaryColor,
            ),
            border: _border(AppColors.borderColor),
            enabledBorder: _border(AppColors.borderColor),
            disabledBorder: _border(AppColors.borderColor),
            focusedBorder: _border(
              AppColors.primaryColor,
              width: 1.5,
            ),
            errorBorder: _border(
              const Color.fromARGB(255, 218, 25, 7),
            ),
            focusedErrorBorder: _border(
              const Color.fromARGB(255, 218, 25, 7),
              width: 1.5,
            ),
            errorStyle: const TextStyle(
              color: Color.fromARGB(255, 218, 25, 7),
            ),
          ),
        ),
      ],
    );
  }
}

// Terms checkbox
class _TermsCheckbox extends StatelessWidget {
  const _TermsCheckbox({
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      activeColor: AppColors.primaryColor,
      checkColor: Colors.white,
      side: const BorderSide(
        color: AppColors.primaryDarkColor,
        width: 1.5,
      ),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.leading,
      title: Text(
        "I own the rights to this content and agree to Marefa's teaching standards.",
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: AppColors.largeTextColor,
        ),
      ),
    );
  }
}

// Bottom buttons
class _BottomActions extends StatelessWidget {
  const _BottomActions({
    required this.canSubmit,
    required this.onSubmit,
    //required this.onSaveDraft,
  });

  final bool canSubmit;
  final VoidCallback onSubmit;
  //final VoidCallback onSaveDraft;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CourseActionButton(
            text: 'Submit updates for review',
            icon: Icons.arrow_forward,
            onPressed: canSubmit
                ? onSubmit
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('You must agree to the terms.'),
                      ),
                    );
                  },
          ),
          const SizedBox(height: 8),
          SaveDraftButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Draft will be added soon.'),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
