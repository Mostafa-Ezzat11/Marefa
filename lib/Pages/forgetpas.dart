import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otpv.dart';

const _green = Color(0xFF2A7A55);
const _fill = Color(0xFFF5EFE6);
const _border = Color(0xFFE6DCCB);

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final _formKey = GlobalKey<FormState>();
  final _contact = TextEditingController();

  @override
  void dispose() {
    _contact.dispose();
    super.dispose();
  }

  void _sendCode() {
    if (!_formKey.currentState!.validate()) return;
    // TODO: ابعتي كود إعادة التعيين للسيرفر هنا
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerification(contact: _contact.text.trim()),
      ),
    );
  }

  OutlineInputBorder _b(Color c) => OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: c),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black87,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ================= ICON =================
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6EBDF),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.lock_reset, color: _green, size: 30),
                ),

                const SizedBox(height: 20),

                // ================= TEXTS =================
                Text(
                  'Forgot password?',
                  style: GoogleFonts.lora(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Text(
                  "Enter your email or phone and we'll send you a code to reset your password.",
                  style: TextStyle(
                      color: Colors.grey.shade600, fontSize: 14, height: 1.4),
                ),

                const SizedBox(height: 24),

                // ================= FIELD =================
                const Text('Email or phone',
                    style:
                        TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 6),
                TextFormField(
                  controller: _contact,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Enter your email or phone'
                      : null,
                  style: const TextStyle(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'you@example.com',
                    hintStyle:
                        TextStyle(color: Colors.grey.shade500, fontSize: 14),
                    filled: true,
                    fillColor: _fill,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 14),
                    enabledBorder: _b(_border),
                    focusedBorder: _b(_green),
                    errorBorder: _b(Colors.red),
                    focusedErrorBorder: _b(Colors.red),
                  ),
                ),

                const SizedBox(height: 24),

                // ================= SEND CODE =================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _sendCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Send code',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold)),
                  ),
                ),

                const SizedBox(height: 16),

                // ================= BACK TO LOGIN =================
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Text(
                      'Back to Log In',
                      style: TextStyle(
                          color: _green,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
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