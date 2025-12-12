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
  
  bool isLoading = true;
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    usernameController = TextEditingController();
    emailController = TextEditingController();
    fetchProfile();
  }

  Future<void> fetchProfile() async {
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

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty || usernameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and username cannot be empty')),
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
        const SnackBar(content: Text('Profile updated successfully!')),
      );

      Navigator.pop(context);
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update profile: $e')),
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

  Widget inputField(String label, TextEditingController controller, {bool enabled = true}) {
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
              enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: subtitleTextColor)),
              disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: subtitleTextColor.withOpacity(0.3))),
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
          leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
          backgroundColor: bg1Color,
          elevation: 0,
          centerTitle: true,
          title: Text('Edit Profile', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: bg3Color,
      appBar: AppBar(
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        backgroundColor: bg1Color,
        elevation: 0,
        centerTitle: true,
        title: Text('Edit Profile', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
        actions: [
          IconButton(
            icon: Icon(Icons.check, color: isSaving ? Colors.grey : primaryColor),
            onPressed: isSaving ? null : saveProfile,
          ),
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
            inputField('Name', nameController),
            inputField('Username', usernameController),
            inputField('Email Address', emailController, enabled: false),
          ],
        ),
      ),
    );
  }
}