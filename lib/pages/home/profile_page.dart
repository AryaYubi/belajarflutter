import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final supabase = Supabase.instance.client;
  Map<String, dynamic>? profile;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    setState(() => loading = true);

    final user = supabase.auth.currentUser;
    if (user == null) return;

    try {
      final res = await supabase
          .from('profiles')
          .select()
          .eq('id', user.id)
          .single();

      if (!mounted) return;

      setState(() {
        profile = res;
        loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => loading = false);
      debugPrint('Error fetching profile: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final name = profile?['name'] ?? 'Guest';
    final username = profile?['username'] ?? 'no_username';
    final avatarUrl = profile?['avatar_url'];

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
                  ClipOval(
                    child: avatarUrl == null
                        ? Image.asset('assets/image_profile.png', width: 64)
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
                                'Hallo, $name',
                                style: primaryTextStyle.copyWith(
                                  fontSize: 24,
                                  fontWeight: semiBold,
                                ),
                              ),
                        Text(
                          '@$username',
                          style: subtitleTextStyle.copyWith(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  // REFRESH BUTTON
                  IconButton(
                    onPressed: _refreshProfile,
                    icon: const Icon(Icons.refresh, color: Colors.white),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await supabase.auth.signOut();
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/sign-in', (route) => false);
                    },
                    child: Image.asset('assets/button_exit.png', width: 20),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Body
        Expanded(
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            decoration: BoxDecoration(color: bg3Color),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),
                Text('Account',
                    style: primaryTextStyle.copyWith(
                        fontSize: 16, fontWeight: semiBold)),
                menuItem('Edit Profile',
                    onTap: () =>
                        Navigator.pushNamed(context, '/edit-profile')),
                menuItem('Your Orders'),
                menuItem('Help'),
                const SizedBox(height: 30),
                Text('General',
                    style: primaryTextStyle.copyWith(
                        fontSize: 16, fontWeight: semiBold)),
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