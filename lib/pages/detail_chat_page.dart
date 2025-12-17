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
  // BUNGKUS DENGAN ROW JUGA UNTUK ALIGNMENT
  return Row(
    mainAxisAlignment: isSender ? MainAxisAlignment.end : MainAxisAlignment.start,
    children: [
      Container(
        // Margin samakan dengan product
        margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20),
        
        // 2. CONSTRAINT MAKSIMAL DISAMAKAN (225)
        constraints: const BoxConstraints(
          maxWidth: 225, // Agar chat tidak pernah lebih lebar dari produk
          minWidth: 80,  // Agar tidak terlalu gepeng kalau chat pendek
        ),
        
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSender ? primaryColor : const Color(0xff2B2844),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 12 : 0),
            topRight: Radius.circular(isSender ? 0 : 12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
        ),
        child: Text(
          text,
          style: primaryTextStyle.copyWith(
            color: isSender ? const Color(0xff2B2844) : primaryTextColor
          ),
        ),
      ),
    ],
  );
}
  Widget chatInput() {
  return Container(
    padding: EdgeInsets.all(defaultMargin),
    decoration: BoxDecoration(
      color: bg1Color,
      boxShadow: [
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
              fillColor: bg1Color,
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
  // BUNGKUS DENGAN ROW AGAR TIDAK STRETCH KE SAMPING
  return Row(
    mainAxisAlignment: MainAxisAlignment.end, // Mentok Kiri
    children: [
      Container(
        // 1. KUNCI LEBAR DISINI (225 pixel)
        width: 225, 
        
        // Margin & Style
        margin: const EdgeInsets.only(bottom: 12, left: 20, right: 20, top: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xff2B2844),
          borderRadius: BorderRadius.circular(20),
        ),
        
        child: Column(
          children: [
            // --- GAMBAR & TEXT ---
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product['image_url'],
                    width: 50, // Gambar Kecil
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset('assets/image_shoes.png', width: 50, height: 50),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        product['name'],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: primaryTextStyle.copyWith(fontSize: 13, fontWeight: semiBold),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '\$${product['price']}',
                        style: priceTextStyle.copyWith(fontSize: 13, fontWeight: medium),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 10),

            // --- TOMBOL KECIL ---
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 32, // Tinggi tombol 32
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: primaryColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () async { /* logic */ },
                      child: Text('Add to Cart', style: primaryTextStyle.copyWith(color: primaryColor, fontSize: 10)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SizedBox(
                    height: 32, // Tinggi tombol 32
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () async { /* logic */ },
                      child: Text('Buy Now', style: primaryTextStyle.copyWith(color: const Color(0xff2B2844), fontSize: 10, fontWeight: semiBold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

  // =============================
  // BUILD
  // =============================
  @override
  Widget build(BuildContext context) {
    final currentUserId = supabase.auth.currentUser!.id;

    return Scaffold(
      backgroundColor: bg1Color,
      appBar: AppBar(
        backgroundColor: bg1Color,
        elevation: 0,
        centerTitle: false,
        
        // 1. DISINI LETAK TOMBOL BACK (MENGGUNAKAN ASSET)
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          // Ganti 'assets/icon_back.png' dengan nama file asset icon panah Anda
          icon: Image.asset(
            'assets/button_back.png', 
            width: 8, // Sesuaikan ukuran icon back (biasanya kecil sekitar 8-10 width)
          ),
        ),

        // 2. BAGIAN LOGO TOKO DAN STATUS
        title: Row(
          children: [
            // Logo Toko & Online Status
            Stack(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      // Pastikan asset logo toko sudah ada di folder assets
                      image: AssetImage('assets/image_shop_logo.png'), 
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xff51C17E),
                      border: Border.all(
                        color: bg4Color,
                        width: 2.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(width: 12),
            
            // Teks Nama & Status
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shoe Store',
                  style: primaryTextStyle.copyWith(
                    fontWeight: medium,
                    fontSize: 14,
                  ),
                ),
                Text(
                  'Online',
                  style: subtitleTextStyle.copyWith(
                    fontWeight: light,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ],
        ),
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