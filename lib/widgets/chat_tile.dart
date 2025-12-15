import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/pages/detail_chat_page.dart';

class ChatTile extends StatelessWidget {
  final String chatId;
  final String sellerName;
  final String lastMessage;
  final String timeLabel;

  const ChatTile({
    super.key,
    required this.chatId,
    required this.sellerName,
    required this.lastMessage,
    required this.timeLabel,
  });

  @override
  Widget build(BuildContext context) {
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
        margin: const EdgeInsets.only(top: 20),
        child: Row(
          children: [
            Image.asset('assets/image_shop_logo.png', width: 54),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sellerName,
                    style: primaryTextStyle.copyWith(fontSize: 15),
                  ),
                  Text(
                    lastMessage,
                    style: secondaryTextStyle.copyWith(fontWeight: light),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            Text(
              timeLabel,
              style: secondaryTextStyle.copyWith(fontSize: 10),
            ),
          ],
        ),
      ),
    );
  }
}
