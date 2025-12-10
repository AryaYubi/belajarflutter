import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/custom_button.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget header() {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Sign Up', style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold)),
            const SizedBox(height: 2),
            Text('Register and Happy Shoping', style: subtitleTextStyle),
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
              inputField('Full Name', 'assets/icon_name.png', 'Your Full Name'),
              inputField('Username', 'assets/icon_username.png', 'Your Username'),
              inputField('Email Address', 'assets/icon_email.png', 'Your Email Address'),
              inputField('Password', 'assets/icon_password.png', 'Your Password', isObscure: true),
              const SizedBox(height: 30),
              CustomButton(text: 'Sign Up', onPressed: () => Navigator.pushNamed(context, '/home')),
              const Spacer(),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ', style: subtitleTextStyle.copyWith(fontSize: 12)),
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Text('Sign In', style: purpleTextStyle.copyWith(fontSize: 12, fontWeight: medium)),
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