import 'package:flutter/material.dart';
import 'package:shamo/theme.dart';
import 'package:shamo/widgets/chat_tile.dart';

class ChatPage extends StatelessWidget {
  const ChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: bg1Color,
          centerTitle: true,
          title: Text('Message Support', style: primaryTextStyle.copyWith(fontSize: 18, fontWeight: medium)),
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        Expanded(
          child: Container(
            width: double.infinity,
            color: bg3Color,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: defaultMargin),
              children: const [
                ChatTile(),
              ],
            ),
          ),
        ),
      ],
    );
  }
}