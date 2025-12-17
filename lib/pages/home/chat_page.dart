import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/services/chat_service.dart';
import 'package:shamo/widgets/chat_tile.dart'; // ✅ TAMBAH INI

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg1Color,
      appBar: AppBar(
        backgroundColor: bg1Color,
        centerTitle: true,
        title: Text(
          'Message Support',
          style: primaryTextStyle.copyWith(
            fontSize: 18,
            fontWeight: medium,
          ),
        ),
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: chatService.getMyChats(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          final chats = snapshot.data!;

          if (chats.isEmpty) return _emptyChat(); // ✅ FIX

         return ListView.builder(
  padding: EdgeInsets.all(defaultMargin),
  itemCount: chats.length,
  itemBuilder: (context, index) {
    final chat = chats[index];
    final messages = chat['chats']['chat_messages'];

    final lastMessage = messages.isNotEmpty
        ? messages.last['content']
        : 'Start chatting';

    return ChatTile(
      chatId: chat['chat_id'],
      sellerName: 'Shoe Store',
      lastMessage: lastMessage,
      timeLabel: 'Now',
    );
  },
);
        },
      ),
    );
  }

  // =============================
  // EMPTY CHAT
  // =============================
  Widget _emptyChat() {
    return Container(
      color: bg3Color,
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon_chat.png', width: 80),
          const SizedBox(height: 20),
          Text(
            'Oops no message yet?',
            style: primaryTextStyle.copyWith(
              fontSize: 16,
              fontWeight: medium,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Start a chat from a product',
            style: secondaryTextStyle,
          ),
        ],
      ),
    );
  }
}
