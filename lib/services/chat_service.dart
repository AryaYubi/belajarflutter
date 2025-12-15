import 'supabase_service.dart';

class ChatService {
  /// Ambil atau buat chat antara user (buyer) dan seller
  Future<String> getOrCreateChat({
    required String sellerId,
  }) async {
    final userId = supabaseClient.auth.currentUser!.id;

    // 1️⃣ Cek apakah chat user ↔ seller sudah ada (via RPC)
    final existing = await supabaseClient
        .rpc('get_chat_between_user_seller', params: {
          'user_id_param': userId,
          'seller_id_param': sellerId,
        });

    if (existing != null && existing.isNotEmpty) {
      return existing[0]['chat_id'];
    }

    // 2️⃣ Buat chat baru
    final chat = await supabaseClient
        .from('chats')
        .insert({})
        .select('id')
        .single();

    final chatId = chat['id'];

    // 3️⃣ Tambahkan member chat (user & seller)
    await supabaseClient.from('chat_members').insert([
      {
        'chat_id': chatId,
        'user_id': userId,
        'role': 'user',
      },
      {
        'chat_id': chatId,
        'user_id': sellerId,
        'role': 'seller',
      },
    ]);

    return chatId;
  }

  /// Ambil semua chat milik user (untuk ChatPage / inbox)
  Future<List<Map<String, dynamic>>> getMyChats() async {
    final userId = supabaseClient.auth.currentUser!.id;

    final response = await supabaseClient
        .from('chat_members')
        .select('''
          chat_id,
          chats (
            id,
            chat_messages (
              content,
              created_at
            )
          )
        ''')
        .eq('user_id', userId);

    return List<Map<String, dynamic>>.from(response);
  }

  /// Stream pesan realtime berdasarkan chat_id
  Stream<List<Map<String, dynamic>>> getMessages(String chatId) {
    return supabaseClient
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .order('created_at', ascending: true);
  }

  /// Kirim pesan (sender = user yang sedang login)
  Future<void> sendMessage({
    required String chatId,
    required String message,
  }) async {
    final userId = supabaseClient.auth.currentUser!.id;

    await supabaseClient.from('chat_messages').insert({
      'chat_id': chatId,
      'sender_id': userId,
      'content': message,
    });
  }
}

final chatService = ChatService();
