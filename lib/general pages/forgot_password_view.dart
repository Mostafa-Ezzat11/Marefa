import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marefa/general%20pages/services/auth_service.dart';

const _green = Color(0xFF2A7A55);
const _fill = Color(0xFFF5EFE6);

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() =>
      _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  final TextEditingController _emailController =
      TextEditingController();

  bool _isLoading = false;
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetEmail() async {
    final email = _emailController.text.trim();

    if (email.isEmpty || !email.contains('@')) {
      _showMessage('Please enter a valid email address.');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await AuthService.instance.sendPasswordReset(email);

      if (!mounted) return;

      setState(() => _emailSent = true);

      _showMessage(
        'Password reset email sent successfully!',
        success: true,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      String message;

      if (e.code == 'user-not-found') {
        message = 'No account found with this email.';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email address.';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Please try again later.';
      } else {
        message = e.message ?? 'Failed to send reset email.';
      }

      _showMessage(message);
    } catch (e) {
      if (!mounted) return;
      _showMessage('Something went wrong. Please try again.');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showMessage(String message, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: success ? _green : Colors.red.shade700,
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
            vertical: 30,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),

              Text(
                'Forgot Password',
                style: GoogleFonts.lora(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 10),

              Text(
                'Enter your email address and we will send you '
                'a link to reset your password.',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),

              const SizedBox(height: 35),

              Center(
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    color: _fill,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.lock_reset_rounded,
                    size: 65,
                    color: _green,
                  ),
                ),
              ),

              const SizedBox(height: 35),

              const Text(
                'Email Address',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 10),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: _green,
                  ),
                  filled: true,
                  fillColor: _fill,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _sendResetEmail,
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
                          'Send Reset Link',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              if (_emailSent) ...[
                const SizedBox(height: 30),

                Center(
                  child: Icon(
                    Icons.mark_email_read_outlined,
                    color: _green,
                    size: 45,
                  ),
                ),

                const SizedBox(height: 12),

                Center(
                  child: Text(
                    'Check your inbox!',
                    style: GoogleFonts.lora(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'We sent a password reset link to '
                  '${_emailController.text.trim()}. '
                  'Open the email and follow the instructions '
                  'to create your new password.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 13,
                    height: 1.6,
                  ),
                ),
              ],

              const SizedBox(height: 30),

              Center(
                child: Text(
                  'Please check your spam folder if you cannot '
                  'find the email.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
