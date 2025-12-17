import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class DetailChatPage extends StatelessWidget {
  const DetailChatPage({super.key});

  @override
<<<<<<< Updated upstream
  Widget build(BuildContext context) {
    Widget chatBubble({required String text, required bool isSender}) {
      return Container(
        margin: const EdgeInsets.only(bottom: 20),
        alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: isSender ? const Color(0xff2B2844) : const Color(0xff252836),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isSender ? 12 : 0),
              topRight: Radius.circular(isSender ? 0 : 12),
              bottomLeft: const Radius.circular(12),
              bottomRight: const Radius.circular(12),
            ),
=======
  State<DetailChatPage> createState() => _DetailChatPageState();
}

class _DetailChatPageState extends State<DetailChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final supabase = Supabase.instance.client;

  // =============================
  // AUTO REPLY (HARUS DI ATAS)
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
    final messageText = _messageController.text.trim();
    if (messageText.isEmpty) return;

    try {
      // USER MESSAGE
      await chatService.sendMessage(
        chatId: widget.chatId,
        message: messageText,
      );

      _messageController.clear();
      _scrollToBottom();

      // AUTO SELLER REPLY
      Future.delayed(const Duration(seconds: 1), () async {
        await supabase.from('chat_messages').insert({
          'chat_id': widget.chatId,
          'sender_id': '54e68357-f6b8-4ba2-a7b3-8da904193961',
          'content': _autoReply(messageText),
        });
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengirim pesan')),
      );
    }
  }


  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
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
  // CHAT BUBBLE
  // =========================================================
  Widget chatBubble({
    required String text,
    required bool isSender,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSender ? bg2Color : bg3Color,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isSender ? 12 : 0),
            topRight: Radius.circular(isSender ? 0 : 12),
            bottomLeft: const Radius.circular(12),
            bottomRight: const Radius.circular(12),
>>>>>>> Stashed changes
          ),
          child: Text(text, style: primaryTextStyle),
        ),
      );
    }

    return Scaffold(
      backgroundColor: bg3Color,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70),
        child: AppBar(
          backgroundColor: bg1Color,
          centerTitle: false,
          title: Row(
            children: [
              Image.asset('assets/image_shop_logo.png', width: 40),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Shoe Store', style: primaryTextStyle.copyWith(fontWeight: medium, fontSize: 14)),
                  Text('Online', style: secondaryTextStyle.copyWith(fontWeight: light, fontSize: 12)),
                ],
              ),
            ],
          ),
          elevation: 0,
        ),
      ),
      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(20),
        child: Row(
          children: [
            Expanded(
              child: Container(
                height: 45,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(color: bg2Color, borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: TextFormField(
                    style: primaryTextStyle,
                    decoration: InputDecoration.collapsed(hintText: 'Type Message...', hintStyle: subtitleTextStyle),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 20),
            Image.asset('assets/button_send.png', width: 45, errorBuilder: (_,__,___) => const Icon(Icons.send, color: Colors.blue)), // Ganti button_send dengan icon_submit.png jika ada
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: defaultMargin),
        children: [
          const SizedBox(height: 30),
          chatBubble(text: "Hi, This item is still available?", isSender: true),
          chatBubble(text: "Good night, This item is only available in size 42 and 43", isSender: false),
        ],
      ),
    );
  }
}