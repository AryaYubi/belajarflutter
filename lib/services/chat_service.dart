// lib/services/chat_service.dart
import 'supabase_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


final SupabaseClient supabase = Supabase.instance.client;

class ChatService {
  /// USER ↔ SELLER ↔ PRODUCT
  Future<String> getOrCreateChat({
    required String sellerId,
    required int productId,
  }) async {
    final userId = supabaseClient.auth.currentUser!.id;

    // CEK CHAT EXISTING
    final existing = await supabaseClient
        .from('chats')
        .select('id')
        .eq('product_id', productId)
        .limit(1);

    if (existing.isNotEmpty) {
      return existing.first['id'];
    }

    // BUAT CHAT BARU
    final chat = await supabaseClient
        .from('chats')
        .insert({'product_id': productId})
        .select('id')
        .single();

    final chatId = chat['id'];

    // MEMBER CHAT
    await supabaseClient.from('chat_members').insert([
      {'chat_id': chatId, 'user_id': userId, 'role': 'user'},
      {'chat_id': chatId, 'user_id': sellerId, 'role': 'seller'},
    ]);

    return chatId;
  }

  /// CHAT LIST (INBOX)
  Future<List<Map<String, dynamic>>> getMyChats() async {
    final userId = supabaseClient.auth.currentUser!.id;

    final data = await supabaseClient
        .from('chat_members')
        .select('''
          chat_id,
          chats (
            id,
            product_id,
            products (
              id,
              name,
              price,
              image_url
            ),
            chat_messages (
              content,
              created_at
            )
          )
        ''')
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(data);
  }

  /// STREAM MESSAGE
  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
  return supabaseClient
      .from('chat_messages')
      .stream(primaryKey: ['id'])
      .eq('chat_id', chatId)
      .order('created_at', ascending: false); // 🔥 PENTING
}


  /// SEND MESSAGE
 Future<void> sendMessage({
  required String chatId,
  required String message,
  String? senderId,
}) async {
  final userId = senderId ?? supabase.auth.currentUser!.id;

  await supabase.from('chat_messages').insert({
    'chat_id': chatId,
    'sender_id': userId,
    'content': message,
  });
}
Future<void> sendProductMessage({
  required String chatId,
  required Map<String, dynamic> product,
}) async {
  final userId = supabase.auth.currentUser!.id;

  await supabase.from('chat_messages').insert({
    'chat_id': chatId,
    'sender_id': userId,
    'content': '[PRODUCT]', // ⛔ hanya placeholder
    'product': product,     // ✅ INI YANG DIPAKAI UI
    'type': 'product',      // ✅ PENTING
  });
}
}
final chatService = ChatService();
