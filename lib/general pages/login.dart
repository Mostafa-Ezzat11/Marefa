import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup.dart';
import 'forgetpas.dart';

const _green = Color(0xFF2A7A55);
const _fill = Color(0xFFF5EFE6);
const _border = Color(0xFFE6DCCB);

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final _user = TextEditingController();
  final _password = TextEditingController();
  bool _hidePass = true;

  @override
  void dispose() {
    _user.dispose();
    _password.dispose();
    super.dispose();
  }

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    // Navigator.pushAndRemoveUntil(context,
    //   MaterialPageRoute(builder: (_) => const MyProfileScreen()), (r) => false);
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
                  'Welcome back',
                  style: GoogleFonts.lora(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Log in to your account',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 22),

                // ================= FIELDS =================
                _Field(
                  label: 'Email or phone',
                  hint: 'you@example.com',
                  controller: _user,
                  keyboard: TextInputType.emailAddress,
                  validator: (v) => v == null || v.trim().isEmpty
                      ? 'Enter your email or phone'
                      : null,
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
                  validator: (v) => v == null || v.isEmpty
                      ? 'Enter your password'
                      : null,
                ),

                // ================= FORGOT =================
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const ForgotPassword(),
                      ),
                    ),
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: _green, fontSize: 13),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // ================= LOG IN =================
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Log In',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),
                Center(
                  child: Text(
                    'or',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),
                const SizedBox(height: 14),

                // ================= SOCIAL =================
                _SocialButton(
                  label: 'Continue with Google',
                  onTap: () {}, // TODO: Google sign-in
                ),
                const SizedBox(height: 12),
                _SocialButton(
                  label: 'Continue with Apple',
                  onTap: () {}, // TODO: Apple sign-in
                ),

                const SizedBox(height: 24),

                // ================= SIGN UP LINK =================
                Center(
                  child: GestureDetector(
                    onTap: () => Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SignUp(),
                      ),
                    ),
                    child: Text.rich(
                      TextSpan(
                        text: 'New here? ',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                        children: const [
                          TextSpan(
                            text: 'Sign Up',
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

// ================= SOCIAL BUTTON =================
class _SocialButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SocialButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          side: const BorderSide(color: _border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
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
      padding: const EdgeInsets.only(bottom: 10),
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
