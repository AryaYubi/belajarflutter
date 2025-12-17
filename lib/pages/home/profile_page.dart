import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    Widget menuItem(String text, {VoidCallback? onTap}) {
      return GestureDetector(
        onTap: onTap,
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(text, style: secondaryTextStyle.copyWith(fontSize: 13)),
              Icon(Icons.chevron_right, color: primaryTextColor),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        AppBar(
          backgroundColor: bg1Color,
          automaticallyImplyLeading: false,
          elevation: 0,
          flexibleSpace: SafeArea(
            child: Container(
              padding: EdgeInsets.all(defaultMargin),
              child: Row(
                children: [
                  ClipOval(child: Image.asset('assets/image_profile.png', width: 64)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hallo, Alex', style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold)),
                        Text('@alexkeinn', style: subtitleTextStyle.copyWith(fontSize: 16)),
                      ],
                    ),
                  ),
<<<<<<< Updated upstream
                  GestureDetector(
                    onTap: () => Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false),
                    child: Image.asset('assets/button_exit.png', width: 20),
=======
                  IconButton(
                    onPressed: _refreshProfile,
                    icon: Icon(Icons.refresh, color: subtitleTextColor),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: handleLogout,
                      child:
                          Image.asset('assets/button_exit.png', width: 20),
                    ),
>>>>>>> Stashed changes
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            decoration: BoxDecoration(color: bg3Color),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text('Account', style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: semiBold)),
                menuItem('Edit Profile', onTap: () => Navigator.pushNamed(context, '/edit-profile')),
                menuItem('Your Orders'),
                menuItem('Help'),
                const SizedBox(height: 30),
                Text('General', style: primaryTextStyle.copyWith(fontSize: 16, fontWeight: semiBold)),
                menuItem('Privacy & Policy'),
                menuItem('Term of Service'),
                menuItem('Rate App'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}