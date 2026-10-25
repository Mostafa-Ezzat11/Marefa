import 'package:flutter/material.dart';
import 'package:marefa/general%20pages/editpro.dart';
import 'package:marefa/general%20pages/pay.dart';
import 'package:marefa/general%20pages/ptivacy.dart';
import 'package:marefa/general%20pages/security.dart';

import 'login.dart';

// ================= COLORS =================
const kGreen = Color(0xFF0D5C3A);
const kGreenSoft = Color(0xFFD6EBDF);
const kGreenIcon = Color(0xFF2A7A55);
const kOrange = Color.fromARGB(255, 247, 136, 1);
const kText = Color.fromARGB(255, 27, 27, 27);

class MyProfileScreen extends StatefulWidget {
  const MyProfileScreen({super.key});

  @override
  State<MyProfileScreen> createState() => _MyProfileScreenState();
}

class _MyProfileScreenState extends State<MyProfileScreen> {
  int _selectedIndex = 3; // يفتح على Profile

  // الصفحات الخاصة بالـ Bottom Navigation
  final List<Widget> _pages = const [
    Center(child: Text('Home')), // حطي هنا HomeContent()
    Center(child: Text('My Courses')), // حطي هنا MyCoursesScreen()
    Center(child: Text('Wishlist')), // حطي هنا WishlistScreen()
    _ProfileContent(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: _selectedIndex, children: _pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: kGreen,
        unselectedItemColor: Colors.grey,
        showUnselectedLabels: true,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline),
            label: 'My Courses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_border),
            label: 'Wishlist',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}

// ================= PROFILE CONTENT =================
class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, elevation: 0),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
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
                  MaterialPageRoute(builder: (_) => EditProfile()),
                ),
              ),
              _ProfileTile(
                icon: Icons.lock_outline,
                title: 'Security Settings',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const Security()),
                ),
              ),
              _ProfileTile(
                icon: Icons.credit_card,
                title: 'Payment Methods',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PaymentMethods(),
                  ),
                ),
              ),
              _ProfileTile(
                icon: Icons.description_outlined,
                title: 'Privacy Policy',
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const Ptivacy()),
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
