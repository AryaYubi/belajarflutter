import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/services/chat_service.dart';
import 'package:shamo/pages/detail_chat_page.dart';

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
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: primaryColor),
            );
          }

          // Empty state
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _emptyChat();
          }

          final chats = snapshot.data!;

          // Sort by last message time (latest first)
          chats.sort((a, b) {
            final aMessages = a['chats']['chat_messages'] as List;
            final bMessages = b['chats']['chat_messages'] as List;

            if (aMessages.isEmpty || bMessages.isEmpty) return 0;

            final aTime = DateTime.parse(aMessages.last['created_at']);
            final bTime = DateTime.parse(bMessages.last['created_at']);

            return bTime.compareTo(aTime);
          });

          return ListView.builder(
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];
              final chatId = chat['chat_id'];
              final messages = chat['chats']['chat_messages'] as List;

              final lastMessage = messages.isNotEmpty
                  ? messages.last['content']
                  : 'Start chatting';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetailChatPage(chatId: chatId),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        width: 1,
                        color: bg2Color,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/image_shop_logo.png',
                        width: 54,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Shoe Store',
                              style: primaryTextStyle.copyWith(fontSize: 15),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              lastMessage,
                              style: secondaryTextStyle,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Now',
                        style: secondaryTextStyle.copyWith(fontSize: 10),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

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
