import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Ptivacy extends StatelessWidget {
  const Ptivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Privacy policy',
          style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              // ================= CONTENT (يتسكرول) =================
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last updated October 2026',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const _Section(
                        title: 'Data we collect',
                        body:
                            'Name, email, phone and course activity, used to run your account.',
                      ),
                      const _Section(
                        title: 'How we use it',
                        body:
                            'To personalise recommendations, process payments and send important updates.',
                      ),
                      const _Section(
                        title: 'Sharing',
                        body:
                            'We never sell your data. Payments are handled by trusted providers.',
                      ),
                      const _Section(
                        title: 'Your rights',
                        body:
                            'You can edit, export or delete your data from Settings at any time.',
                      ),
                    ],
                  ),
                ),
              ),

              // ================= BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2e6b3e),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'I understand',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= REUSABLE SECTION =================
class _Section extends StatelessWidget {
  final String title;
  final String body;

  const _Section({required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            body,
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 15,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}