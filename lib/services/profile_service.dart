// lib/services/profile_service.dart (UPDATE)
import 'package:supabase_flutter/supabase_flutter.dart'; // Tambahkan impor ini jika Anda mencabutnya
import 'supabase_service.dart'; // Mengimport 'supabaseClient'

class ProfileService {
  Future<Map<String, dynamic>?> getProfile() async {
    // Ganti 'supabase' menjadi 'supabaseClient'
    final uid = supabaseClient.auth.currentUser!.id;

    final res = await supabaseClient // Ganti 'supabase' menjadi 'supabaseClient'
        .from('profiles')
        .select()
        .eq('id', uid)
        .maybeSingle();

    return res;
  }

  Future<void> updateProfile({
    required String name,
    required String username,
    String? avatarUrl,
  }) async {
    // Ganti 'supabase' menjadi 'supabaseClient'
    final uid = supabaseClient.auth.currentUser!.id;

    supabaseClient // Ganti 'supabase' menjadi 'supabaseClient'
        .from('profiles').update({
      'name': name,
      'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', uid);
  }
}

final profileService = ProfileService();