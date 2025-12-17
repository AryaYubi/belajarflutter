import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/custom_button.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({super.key});

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final supabase = Supabase.instance.client;

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  // ==========================================================
  // LOGIN FUNCTION
  // ==========================================================
  Future<void> signIn() async {
    setState(() => isLoading = true);

    // VALIDASI INPUT
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      
      // PENTING: Pengecekan mounted sebelum menggunakan context
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: alertColor,
          content: const Text("Email dan password tidak boleh kosong."),
        ),
      );
      setState(() => isLoading = false);
      return;
    }

    try {
      final response = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      // PENTING: Pengecekan mounted setelah await
      if (!mounted) return; 

      if (response.session == null) {
        throw Exception("Email atau password salah");
      }

      Navigator.pushReplacementNamed(context, '/home');

    } catch (e) {
      // PENTING: Pengecekan mounted sebelum menggunakan context di catch block
      if (!mounted) return; 

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: alertColor,
          content: Text("Login gagal: $e"),
        ),
      );
    }

    // PENTING: Pengecekan mounted sebelum setState akhir
    if (!mounted) return; 
    
    setState(() => isLoading = false);
  }

  // ==========================================================
  // UI COMPONENTS
  // ==========================================================

  Widget header() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: primaryTextStyle.copyWith(
              fontSize: 24,
              fontWeight: semiBold,
            ),
          ),
          const SizedBox(height: 2),
          Text('Sign In to Continue', style: subtitleTextStyle),
        ],
      ),
    );
  }

    Widget inputField(String label, String iconPath, String hint, {bool isObscure = false}) {
      return Container(
        margin: const EdgeInsets.only(top: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: medium)),
            const SizedBox(height: 12),
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: bg2Color, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: Row(
                  children: [
                    Image.asset(iconPath, width: 17),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextFormField(
                        style: primaryTextStyle,
                        obscureText: isObscure,
                        decoration: InputDecoration.collapsed(hintText: hint, hintStyle: subtitleTextStyle),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg1Color,
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              header(),
              SizedBox(height: 50),
              inputField('Email Address', 'assets/icon_email.png', 'Your Email Address'),
              inputField('Password', 'assets/icon_password.png', 'Your Password', isObscure: true),
              const SizedBox(height: 30),
              CustomButton(text: 'Sign In', onPressed: () => Navigator.pushNamed(context, '/home')),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Don\'t have an account? ', style: subtitleTextStyle.copyWith(fontSize: 12)),
                    GestureDetector(
                      onTap: () => Navigator.pushNamed(context, '/sign-up'),
                      child: Text('Sign Up', style: purpleTextStyle.copyWith(fontSize: 12, fontWeight: medium)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}