


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marafty1/pages/login.dart';

const _green = Color(0xff2e6b3e);
const _beige = Color(0xffd9d2c3);
const _red = Color(0xffb3363b);
const _line = Color(0xffe6dccb);

class Security extends StatefulWidget {
  const Security({super.key});

  @override
  State<Security> createState() => _SecurityState();
}

class _SecurityState extends State<Security> {
  // كل Switch له قيمته الخاصة
  bool twoFactor = true;
  bool biometric = true;
  bool loginAlerts = false;

  void confirmDelete() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDF8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('Delete Account', textAlign: TextAlign.center),
        content: const Text(
          'Are you sure you want to delete your account?',
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: _red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(dialogContext).push(
                MaterialPageRoute(builder: (_) => const Login()),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _switch(bool value, ValueChanged<bool> onChanged) {
    return Switch(
      value: value,
      onChanged: onChanged,
      activeTrackColor: _green,
      activeThumbColor: Colors.white,
      inactiveTrackColor: _beige,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Security',
          style: GoogleFonts.lora(fontSize: 20, fontWeight: FontWeight.bold),
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
              onTap: () {}, // TODO: صفحة تغيير الباسورد
            ),
            _SettingRow(
              title: 'Two-factor authentication',
              trailing: _switch(twoFactor, (v) => setState(() => twoFactor = v)),
            ),
            _SettingRow(
              title: 'Face / fingerprint login',
              trailing: _switch(biometric, (v) => setState(() => biometric = v)),
            ),
            _SettingRow(
              title: 'Login alerts',
              trailing:
                  _switch(loginAlerts, (v) => setState(() => loginAlerts = v)),
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
              onTap: () {}, // TODO: صفحة الأجهزة
            ),

            const Spacer(),

            // ================= DELETE =================
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: confirmDelete,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _red,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Delete Account',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  const _SettingRow({required this.title, required this.trailing, this.onTap});

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