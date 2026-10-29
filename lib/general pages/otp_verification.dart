import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const _green = Color(0xFF2A7A55);
const _fill = Color(0xFFF5EFE6);
const _border = Color(0xFFE6DCCB);

class OtpVerification extends StatefulWidget {
  final String contact;

  const OtpVerification({
    super.key,
    this.contact = '+20 123 456 7890',
  });

  @override
  State<OtpVerification> createState() => _OtpVerificationState();
}

class _OtpVerificationState extends State<OtpVerification> {
  static const int _length = 6;
  String _code = '';
  int _seconds = 45;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _seconds = 45);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 0) {
        t.cancel();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  void _tap(String digit) {
    if (_code.length < _length) setState(() => _code += digit);
  }

  void _back() {
    if (_code.isNotEmpty) {
      setState(() => _code = _code.substring(0, _code.length - 1));
    }
  }

  void _verify() {}

  void _resend() {
    setState(() => _code = '');
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    final canVerify = _code.length == _length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Verify your account',
                style: GoogleFonts.lora(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Enter the 6-digit code sent to ${widget.contact}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),

              // ================= CODE BOXES =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: List.generate(_length, (i) {
                  final filled = i < _code.length;
                  final active = i == _code.length;
                  return Container(
                    width: 44,
                    height: 52,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: _fill,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: active || filled ? _green : _border,
                        width: active ? 1.5 : 1,
                      ),
                    ),
                    child: Text(
                      filled ? _code[i] : '',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 14),

              // ================= RESEND =================
              Center(
                child: _seconds > 0
                    ? Text(
                        'Resend code in 00:${_seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      )
                    : GestureDetector(
                        onTap: _resend,
                        child: const Text(
                          'Resend code',
                          style: TextStyle(
                            color: _green,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
              ),

              const SizedBox(height: 20),

              // ================= VERIFY =================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: canVerify ? _verify : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _green.withValues(
                      alpha: 0.45,
                    ),
                    disabledForegroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: const Text(
                    'Verify',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const Spacer(),

              // ================= KEYPAD =================
              _Keypad(onDigit: _tap, onBack: _back),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= KEYPAD =================
class _Keypad extends StatelessWidget {
  final ValueChanged<String> onDigit;
  final VoidCallback onBack;

  const _Keypad({required this.onDigit, required this.onBack});

  @override
  Widget build(BuildContext context) {
    Widget row(List<Widget> keys) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          for (int i = 0; i < keys.length; i++) ...[
            Expanded(child: keys[i]),
            if (i < keys.length - 1) const SizedBox(width: 10),
          ],
        ],
      ),
    );

    Widget digit(String d) =>
        _Key(child: Text(d), onTap: () => onDigit(d));

    return Column(
      children: [
        row([digit('1'), digit('2'), digit('3')]),
        row([digit('4'), digit('5'), digit('6')]),
        row([digit('7'), digit('8'), digit('9')]),
        row([
          const _Key(child: SizedBox()),
          digit('0'),
          _Key(
            onTap: onBack,
            child: const Icon(Icons.backspace_outlined, size: 18),
          ),
        ]),
      ],
    );
  }
}

class _Key extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;

  const _Key({required this.child, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: _fill,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: SizedBox(
          height: 46,
          child: Center(
            child: DefaultTextStyle(
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
