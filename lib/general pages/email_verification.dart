import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:marefa/general%20pages/login.dart';

const _green = Color(0xFF2A7A55);
const _fill = Color(0xFFF5EFE6);

class EmailVerification extends StatefulWidget {
  final String contact;

  const EmailVerification({super.key, required this.contact});

  @override
  State<EmailVerification> createState() => _EmailVerificationState();
}

class _EmailVerificationState extends State<EmailVerification> {
  int _seconds = 45;
  Timer? _timer;

  bool _isVerifying = false;
  bool _isResending = false;

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

  // ================= TIMER =================

  void _startTimer() {
    _timer?.cancel();

    setState(() => _seconds = 45);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_seconds <= 1) {
        timer.cancel();

        if (mounted) {
          setState(() => _seconds = 0);
        }
      } else {
        if (mounted) {
          setState(() => _seconds--);
        }
      }
    });
  }

  // ================= VERIFY =================

  Future<void> _verify() async {
    setState(() => _isVerifying = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      await user.reload();

      final updatedUser = FirebaseAuth.instance.currentUser;

      if (updatedUser == null || !updatedUser.emailVerified) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Email is not verified yet. Please check your inbox.',
            ),
          ),
        );
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(updatedUser.uid)
          .update({'isEmailVerified': true});

      await FirebaseAuth.instance.signOut();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email verified successfully!'),
          backgroundColor: _green,
        ),
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isVerifying = false);
      }
    }
  }

  // ================= RESEND =================

  Future<void> _resend() async {
    if (_isResending || _seconds > 0) return;

    setState(() => _isResending = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No user is currently signed in.');
      }

      await user.sendEmailVerification();

      if (!mounted) return;

      _startTimer();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Verification email sent successfully!'),
          backgroundColor: _green,
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Failed to send email.')),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) {
        setState(() => _isResending = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 20),

              Text(
                'Verify your email',
                style: GoogleFonts.lora(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'We have sent a verification link to:',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                widget.contact,
                style: const TextStyle(
                  color: _green,
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Container(
                  height: 130,
                  width: 130,
                  decoration: BoxDecoration(
                    color: _fill,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.mark_email_read_outlined,
                    size: 65,
                    color: _green,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              Center(
                child: Text(
                  'Check your inbox',
                  style: GoogleFonts.lora(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              Center(
                child: Text(
                  'Open the email from Marefa and tap the '
                  'verification link to activate your account.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isVerifying ? null : _verify,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _green,
                    foregroundColor: Colors.white,
                    disabledBackgroundColor: _green.withValues(
                      alpha: 0.45,
                    ),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isVerifying
                      ? const CircularProgressIndicator(
                          color: Colors.white,
                        )
                      : const Text(
                          'I have verified my email',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 20),

              Center(
                child: _seconds > 0
                    ? Text(
                        'Resend email in 00:${_seconds.toString().padLeft(2, '0')}',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 13,
                        ),
                      )
                    : TextButton(
                        onPressed: _isResending ? null : _resend,
                        child: _isResending
                            ? const CircularProgressIndicator(
                                color: _green,
                              )
                            : const Text(
                                'Resend verification email',
                                style: TextStyle(
                                  color: _green,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                      ),
              ),

              const Spacer(),

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
