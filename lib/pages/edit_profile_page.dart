// lib/pages/edit_profile_page.dart (UPDATED - Dynamic & Supabase Ready)
import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/services/profile_service.dart'; // Import Profile Service

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  // 1. Controllers untuk mengontrol input fields
  late TextEditingController _nameController;
  late TextEditingController _usernameController;
  late TextEditingController _emailController;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inisialisasi awal controller
    _nameController = TextEditingController();
    _usernameController = TextEditingController();
    _emailController = TextEditingController();
  }

  // 2. Mengambil data dari argument setelah widget dibangun
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Arguments yang dikirim dari ProfilePage
    final Map<String, dynamic>? arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;

    if (arguments != null) {
      // Set nilai awal controller dari data user live
      _nameController.text = arguments['name'] ?? '';
      _usernameController.text = arguments['username'] ?? '';
      _emailController.text = arguments['email'] ?? ''; 
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  // 3. Fungsi Update Profile
  Future<void> handleUpdate() async {
    setState(() => _isLoading = true);

    // Validasi sederhana
    if (_nameController.text.trim().isEmpty ||
        _usernameController.text.trim().isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: const Text("Nama dan Username tidak boleh kosong."),
          ),
        );
      }
      setState(() => _isLoading = false);
      return;
    }

    try {
      await profileService.updateProfile(
        name: _nameController.text.trim(),
        username: _usernameController.text.trim(),
        // avatarUrl diabaikan dulu, fokus ke text fields
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: secondaryColor,
            content: const Text("Profil berhasil diperbarui!"),
          ),
        );
        // Kembali ke ProfilePage dan kirim sinyal update (true)
        Navigator.pop(context, true); 
      }
    } catch (e) {
      if (mounted) {
        String errorMessage = "Gagal memperbarui profil. Coba lagi.";
        // Penanganan error duplicate key (username sudah dipakai)
        if (e.toString().contains('duplicate key')) {
          errorMessage = "Username sudah digunakan. Silakan coba username lain.";
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: Text(errorMessage),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  // 4. Widget Input Field yang menggunakan Controller
  Widget inputField({
    required String label,
    required TextEditingController controller,
    bool isReadOnly = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(top: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: secondaryTextStyle.copyWith(fontSize: 13)),
          TextFormField(
            readOnly: isReadOnly, // Menetapkan readOnly
            controller: controller, // Menggunakan controller yang sudah diinisialisasi
            style: primaryTextStyle,
            decoration: InputDecoration(
              hintStyle: primaryTextStyle,
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: subtitleTextColor)),
              // Memberi warna ungu pada border saat fokus
              focusedBorder: isReadOnly
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(color: subtitleTextColor))
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: primaryColor)), 
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg3Color,
      appBar: AppBar(
        leading: IconButton(
            icon: const Icon(Icons.close), onPressed: () => Navigator.pop(context)),
        backgroundColor: bg1Color,
        elevation: 0,
        centerTitle: true,
        title: Text('Edit Profile',
            style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
        actions: [
          // Tombol Update Profile (Checkmark)
          IconButton(
            icon: _isLoading 
                ? SizedBox(
                    width: 20, 
                    height: 20, 
                    child: CircularProgressIndicator(color: primaryColor, strokeWidth: 3)
                  ) 
                : Icon(Icons.check, color: primaryColor),
            onPressed: _isLoading ? null : handleUpdate,
          ),
        ],
      ),
      // Ganti Column dengan ListView agar bisa di-scroll saat keyboard muncul
      body: ListView( 
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: [
          const SizedBox(height: 30),
          // Bagian Foto Profil
          Container(
            width: 100,
            height: 100,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill, image: AssetImage('assets/image_profile.png')),
            ),
          ),

          // Input Fields Dinamis
          inputField(label: 'Name', controller: _nameController),
          inputField(label: 'Username', controller: _usernameController),
          // Email tidak bisa diubah karena itu adalah key dari auth.users
          inputField(
              label: 'Email Address',
              controller: _emailController,
              isReadOnly: true), 

          const SizedBox(height: 50),
        ],
      ),
    );
  }
}