import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/services/profile_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'orders_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profile;
  bool loading = true;

  final supabase = Supabase.instance.client;
  final String? currentUserEmail =
      Supabase.instance.client.auth.currentUser?.email;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    setState(() => loading = true);
    try {
      final res = await profileService.getProfile();
      if (!mounted) return;
      setState(() {
        profile = res;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      debugPrint("Error fetching profile: $e");
    }
  }

  Future<void> handleLogout() async {
    await supabase.auth.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (_) => false);
  }

  void navigateToEditProfile() async {
    final result = await Navigator.pushNamed(
      context,
      '/edit-profile',
      arguments: {
        'name': profile?['name'] ?? '',
        'username': profile?['username'] ?? '',
        'email': currentUserEmail ?? '',
      },
    );

    if (result == true) {
      _refreshProfile();
    }
  }

  // ======================================================
  // MENU ITEM (FIXED: HOVER + CURSOR WEB)
  // ======================================================
  Widget menuItem(String text, {VoidCallback? onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                text,
                style: secondaryTextStyle.copyWith(fontSize: 13),
              ),
              Icon(Icons.chevron_right, color: primaryTextColor),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final name = profile?['name'] ?? 'Guest';
    final username = profile?['username'] ?? 'no_username';
    final avatarUrl = profile?['avatar_url'];

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
                  ClipOval(
                    child: avatarUrl == null
                        ? Image.asset(
                            'assets/image_profile.png',
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          )
                        : Image.network(
                            avatarUrl,
                            width: 64,
                            height: 64,
                            fit: BoxFit.cover,
                          ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        loading
                            ? const LinearProgressIndicator()
                            : Text(
                                "Hallo, $name",
                                style: primaryTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: semiBold,
                                ),
                              ),
                        Text(
                          "@$username",
                          style: subtitleTextStyle.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: _refreshProfile,
                    icon: const Icon(Icons.refresh, color: Color(0xff504F5E)),
                  ),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: handleLogout,
                      child:
                          Image.asset('assets/button_exit.png', width: 20),
                    ),
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
                Text(
                  'Account',
                  style: primaryTextStyle.copyWith(
                      fontSize: 16, fontWeight: semiBold),
                ),
                menuItem('Edit Profile', onTap: navigateToEditProfile),
                menuItem('Your Orders', onTap: () {
                  Navigator.pushNamed(context, '/orders');
                }),
                menuItem('Help'),
                const SizedBox(height: 30),
                Text(
                  'General',
                  style: primaryTextStyle.copyWith(
                      fontSize: 16, fontWeight: semiBold),
                ),
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
