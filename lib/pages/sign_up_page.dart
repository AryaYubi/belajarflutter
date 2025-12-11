import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/custom_button.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final supabase = Supabase.instance.client;

  final fullNameController = TextEditingController();
  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;

  Future<void> signUp() async {
    try {
      setState(() => isLoading = true);

      // 1️⃣ Register via Supabase Auth
      final response = await supabase.auth.signUp(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      final user = response.user;

      if (user == null) {
        throw Exception("User gagal dibuat!");
      }

      // 2️⃣ Insert ke tabel user_profiles
      await supabase.from('profiles').insert({
  'id': user.id,
  'name': fullNameController.text.trim(),
  'username': usernameController.text.trim(),
  'avatar_url': null,
});

      // 3️⃣ Redirect ke Home
      Navigator.pushReplacementNamed(context, '/home');

    } catch (e) {
      print("❌ ERROR SIGN UP: $e");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Sign Up gagal: $e")),
      );

    } finally {
      setState(() => isLoading = false);
    }
  }

  Widget inputField(String label, String icon, TextEditingController controller, String hint,
      {bool obscure = false}) {
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
            child: Row(
              children: [
                Image.asset(icon, width: 17),
                const SizedBox(width: 16),
                Expanded(
                  child: TextFormField(
                    controller: controller,
                    obscureText: obscure,
                    style: primaryTextStyle,
                    decoration: InputDecoration.collapsed(hintText: hint, hintStyle: subtitleTextStyle),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1Color,
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: defaultMargin),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Text('Sign Up', style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold)),
              Text('Register and Happy Shopping', style: subtitleTextStyle),

              inputField('Full Name', 'assets/icon_name.png', fullNameController, 'Your Full Name'),
              inputField('Username', 'assets/icon_username.png', usernameController, 'Your Username'),
              inputField('Email Address', 'assets/icon_email.png', emailController, 'Your Email'),
              inputField('Password', 'assets/icon_password.png', passwordController, 'Your Password',
                  obscure: true),

              const SizedBox(height: 30),

              CustomButton(
                text: isLoading ? 'Loading...' : 'Sign Up',
                onPressed: isLoading ? () {} : () => signUp(),
              ),

              const Spacer(),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Already have an account? ', style: subtitleTextStyle.copyWith(fontSize: 12)),
                  GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/sign-in'),
                    child: Text('Sign In',
                        style: purpleTextStyle.copyWith(fontSize: 12, fontWeight: medium)),
                  ),
                ],
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
