import 'package:flutter/material.dart';
import 'package:shamo/services/cart_service.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/services/chat_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shamo/pages/product_page.dart';
import 'package:shamo/pages/checkout_page.dart';


class DetailChatPage extends StatefulWidget {
  final String chatId;
  final Map<String, dynamic>? pendingProduct; // 👈 TAMBAH

  const DetailChatPage({
    super.key,
    required this.chatId,
    this.pendingProduct,
  });



  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  Map<String, dynamic>? pendingProduct; 
  bool productSent = false;             

  final supabase = Supabase.instance.client;
  

  // =============================
  // AUTO REPLY
  // =============================
String _autoReply(String userMessage) {
  final text = userMessage.toLowerCase();

  if (text.contains('size') || text.contains('ukuran')) {
    return 'Untuk size masih lengkap kak, mau ukuran berapa?';
  }

  if (text.contains('harga')) {
    return 'Harga sesuai yang tertera di aplikasi ya kak';
  }

  if (text.contains('ready') || text.contains('stok')) {
    return 'Stok masih tersedia dan siap dikirim hari ini';
  }

  return 'Baik kak, kami bantu cek dulu ya';
}

  // =============================
  // SEND MESSAGE
  // =============================
Future<void> handleSendMessage() async {
  final text = _messageController.text.trim();
  if (text.isEmpty) return;

  // 1️⃣ KIRIM PRODUCT SEKALI (JIKA ADA & BELUM TERKIRIM)
  if (pendingProduct != null && !productSent) {
    await chatService.sendProductMessage(
      chatId: widget.chatId,
      product: pendingProduct!,
    );

    setState(() {
      productSent = true;
      pendingProduct = null; // ⛔ hilangkan preview
    });
  }

  // 2️⃣ KIRIM PESAN USER
  await chatService.sendMessage(
    chatId: widget.chatId,
    message: text,
  );

  _messageController.clear();

  // 3️⃣ AUTO REPLY SELLER
  Future.delayed(const Duration(seconds: 1), () async {
    await chatService.sendMessage(
      chatId: widget.chatId,
      message: _autoReply(text),
      senderId: '54e68357-f6b8-4ba2-a7b3-8da904193961', // seller
    );
  });
}

  // =============================
  // CHAT BUBBLE
  // =============================

  Widget chatBubble(String text, bool isSender) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          color: isSender ? primaryColor : bg2Color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(text, style: primaryTextStyle),
      ),
    );
  }
  Widget chatInput() {
  return Container(
    padding: EdgeInsets.all(defaultMargin),
    decoration: BoxDecoration(
      color: bg1Color,
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.1),
          blurRadius: 8,
        ),
      ],
    ),
    child: Row(
      children: [
        Expanded(
          child: TextField(
            controller: _messageController,
            style: primaryTextStyle,
            decoration: InputDecoration(
              hintText: 'Type message...',
              hintStyle: subtitleTextStyle,
              filled: true,
              fillColor: bg2Color,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        IconButton(
          onPressed: handleSendMessage,
          icon: Icon(Icons.send, color: primaryColor),
        ),
      ],
    ),
  );
}

Widget productMessageBubble(Map<String, dynamic> product) {
  return Container(
    margin: const EdgeInsets.only(bottom: 16),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: bg2Color,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: primaryColor),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ─── PRODUCT INFO ───
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                product['image_url'],
                width: 54,
                height: 54,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: primaryTextStyle.copyWith(
                      fontWeight: semiBold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product['price']}',
                    style: priceTextStyle,
                  ),
                ],
              ),
            ),
          ],
        ),

      const SizedBox(height: 12),

      // ─── ACTION BUTTONS ───
Row(
  children: [
    Expanded(
      child: OutlinedButton(
        onPressed: () async {
          await cartService.addToCart(product['id']);
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Added to cart')),
          );
        },
        child: const Text('Add to Cart'),
      ),
    ),
    const SizedBox(width: 12),
    Expanded(
      child: ElevatedButton(
        onPressed: () async {
          await cartService.addToCart(
            product['id'],
            qty: 1,
          );

          if (!mounted) return;

          Navigator.pushNamed(context, '/cart');
        },
        child: const Text('Buy Now'),
      ),
    ),
  ],
),

    ],
  ),
);
}


  // =============================
  // BUILD
  // =============================
  @override
  Widget build(BuildContext context) {
    final currentUserId = supabase.auth.currentUser!.id;

    return Scaffold(
      backgroundColor: bg3Color,
      appBar: AppBar(
        backgroundColor: bg1Color,
        title: const Text('Shoe Store'),
      ),
      body: Column(
        children: [
          // PREVIEW PRODUCT (LOCAL)
    if (pendingProduct != null && !productSent)
      productMessageBubble(pendingProduct!), // 👈 cuma preview

          // CHAT LIST
          Expanded(
            child: StreamBuilder<List<Map<String, dynamic>>>(
              stream: chatService.getMessages(widget.chatId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const SizedBox();

                final messages = snapshot.data!;
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    final isSender = msg['sender_id'] == currentUserId;

                    // ✅ JIKA PRODUCT MESSAGE
                    if (msg['type'] == 'product' && msg['product'] != null) {
                      return productMessageBubble(msg['product']);
                    }

                    // ✅ JIKA TEXT MESSAGE
                    return chatBubble(
                      msg['content'],
                      isSender,
                    );
                  },

                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: chatInput(),
    );
  }
}