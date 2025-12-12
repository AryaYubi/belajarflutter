// lib/pages/home/profile_page.dart (Stateful - Final Version)
import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/services/profile_service.dart'; // Import service untuk fetch data
import 'package:supabase_flutter/supabase_flutter.dart'; // Untuk logout

class ProfilePage extends StatefulWidget { 
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? profile;
  bool isLoading = true;
  // Ambil email user yang sedang login dari Supabase Auth
  final String? currentUserEmail = Supabase.instance.client.auth.currentUser?.email;

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  // Fungsi untuk mengambil data profil dari Supabase
  Future<void> fetchProfileData() async {
    try {
      final res = await profileService.getProfile();
      if (!mounted) return;
      setState(() {
        profile = res;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      // Handle error fetching profile
      setState(() => isLoading = false);
    }
  }

  // Fungsi untuk Logout
  Future<void> handleLogout() async {
    await Supabase.instance.client.auth.signOut();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, '/sign-in', (route) => false);
  }

  // Fungsi untuk handle navigasi ke Edit Profile dan menunggu hasil update
  void navigateToEditProfile() async {
    final result = await Navigator.pushNamed(context, '/edit-profile', arguments: {
      'name': profile?['name'] ?? '',
      'username': profile?['username'] ?? '',
      'email': currentUserEmail ?? '', 
    });

    // Jika EditProfilePage mengirimkan sinyal 'true' (artinya update berhasil), refresh data
    if (result == true) {
      setState(() => isLoading = true); // Tampilkan loading sebentar
      await fetchProfileData(); // Ambil data terbaru
    }
  }

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

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      // Jika loading, tampilkan loading indicator
      return const Center(child: CircularProgressIndicator());
    }
    
    // Menggunakan data dinamis atau fallback ke placeholder
    final name = profile?['name'] ?? 'User';
    final username = profile?['username'] ?? '@username';
    final avatarUrl = profile?['avatar_url'];

    return Column(
      children: [
        // HEADER DINAMIS
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
                    // Menampilkan Network Image jika avatarUrl ada
                    child: avatarUrl != null
                        ? Image.network(avatarUrl, width: 64, height: 64, fit: BoxFit.cover)
                        : Image.asset('assets/image_profile.png', width: 64),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Hallo, $name', style: primaryTextStyle.copyWith(fontSize: 24, fontWeight: semiBold)),
                        Text(username, style: subtitleTextStyle.copyWith(fontSize: 16)),
                      ],
                    ),
                  ),
                  // Tombol EXIT menggunakan fungsi Logout
                  GestureDetector(
                    onTap: handleLogout,
                    child: Image.asset('assets/button_exit.png', width: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
        
        // MENU ITEMS
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
                
                // Navigasi ke Edit Profile menggunakan fungsi custom
                menuItem('Edit Profile', onTap: navigateToEditProfile),
                
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