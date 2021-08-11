import 'package:flutter/material.dart';
import 'package:flutter_app/bot_chat.dart';
import 'package:flutter_app/user_chat.dart';

class AllChat extends StatelessWidget {
  // final int idx;
  final String who;
  final String content;

  const AllChat(this.who, this.content, {Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (who == "Bot"){
      BotChat newChat = BotChat(content);
      return newChat;
    } else {
      UserChat newChat = UserChat(content);
      return newChat;
    }
  }
}
