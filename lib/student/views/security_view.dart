import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:marefa/general%20pages/login.dart';
import 'package:marefa/student/views/change_password_view.dart';

const _green = Color(0xff2e6b3e);
const _beige = Color(0xffd9d2c3);
const _red = Color(0xffb3363b);
const _line = Color(0xffe6dccb);

class SecurityView extends StatefulWidget {
  const SecurityView({super.key});

  @override
  State<SecurityView> createState() => _SecurityViewState();
}

class _SecurityViewState extends State<SecurityView> {
  bool twoFactor = true;
  bool biometric = true;
  bool loginAlerts = false;

  bool _isDeleting = false;

  // ================= DELETE ACCOUNT CONFIRMATION =================

  Future<void> confirmDelete() async {
    final passwordController = TextEditingController();

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        bool hidePassword = true;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFFFFFDF8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              title: const Text(
                'Delete Account',
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'This action cannot be undone. '
                    'Enter your password to confirm account deletion.',
                    textAlign: TextAlign.center,
                  ),

                  const SizedBox(height: 20),

                  TextField(
                    controller: passwordController,
                    obscureText: hidePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      filled: true,
                      fillColor: const Color(0xFFF5EFE6),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setDialogState(() {
                            hidePassword = !hidePassword;
                          });
                        },
                        icon: Icon(
                          hidePassword
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.center,
              actions: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(dialogContext, false);
                  },
                  child: const Text('Cancel'),
                ),

                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    if (passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter your password.',
                          ),
                        ),
                      );
                      return;
                    }

                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) {
      passwordController.dispose();
      return;
    }

    await _deleteAccount(passwordController.text);

    passwordController.dispose();
  }

  // ================= DELETE ACCOUNT =================

  Future<void> _deleteAccount(String password) async {
    setState(() => _isDeleting = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No user is currently logged in.');
      }

      final email = user.email;

      if (email == null) {
        throw Exception('User email not found.');
      }

      // 1. Re-authenticate user with password

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      // 2. Delete user document from Firestore

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .delete();

      // 3. Delete account from Firebase Authentication

      await user.delete();

      if (!mounted) return;

      // 4. Navigate to Login

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Login()),
        (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      String message;

      switch (e.code) {
        case 'wrong-password':
        case 'invalid-credential':
          message = 'Incorrect password. Please try again.';
          break;

        case 'requires-recent-login':
          message =
              'Please log in again before deleting your account.';
          break;

        case 'user-mismatch':
          message = 'Account verification failed.';
          break;

        case 'network-request-failed':
          message = 'Please check your internet connection.';
          break;

        default:
          message = e.message ?? 'Account deletion failed.';
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message), backgroundColor: _red),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting account: $e'),
            backgroundColor: _red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isDeleting = false);
      }
    }
  }

  // ================= SWITCH =================

  Widget _switch(bool value, ValueChanged<bool> onChanged) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: _green,
      activeThumbColor: Colors.white,
      inactiveTrackColor: _beige,
    );
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Security',
          style: GoogleFonts.lora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Protect your account',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 8),

            // ================= SETTINGS =================
            _SettingRow(
              title: 'Change password',
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ChangePasswordView(),
                  ),
                );
              },
            ),

            _SettingRow(
              title: 'Two-factor authentication',
              trailing: _switch(
                twoFactor,
                (v) => setState(() => twoFactor = v),
              ),
            ),

            _SettingRow(
              title: 'Face / fingerprint login',
              trailing: _switch(
                biometric,
                (v) => setState(() => biometric = v),
              ),
            ),

            _SettingRow(
              title: 'Login alerts',
              trailing: _switch(
                loginAlerts,
                (v) => setState(() => loginAlerts = v),
              ),
            ),

            _SettingRow(
              title: 'Active devices',
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Text('2', style: TextStyle(color: Colors.grey)),
                  Icon(Icons.chevron_right),
                ],
              ),
              onTap: () {},
            ),

            const Spacer(),

            // ================= DELETE BUTTON =================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _isDeleting ? null : confirmDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: _isDeleting
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                    : const Text(
                        'Delete Account',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
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

// ================= REUSABLE ROW =================

class _SettingRow extends StatelessWidget {
  final String title;
  final Widget trailing;
  final VoidCallback? onTap;

  const _SettingRow({
    required this.title,
    required this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: _line)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 27, 27, 27),
                ),
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}
