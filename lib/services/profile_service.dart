import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart'; // supabaseClient

class ProfileService {
  Future<Map<String, dynamic>?> getProfile() async {
    final uid = supabaseClient.auth.currentUser!.id;

    final res = await supabaseClient
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
    final uid = supabaseClient.auth.currentUser!.id;

    // ⚡ Important: await the update
    await supabaseClient
        .from('profiles')
        .update({
          'name': name,
          'username': username,
          if (avatarUrl != null) 'avatar_url': avatarUrl,
        })
        .eq('id', uid);
  }
}

final profileService = ProfileService();