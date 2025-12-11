import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';

class DetailChatPage extends StatelessWidget {
  const DetailChatPage({super.key});

  @override
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
            // Perbaikan: Mengganti __ dan ___ dengan _ yang jelas
            Image.asset('assets/button_send.png', width: 45, errorBuilder: (context, error, stackTrace) => const Icon(Icons.send, color: Colors.blue)), 
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