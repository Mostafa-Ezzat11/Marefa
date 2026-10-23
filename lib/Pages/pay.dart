import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

const _green = Color(0xFF2A7A55);
const _greenDark = Color(0xFF1D5A3F);
const _orange = Color(0xFFE8821E);
const _orangeLight = Color(0xFFF0A04B);
const _fill = Color(0xFFF5EFE6);
const _border = Color(0xFFE6DCCB);

class _CardData {
  final String brand;
  final String last4;
  final String holder;
  final String expiry;

  const _CardData(this.brand, this.last4, this.holder, this.expiry);
}

class PaymentMethods extends StatefulWidget {
  const PaymentMethods({super.key});

  @override
  State<PaymentMethods> createState() => _PaymentMethodsState();
}

class _PaymentMethodsState extends State<PaymentMethods> {
  final List<_CardData> _cards = [
    const _CardData('Visa', '4417', 'Ahmed Mohamed', '08/28'),
    const _CardData('Mastercard', '9021', 'Ahmed Mohamed', '02/27'),
  ];

  void _openAddCard() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _AddCardSheet(
        onAdd: (card) => setState(() => _cards.add(card)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Payment methods',
          style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          children: [
            Text(
              'Cards used to buy courses',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
            ),
            const SizedBox(height: 14),

            // ================= CARDS (اسحبي يمين/شمال للحذف) =================
            for (final card in List.of(_cards))
              Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Dismissible(
                  key: ObjectKey(card),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) => setState(() => _cards.remove(card)),
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFB3363B),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(Icons.delete_outline, color: Colors.white),
                  ),
                  child: _CardTile(card: card),
                ),
              ),

            // ================= ADD CARD =================
            SizedBox(
              height: 52,
              child: OutlinedButton(
                onPressed: _openAddCard,
                style: OutlinedButton.styleFrom(
                  foregroundColor: _green,
                  side: const BorderSide(color: _green, width: 1.5),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text(
                  '+ Add new card',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

// ================= CARD TILE =================
class _CardTile extends StatelessWidget {
  final _CardData card;

  const _CardTile({required this.card});

  @override
  Widget build(BuildContext context) {
    final isVisa = card.brand == 'Visa';

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isVisa ? [_green, _greenDark] : [_orangeLight, _orange],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(card.brand,
              style: const TextStyle(color: Colors.white, fontSize: 13)),
          const SizedBox(height: 14),
          Text(
            '••••  ••••  ••••  ${card.last4}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 19,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.5,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            '${card.holder} · ${card.expiry}',
            style: const TextStyle(color: Colors.white, fontSize: 13),
          ),
        ],
      ),
    );
  }
}

// ================= ADD CARD SHEET =================
class _AddCardSheet extends StatefulWidget {
  final ValueChanged<_CardData> onAdd;

  const _AddCardSheet({required this.onAdd});

  @override
  State<_AddCardSheet> createState() => _AddCardSheetState();
}

class _AddCardSheetState extends State<_AddCardSheet> {
  final _formKey = GlobalKey<FormState>();
  final _number = TextEditingController();
  final _name = TextEditingController();
  final _expiry = TextEditingController();

  @override
  void dispose() {
    _number.dispose();
    _name.dispose();
    _expiry.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final digits = _number.text.replaceAll(' ', '');
  
    widget.onAdd(_CardData(
      digits.startsWith('4') ? 'Visa' : 'Mastercard',
      digits.substring(digits.length - 4),
      _name.text.trim(),
      _expiry.text.trim(),
    ));
    Navigator.pop(context);
  }

  OutlineInputBorder _b(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c),
      );

  InputDecoration _dec(String label) => InputDecoration(
        labelText: label,
        filled: true,
        fillColor: _fill,
        enabledBorder: _b(_border),
        focusedBorder: _b(_green),
        errorBorder: _b(Colors.red),
        focusedErrorBorder: _b(Colors.red),
      );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        20,
        20,
        20,
        MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Add new card',
                style: GoogleFonts.lora(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _number,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
                LengthLimitingTextInputFormatter(16),
              ],
              decoration: _dec('Card number'),
              validator: (v) =>
                  v != null && v.length == 16 ? null : 'Enter 16 digits',
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _name,
              textCapitalization: TextCapitalization.words,
              decoration: _dec('Name on card'),
              validator: (v) =>
                  v == null || v.trim().isEmpty ? 'Enter the name' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _expiry,
              keyboardType: TextInputType.datetime,
              decoration: _dec('Expiry (MM/YY)'),
              validator: (v) => RegExp(r'^(0[1-9]|1[0-2])/\d{2}$')
                      .hasMatch(v ?? '')
                  ? null
                  : 'Use MM/YY',
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _green,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                ),
                child: const Text('Save card',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}