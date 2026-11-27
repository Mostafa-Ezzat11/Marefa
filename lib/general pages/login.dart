import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:marefa/general%20pages/forgot_password_view.dart';
import 'package:marefa/general%20pages/services/auth_service.dart';
import 'package:marefa/student/views/student_main_view.dart';
import 'package:marefa/teacher/views/teacher_main_view.dart';
import 'signup.dart';

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

  final AuthService _authService = AuthService.instance;

  bool _hidePass = true;
  bool _isLoading = false;

  // Remember Me
  bool _rememberMe = false;

  @override
  void dispose() {
    _user.dispose();
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
    try {
      final role = await _authService.getUserRole(uid);

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
        await _authService.logout();

        _showMessage('Account profile not found or invalid role.');
      }
    } catch (e) {
      await _authService.logout();

      _showMessage('Could not load account information.');
    }
  }

  // ================= EMAIL LOGIN =================

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final credential = await _authService.loginWithEmail(
        email: _user.text.trim(),
        password: _password.text,
      );

      final user = credential.user;

      if (user == null) {
        throw Exception('User not found.');
      }

      await user.reload();

      final refreshedUser = FirebaseAuth.instance.currentUser;

      if (refreshedUser == null) {
        throw Exception('Could not retrieve user.');
      }

      if (!refreshedUser.emailVerified) {
        await _authService.logout();

        _showMessage('Please verify your email before logging in.');

        return;
      }

      // Save Remember Me preference
      await _authService.setRememberMe(_rememberMe);

      await _navigateByRole(refreshedUser.uid);
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email address.';
          break;

        case 'user-disabled':
          message = 'This account has been disabled.';
          break;

        case 'invalid-credential':
          message = 'Incorrect email or password.';
          break;

        case 'network-request-failed':
          message = 'Please check your internet connection.';
          break;

        default:
          message = e.message ?? 'Login failed.';
      }

      _showMessage(message);
    } catch (e) {
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // ================= GOOGLE LOGIN =================

  Future<void> _googleLogin() async {
    setState(() => _isLoading = true);

    try {
      final credential = await _authService.signInWithGoogle();

      final user = credential.user;

      if (user == null) {
        throw Exception('Google account not found.');
      }

      // Save Remember Me preference
      await _authService.setRememberMe(_rememberMe);

      await _navigateByRole(user.uid);
    } on FirebaseAuthException catch (e) {
      _showMessage(e.message ?? 'Google login failed.');
    } catch (e) {
      _showMessage('Google sign-in failed: $e');
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
                  'Welcome back 👋',
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

                // EMAIL
                _Field(
                  label: 'Email',
                  hint: 'you@example.com',
                  controller: _user,
                  keyboard: TextInputType.emailAddress,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) {
                      return 'Enter your email';
                    }

                    if (!RegExp(
                      r'^[^@]+@[^@]+\.[^@]+$',
                    ).hasMatch(v.trim())) {
                      return 'Enter a valid email';
                    }

                    return null;
                  },
                ),

                // PASSWORD
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
                  validator: (v) {
                    if (v == null || v.isEmpty) {
                      return 'Enter your password';
                    }

                    return null;
                  },
                ),

                // REMEMBER ME
                Row(
                  children: [
                    SizedBox(
                      height: 35,
                      width: 35,
                      child: Checkbox(
                        value: _rememberMe,
                        activeColor: _green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        onChanged: _isLoading
                            ? null
                            : (value) {
                                setState(() {
                                  _rememberMe = value ?? false;
                                });
                              },
                      ),
                    ),

                    const SizedBox(width: 5),

                    const Text(
                      'Remember Me',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),

                // FORGOT PASSWORD
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ForgotPasswordView(),
                        ),
                      );
                    },
                    child: const Text(
                      'Forgot password?',
                      style: TextStyle(color: _green, fontSize: 13),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // LOGIN BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _login,
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

                // GOOGLE LOGIN
                _SocialButton(
                  label: 'Continue with Google',
                  icon: 'assets/images/icon-google.png',
                  onTap: _isLoading ? () {} : _googleLogin,
                ),

                const SizedBox(height: 24),

                // SIGN UP
                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SignUp(),
                        ),
                      );
                    },
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
  final String icon;

  const _SocialButton({
    required this.label,
    required this.onTap,
    required this.icon,
  });

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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(width: 10),

            Image.asset(icon, width: 26, height: 26),
          ],
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

  OutlineInputBorder _b(Color c) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: c),
    );
  }

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
