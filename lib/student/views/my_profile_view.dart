import 'package:flutter/material.dart';
import 'package:marefa/general%20pages/login.dart';
import 'package:marefa/student/views/edit_profile_view.dart';
import 'package:marefa/student/views/payment_methods_view.dart';
import 'package:marefa/student/views/privacy_policy_view.dart';
import 'package:marefa/student/views/security_view.dart';

// ================= COLORS =================
const kGreen = Color(0xFF0D5C3A);
const kGreenSoft = Color(0xFFD6EBDF);
const kGreenIcon = Color(0xFF2A7A55);
const kOrange = Color.fromARGB(255, 247, 136, 1);
const kText = Color.fromARGB(255, 27, 27, 27);

class MyProfileView extends StatelessWidget {
  const MyProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _ProfileContent();
  }
}

// ================= PROFILE CONTENT =================
class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 40,
              right: 20,
              left: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),

                // ================= AVATAR =================
                Center(
                  child: Stack(
                    clipBehavior: Clip.none,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: kGreenIcon,
                        child: Text(
                          "T",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 34,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Positioned(
                        right: -2,
                        bottom: 0,
                        child: GestureDetector(
                          onTap: () {}, // TODO: اختيار صورة
                          child: Container(
                            width: 28,
                            height: 28,
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
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // ================= NAME =================
                const Center(
                  child: Text(
                    'Tasbeeh Ahmed',
                    style: TextStyle(
                      color: kOrange,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),

                const SizedBox(height: 3),

                // ================= EMAIL =================
                const Center(
                  child: Text(
                    'tasbeeh.ahmed@gmail.com',
                    style: TextStyle(
                      color: Color.fromARGB(255, 66, 108, 70),
                      fontSize: 14,
                    ),
                  ),
                ),

                const SizedBox(height: 15),

                // ================= MENU =================
                _ProfileTile(
                  icon: Icons.person_outline,
                  title: 'Edit Profile',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => EditProfileView(),
                    ),
                  ),
                ),
                _ProfileTile(
                  icon: Icons.lock_outline,
                  title: 'Security Settings',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const SecurityView(),
                    ),
                  ),
                ),
                _ProfileTile(
                  icon: Icons.credit_card,
                  title: 'Payment Methods',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PaymentMethodsView(),
                    ),
                  ),
                ),
                _ProfileTile(
                  icon: Icons.description_outlined,
                  title: 'Privacy Policy',
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const PrivacyPolicyView(),
                    ),
                  ),
                ),

                // ================= LOGOUT =================
                _ProfileTile(
                  icon: Icons.logout,
                  title: 'Logout',
                  iconBg: const Color(0xFFF8DCD8),
                  color: kOrange,
                  showArrow: false,
                  onTap: () => showLogoutDialog(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= LOGOUT DIALOG =================
  void showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: const Color(0xFFFFFDF8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
        title: const Text('Log out?', textAlign: TextAlign.center),
        content: const Text(
          "You'll need to log in again to continue learning.",
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
              // امسحي التوكن هنا، مثلاً: await storage.delete(key: 'token');
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

// ================= REUSABLE TILE =================
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
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: iconBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: color == kText ? kGreenIcon : color,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: showArrow ? const Icon(Icons.chevron_right) : null,
    );
  }
}
