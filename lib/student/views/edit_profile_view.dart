import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const _green = Color(0xFF2A7A55);
const _orange = Color(0xFFE8821E);
const _fill = Color(0xFFF5EFE6);
const _border = Color(0xFFE6DCCB);

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  final _formKey = GlobalKey<FormState>();

  final _name = TextEditingController();
  final _email = TextEditingController();
  final _phone = TextEditingController();
  final _bio = TextEditingController();

  bool _isLoading = true;
  bool _isSaving = false;

  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    _bio.dispose();
    super.dispose();
  }

  // ================= LOAD PROFILE =================

  Future<void> _loadProfile() async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No user is currently logged in.');
      }

      final document = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (!document.exists) {
        throw Exception('User profile not found.');
      }

      final data = document.data()!;

      if (!mounted) return;

      setState(() {
        _name.text = data['fullName'] ?? user.displayName ?? '';
        _email.text = data['email'] ?? user.email ?? '';
        _phone.text = data['phoneNumber'] ?? '';
        _bio.text = data['bio'] ?? '';
        _photoUrl = data['photoUrl'] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not load profile: $e')),
      );
    }
  }

  // ================= SAVE PROFILE =================

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('No user is currently logged in.');
      }

      final updatedName = _name.text.trim();

      // Update Firebase Authentication display name
      await user.updateDisplayName(updatedName);

      // Update Firestore profile
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
            'fullName': updatedName,
            'phoneNumber': _phone.text.trim(),
            'bio': _bio.text.trim(),
            'updatedAt': FieldValue.serverTimestamp(),
          });

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: _green,
        ),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  // ================= BUILD =================

  @override
  Widget build(BuildContext context) {
    final letter = _name.text.trim().isEmpty
        ? '?'
        : _name.text.trim()[0].toUpperCase();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Edit profile',
          style: GoogleFonts.lora(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: _green),
            )
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // ================= AVATAR =================
                      Center(
                        child: Stack(
                          clipBehavior: Clip.none,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: _green,
                              backgroundImage: _photoUrl.isNotEmpty
                                  ? NetworkImage(_photoUrl)
                                  : null,
                              child: _photoUrl.isEmpty
                                  ? Text(
                                      letter,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 34,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: -2,
                              bottom: 0,
                              child: Container(
                                width: 28,
                                height: 28,
                                decoration: BoxDecoration(
                                  color: _orange,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.white,
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // ================= FIELDS =================
                      _Field(
                        label: 'Full name',
                        controller: _name,
                        onChanged: (_) => setState(() {}),
                        validator: (v) =>
                            v == null || v.trim().isEmpty
                            ? 'Enter your name'
                            : null,
                      ),

                      _Field(
                        label: 'Email',
                        controller: _email,
                        keyboard: TextInputType.emailAddress,
                        readOnly: true,
                      ),

                      _Field(
                        label: 'Phone',
                        controller: _phone,
                        keyboard: TextInputType.phone,
                      ),

                      _Field(
                        label: 'Bio',
                        controller: _bio,
                        lines: 3,
                      ),

                      const SizedBox(height: 24),

                      // ================= SAVE =================
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: _isSaving ? null : _save,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _green,
                            foregroundColor: Colors.white,
                            disabledBackgroundColor: _green
                                .withValues(alpha: 0.5),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          child: _isSaving
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  'Save changes',
                                  style: GoogleFonts.lora(
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
              ),
            ),
    );
  }
}

// ================= REUSABLE FIELD =================

class _Field extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType? keyboard;
  final int lines;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  const _Field({
    required this.label,
    required this.controller,
    this.keyboard,
    this.lines = 1,
    this.validator,
    this.onChanged,
    this.readOnly = false,
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
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          TextFormField(
            controller: controller,
            keyboardType: keyboard,
            minLines: lines,
            maxLines: lines,
            validator: validator,
            onChanged: onChanged,
            readOnly: readOnly,
            style: TextStyle(
              fontSize: 14,
              color: readOnly ? Colors.grey.shade600 : Colors.black87,
            ),
            decoration: InputDecoration(
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
