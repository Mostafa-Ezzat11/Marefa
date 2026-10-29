import 'package:flutter/material.dart';
import 'package:marefa/general%20pages/login.dart';

class LoginSignUpSelection extends StatefulWidget {
  const LoginSignUpSelection({super.key});

  @override
  State<LoginSignUpSelection> createState() =>
      _LoginSignUpSelectionState();
}

class _LoginSignUpSelectionState extends State<LoginSignUpSelection> {
  String? _selectedtype = "Login"; // يبدأ على Login

  @override
  Widget build(BuildContext context) {
    const green = Color.fromARGB(255, 51, 86, 69);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ================= LOGO =================
              ClipOval(
                child: Image.asset(
                  'assets/images/logo-green.png',
                  fit: BoxFit.fitHeight,
                  height: 170,
                  width: 170,
                ),
              ),

              const SizedBox(height: 20),

              // ================= TEXTS =================
              const Text(
                "Welcome to Marefa",
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 19,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                "Choose how you want to continue",
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 30),

              // ================= OPTIONS =================
              Row(
                children: [
                  Expanded(
                    child: _TypeOption(
                      label: "Login",
                      selected: _selectedtype == "Login",
                      onTap: () =>
                          setState(() => _selectedtype = "Login"),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _TypeOption(
                      label: "Sign Up",
                      selected: _selectedtype == "Sign Up",
                      onTap: () =>
                          setState(() => _selectedtype = "Sign Up"),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ================= CONTINUE =================
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: () {
                    if (_selectedtype == "Login") {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const Login(),
                        ),
                      );
                    } else {
                      // TODO: افتحي صفحة الـ Sign Up هنا
                    }
                  },
                  child: const Text("Continue"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ================= OPTION BUTTON =================
class _TypeOption extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _TypeOption({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const green = Color.fromARGB(255, 51, 86, 69);
    const beige = Color(0xFFF5EFE6);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 14),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? green : beige,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: selected ? green : const Color(0xFFE6DCCB),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : green,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
