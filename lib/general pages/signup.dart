import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:marefa/general%20pages/login.dart';
import 'package:marefa/general%20pages/email_verification.dart';
import 'package:marefa/general%20pages/services/auth_service.dart';

import 'package:marefa/student/views/student_main_view.dart';
import 'package:marefa/teacher/views/teacher_main_view.dart';

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
  bool _isLoading = false;

  String _role = 'Student';

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  // ================= SHOW MESSAGE =================

  void _showMessage(String message) {
    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  // ================= NAVIGATE BY ROLE =================

  Future<void> _navigateByRole(String uid) async {
    final role = await AuthService.instance.getUserRole(uid);

    if (!mounted) return;

    if (role == 'student') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => StudentMainView()),
        (route) => false,
      );
    } else if (role == 'teacher') {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => TeacherMainView()),
        (route) => false,
      );
    } else {
      await AuthService.instance.logout();

      _showMessage('Invalid account type.');
    }
  }

  // ================= EMAIL SIGN UP =================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final credential = await AuthService.instance.signUpWithEmail(
        name: _name.text,
        email: _email.text,
        password: _password.text,
        role: _role == 'Student' ? 'student' : 'teacher',
      );

      if (!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              EmailVerification(contact: _email.text.trim()),
        ),
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'email-already-in-use':
          message = 'This email is already registered.';
          break;
        case 'weak-password':
          message = 'Password is too weak.';
          break;
        case 'invalid-email':
          message = 'Invalid email address.';
          break;
        default:
          message = e.message ?? 'Registration failed.';
      }

      _showMessage(message);
    } catch (e) {
      _showMessage('Something went wrong: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ================= GOOGLE SIGN UP =================

  Future<void> _googleSignUp() async {
    setState(() => _isLoading = true);

    try {
      final credential = await AuthService.instance.signInWithGoogle(
        role: _role == 'Student' ? 'student' : 'teacher',
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('Google account not found.');
      }

      await _navigateByRole(user.uid);
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Google registration failed.');
    } catch (e) {
      _showMessage('Google registration failed: $e');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
                  validator: (v) =>
                      v != null &&
                          RegExp(
                            r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
                          ).hasMatch(v.trim())
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
                    onPressed: () {
                      setState(() {
                        _hidePass = !_hidePass;
                      });
                    },
                  ),
                  validator: (v) => v != null && v.length >= 6
                      ? null
                      : 'At least 6 characters',
                ),

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
                        onTap: () {
                          setState(() => _role = 'Student');
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: _RoleButton(
                        label: 'Instructor',
                        selected: _role == 'Instructor',
                        onTap: () {
                          setState(() => _role = 'Instructor');
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // EMAIL SIGN UP
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _green,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(
                            color: Colors.white,
                          )
                        : const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: Text(
                    'OR',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // GOOGLE SIGN UP
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : _googleSignUp,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.black87,
                      side: const BorderSide(color: _border),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Continue with Google',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 12),

                        Image.asset(
                          'assets/images/icon-google.png',
                          height: 22,
                          width: 22,
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Login(),
                        ),
                      );
                    },
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
