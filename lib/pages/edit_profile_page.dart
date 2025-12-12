import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/services/profile_service.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController usernameController;
  late TextEditingController emailController;

  bool isLoading = true;   // For initial fetch or argument load
  bool isSaving = false;   // For saving profile

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
  }

  // Load arguments or fetch profile if needed
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final args =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (args != null) {
      // Load from arguments (Version 1)
      nameController.text = args['name'] ?? '';
      usernameController.text = args['username'] ?? '';
      emailController.text = args['email'] ?? '';
      setState(() => isLoading = false);
    } else {
      // If no arguments passed → auto fetch profile (Version 2)
      _fetchProfile();
    }
  }

  // Fetch from Supabase
  Future<void> _fetchProfile() async {
    try {
      final profile = await profileService.getProfile();

      if (!mounted) return;

      if (profile != null) {
        nameController.text = profile['name'] ?? '';
        usernameController.text = profile['username'] ?? '';
        emailController.text = profile['email'] ?? '';
      }

      setState(() => isLoading = false);
    } catch (e) {
      if (!mounted) return;
      setState(() => isLoading = false);
    }
  }

  // Save updated profile
  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty ||
        usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: alertColor,
          content: const Text("Name and username cannot be empty"),
        ),
      );
      return;
    }

    setState(() => isSaving = true);

    try {
      await profileService.updateProfile(
        name: nameController.text.trim(),
        username: usernameController.text.trim(),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: secondaryColor,
          content: const Text("Profile updated successfully!"),
        ),
      );

      Navigator.pop(context, true); // send "true" to refresh ProfilePage
    } catch (e) {
      if (!mounted) return;

      String message = "Failed to update profile";
      if (e.toString().contains("duplicate key")) {
        message = "Username already taken. Try another.";
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(backgroundColor: alertColor, content: Text(message)),
      );

      setState(() => isSaving = false);
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    usernameController.dispose();
    emailController.dispose();
    super.dispose();
  }

  Widget inputField(String label, TextEditingController controller,
      {bool enabled = true}) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: secondaryTextStyle.copyWith(fontSize: 13)),
          TextFormField(
            controller: controller,
            enabled: enabled,
            style: primaryTextStyle,
            decoration: InputDecoration(
              hintStyle: primaryTextStyle,
              disabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: subtitleTextColor.withOpacity(0.3)),
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: subtitleTextColor),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: primaryColor),
              ),
            ),
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
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text('Edit Profile',
              style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bg3Color,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context)),
        backgroundColor: bg1Color,
        elevation: 0,
        centerTitle: true,
        title: Text('Edit Profile',
            style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
        iconTheme: const IconThemeData(color: Color(0xff6C5ECF)),
        actions: [
          IconButton(
            icon: isSaving
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child:
                        CircularProgressIndicator(color: primaryColor, strokeWidth: 3),
                  )
                : Icon(Icons.check, color: primaryColor),
            onPressed: isSaving ? null : saveProfile,
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: [
          const SizedBox(height: 30),

          // Avatar
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                fit: BoxFit.fill,
                image: AssetImage('assets/image_profile.png'),
              ),
            ),
          ),

          // Inputs
          inputField('Name', nameController),
          inputField('Username', usernameController),
          inputField('Email Address', emailController, enabled: false),

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}