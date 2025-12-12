// lib/services/chat_service.dart (CLEANED)
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'supabase_service.dart'; // Mengimport 'supabaseClient'

class ChatService {
  Stream<List<Map<String, dynamic>>> getMessagesStream() {
    // Ganti 'supabase' menjadi 'supabaseClient'
    final userId = supabaseClient.auth.currentUser!.id;

    return supabaseClient // Ganti 'supabase' menjadi 'supabaseClient'
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId) 
        .order('created_at', ascending: true);
  }

  Future<void> sendMessage({
    required String message,
    required bool isFromUser, 
  }) async {
    // Ganti 'supabase' menjadi 'supabaseClient'
    final userId = supabaseClient.auth.currentUser!.id;

    supabaseClient // Ganti 'supabase' menjadi 'supabaseClient'
        .from('chat_messages').insert({
      'user_id': userId,
      'message': message, 
      'is_from_user': isFromUser,
    });
  }
}

final chatService = ChatService();