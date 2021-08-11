import 'package:flutter/material.dart';
import 'package:flutter_app/bot_chat.dart';
import 'package:flutter_app/user_chat.dart';

// userChat과 botChat을 구별하도록 하는 코드
class AllChat extends StatelessWidget {
  final String who;
  final String content;

  const AllChat(this.who, this.content, {Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // 넘어온 who 값이 Bot이면 Bot의 Content를 넘기고,
    // user 가 넘어오면 user의 Content를 넘김
    if (who == "Bot"){
      BotChat newChat = BotChat(content);
      return newChat;
    } else {
      UserChat newChat = UserChat(content);
      return newChat;
    }
  }
}
