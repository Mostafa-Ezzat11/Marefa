import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marefa/general%20pages/login.dart';
import 'package:marefa/general%20pages/otpv.dart';

const _green = Color(0xFF2A7A55);
const _fill = Color(0xFFF5EFE6);
const _border = Color(0xFFE6DCCB);

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _hidePass = true;
  String _role = 'Student';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => OtpVerification(contact: _email.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 24,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Create your account',
                  style: GoogleFonts.lora(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Join Marefa and start learning',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 22),

                // ================= FIELDS =================
                _Field(
                  label: 'Full name',
                  hint: 'Ahmed Mohamed',
                  controller: _name,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Enter your name'
                      : null,
                ),
                _Field(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _email,
                  keyboard: TextInputType.emailAddress,
                  validator: (v) => v != null && v.contains('@')
                      ? null
                      : 'Enter a valid email',
                ),
                _Field(
                  label: 'Password',
                  hint: '••••••••',
                  controller: _password,
                  obscure: _hidePass,
                  suffix: IconButton(
                    icon: Icon(
                      _hidePass
                          ? Icons.visibility_off
                          : Icons.visibility,
                      size: 18,
                      color: Colors.grey,
                    ),
                    onPressed: () =>
                        setState(() => _hidePass = !_hidePass),
                  ),
                  validator: (v) => v != null && v.length >= 6
                      ? null
                      : 'At least 6 characters',
                ),

                // ================= ROLE =================
                const Text(
                  'Select role',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _RoleButton(
                        label: 'Student',
                        selected: _role == 'Student',
                        onTap: () =>
                            setState(() => _role = 'Student'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _RoleButton(
                        label: 'Instructor',
                        selected: _role == 'Instructor',
                        onTap: () =>
                            setState(() => _role = 'Instructor'),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // ================= SIGN UP =================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _submit,
                    // => Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(builder: (_) => const EditProfile()),
                    // ),//
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ================= LOGIN LINK =================
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const Login(),
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Log In',
                            style: TextStyle(
                              color: _green,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
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

// ================= ROLE BUTTON =================
class _RoleButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _RoleButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 46,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? _green : _border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? _green : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

// ================= REUSABLE FIELD =================
class _Field extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final bool obscure;
  final Widget? suffix;
  final String? Function(String?)? validator;

  const _Field({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboard,
    this.obscure = false,
    this.suffix,
    this.validator,
  });

  OutlineInputBorder _b(Color c) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: c),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            obscureText: obscure,
            validator: validator,
            style: const TextStyle(fontSize: 14),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey.shade500,
                fontSize: 14,
              ),
              suffixIcon: suffix,
              filled: true,
              fillColor: _fill,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 14,
              ),
              enabledBorder: _b(_border),
              focusedBorder: _b(_green),
              errorBorder: _b(Colors.red),
              focusedErrorBorder: _b(Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}
