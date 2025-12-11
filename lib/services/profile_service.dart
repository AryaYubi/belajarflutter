import 'package:supabase_flutter/supabase_flutter.dart';
import 'supabase_service.dart';

class ProfileService {
  Future<Map<String, dynamic>?> getProfile() async {
    final uid = supabase.auth.currentUser!.id;

    final res = await supabase
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
    final uid = supabase.auth.currentUser!.id;

    await supabase.from('profiles').update({
      'name': name,
      'username': username,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', uid);
  }
}

final profileService = ProfileService();
