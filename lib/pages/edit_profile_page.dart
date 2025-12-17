import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class EditProfilePage extends StatelessWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget inputField(String label, String text) {
      return Container(
        margin: const EdgeInsets.only(top: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: secondaryTextStyle.copyWith(fontSize: 13)),
            TextFormField(
              style: primaryTextStyle,
              initialValue: text,
              decoration: InputDecoration(
                hintStyle: primaryTextStyle,
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: subtitleTextColor)),
              ),
            ),
<<<<<<< Updated upstream
          ],
=======
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: bg3Color,
        appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          backgroundColor: bg1Color,
          elevation: 0,
          centerTitle: true,
            iconTheme: IconThemeData(color: primaryTextColor),
          title: Text('Edit Profile',
              style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
>>>>>>> Stashed changes
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg3Color,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        backgroundColor: bg1Color,
        elevation: 0,
        centerTitle: true,
<<<<<<< Updated upstream
        title: Text('Edit Profile', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
=======
        title: Text('Edit Profile',
            style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
        iconTheme: IconThemeData(color: primaryColor),
>>>>>>> Stashed changes
        actions: [
          IconButton(icon: Icon(Icons.check, color: primaryColor), onPressed: () {}),
        ],
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        width: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 30),
            Container(
              width: 100,
              height: 100,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(fit: BoxFit.fill, image: AssetImage('assets/image_profile.png')),
              ),
            ),
            inputField('Name', 'Alex Keinnzal'),
            inputField('Username', '@alexkeinn'),
            inputField('Email Address', 'alex.kein@gmail.com'),
          ],
        ),
      ),
    );
  }
}