import 'package:flutter/material.dart';
import '../../constants.dart';
import '../../general pages/login.dart';

// ================= COLORS =================
const kOrange = Color.fromARGB(255, 247, 136, 1);
const kText = Color.fromARGB(255, 27, 27, 27);
const kGreenSoft = Color(0xFFD6EBDF);
const kGreenIcon = Color(0xFF2A7A55);

class TeacherProfileView extends StatelessWidget {
  const TeacherProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'My Profile',
          style: TextStyle(
            color: kText,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20),

            // ================= PROFILE AVATAR =================
            Center(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundColor: kGreenSoft,
                    child: Icon(
                      Icons.person,
                      size: 55,
                      color: AppColors.primaryColor,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: kOrange,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                      child: const Icon(
                        Icons.edit,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            const Center(
              child: Text(
                'Teacher Name',
                style: TextStyle(
                  color: kText,
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 6),

            const Center(
              child: Text(
                'teacher@example.com',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),

            const SizedBox(height: 30),

            _ProfileTile(
              icon: Icons.person_outline,
              title: 'Edit Profile',
              onTap: () {},
            ),

            _ProfileTile(
              icon: Icons.lock_outline,
              title: 'Security Settings',
              onTap: () {},
            ),

            _ProfileTile(
              icon: Icons.privacy_tip_outlined,
              title: 'Privacy Policy',
              onTap: () {},
            ),

            _ProfileTile(
              icon: Icons.help_outline,
              title: 'Help & Support',
              onTap: () {},
            ),

            _ProfileTile(
              icon: Icons.logout,
              title: 'Logout',
              iconBg: const Color(0xFFF8DCD8),
              color: kOrange,
              showArrow: false,
              onTap: () => _showLogoutDialog(context),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDF8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Log out?', textAlign: TextAlign.center),
        content: const Text(
          "You'll need to log in again to continue teaching.",
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: kOrange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext);

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const Login()),
                (route) => false,
              );
            },
            child: const Text('Log out'),
          ),
        ],
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final Color iconBg;
  final Color color;
  final bool showArrow;
  final VoidCallback? onTap;

  const _ProfileTile({
    required this.icon,
    required this.title,
    this.iconBg = kGreenSoft,
    this.color = kText,
    this.showArrow = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          size: 20,
          color: color == kText ? kGreenIcon : color,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: showArrow
          ? const Icon(Icons.chevron_right, color: Colors.grey)
          : null,
    );
  }
}
