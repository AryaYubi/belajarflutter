// lib/pages/detail_chat_page.dart (CLEANED)
import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/services/chat_service.dart'; // Import Chat Service
import 'package:supabase_flutter/supabase_flutter.dart'; // Untuk mendapatkan user ID

class DetailChatPage extends StatefulWidget {
  const DetailChatPage({super.key});

  @override
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController(); // <-- Baris 8 sudah bersih
  final supabase = Supabase.instance.client;

  // =========================================================
  // LOGIC CHAT
  // =========================================================

  // Fungsi Kirim Pesan
  Future<void> handleSendMessage() async {
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      await chatService.sendMessage(
        message: messageText,
        isFromUser: true,
      );

      _messageController.clear();
      _scrollToBottom();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: alertColor,
            content: const Text("Gagal mengirim pesan."),
          ),
        );
      }
    }
  }

  // Fungsi untuk scroll ke bawah
  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  // =========================================================
  // WIDGETS
  // =========================================================

  Widget chatBubble({required String text, required bool isSender}) {
    final Color bubbleColor = isSender ? const Color(0xff2B2844) : const Color(0xff252836);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.7),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 12 : 0),
            topRight: Radius.circular(isSender ? 0 : 12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
          ),
        ),
        child: Text(text, style: primaryTextStyle),
      ),
    );
  }

  // Widget untuk simulasi mengirim produk (sesuai Figma)
  Widget productPreview() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg2Color,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Produk
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.asset('assets/image_shoes.png', width: 54, height: 54, fit: BoxFit.cover),
          ),
          const SizedBox(width: 10),
          // Detail Produk
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('COURT VISION 2.0', style: primaryTextStyle.copyWith(fontWeight: semiBold), overflow: TextOverflow.ellipsis),
                Text('\$58,67', style: priceTextStyle.copyWith(fontWeight: medium)),
              ],
            ),
          ),
          // Tombol Close
          GestureDetector(
            onTap: () {
              // LOGIC DIBIARKAN KOSONG UNTUK TODO DI MASA DEPAN
            },
            child: Icon(Icons.close, color: primaryTextColor, size: 16),
          ),
        ],
      ),
    );
  }

  // Input dan Send Button di Bottom
  Widget chatInput() {
    return Container(
      margin: EdgeInsets.all(defaultMargin),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 45,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(color: bg2Color, borderRadius: BorderRadius.circular(12)),
              child: Center(
                child: TextFormField(
                  controller: _messageController,
                  style: primaryTextStyle,
                  decoration: InputDecoration.collapsed(hintText: 'Type Message...', hintStyle: subtitleTextStyle),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Tombol Kirim Pesan
          GestureDetector(
            onTap: handleSendMessage,
            child: Image.asset('assets/button_send.png', width: 45, errorBuilder: (context, error, stackTrace) => Icon(Icons.send, color: primaryColor)),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg3Color,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: bg1Color,
          centerTitle: false,
          title: Row(
            children: [
              Image.asset('assets/image_shop_logo.png', width: 50),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shoe Store', style: primaryTextStyle.copyWith(fontSize: 14, fontWeight: medium)),
                  Text('Online', style: secondaryTextStyle.copyWith(fontSize: 10)),
                ],
              ),
            ],
          ),
          elevation: 0,
        ),
      ),
      bottomNavigationBar: chatInput(),
      
      // BODY (Real-time Stream)
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: chatService.getMessagesStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator(color: primaryColor));
          }

          if (snapshot.hasError) {
            return Center(
                child: Text('Error: ${snapshot.error}', style: alertTextStyle));
          }

          final messages = snapshot.data ?? [];

          // Panggil scroll to bottom setiap kali ada pesan baru
          WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToBottom());

          return Container(
            padding: EdgeInsets.symmetric(horizontal: defaultMargin),
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                final bool isSender = message['is_from_user'] ?? true; 
                final String text = message['message'] ?? '';

                // HACK: Logic Product Preview DIBIARKAN KOSONG untuk saat ini, agar tidak error
                if (messages.isEmpty) {
                   return productPreview(); // Tampilkan product preview jika tidak ada pesan
                }

                return chatBubble(text: text, isSender: isSender);
              },
            ),
          );
        },
      ),
    );
  }
}