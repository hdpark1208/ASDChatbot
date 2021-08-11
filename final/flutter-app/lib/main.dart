import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/all_chat.dart';
import 'package:flutter_app/bot_chat.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/post.dart';
import 'package:flutter_app/postTest.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/user_chat.dart';
import 'package:logger/logger.dart';

void main() {
  runApp(
      MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.lightGreen,
        ),
        home: HomePage(),
      )
  );
}

// -------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
            color: Colors.lightGreen),
        child: Center(
          child: IconButton(
              icon: Icon(
                Icons.arrow_forward_ios,
                color: Colors.white
                // size: 80,
              ),
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => BasePage()));
              }),
        ),
      ),
    );
  }
}

// -------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------
// -------------------------------------------------------------------------------------------------------------

class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  TextEditingController _textEditingController = TextEditingController();

  List<UserChat> _chats = [];
  List<AllChat> allChat = [];
  // List<GetChat> getChat = [];
  List<Chat> chat = [];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat Bot"),
        leading: IconButton(onPressed: () {
          Navigator.pop(context);
        },
          icon: Icon(Icons.arrow_back_ios_outlined),
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: ListView.builder(
                  reverse: true,
                  itemBuilder: (context, index) {
                    return allChat[index];
                  },
                  itemCount: allChat.length)
          ),
          Container(
            // decoration: BoxDecoration(color: Colors.lightGreen[800]),
            padding: EdgeInsets.only(left: 8.0, right: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                      controller: _textEditingController,
                      decoration: InputDecoration(hintText: "메세지를 입력하세요"),
                      onSubmitted: _handleSubmitted,
                      autofocus: true
                  ),
                ),
                SizedBox(width: 8.0),
                FlatButton(
                  // height: Theme.of(context).buttonTheme.height,
                    onPressed: () {
                      _handleSubmitted(_textEditingController.text);
                    },
                    child: Icon(Icons.send),
                    color: Colors.lightGreen[800],
                    height: 48.0)

              ],
            ),
          ),
        ],
      ),
    );
  }


  void _handleSubmitted(String text) async {
    // print(text);
    Logger().d(text);
    _textEditingController.clear();

    http_post(text);
    //
    // var getUrl = Uri.parse("http://localhost:3000/get");
    final result = await http_get("get");
    // Logger().d(json.decode(response.body));
    setState(() {
      allChat.clear();
      var in_chat = result.data as List<dynamic>;
      in_chat.forEach((in_chat) {
        allChat.add(AllChat(
            in_chat["Who"],
            in_chat["Content"]
        ));
      });
    });

    Logger().d(allChat);
  }
}


class Chat {
  final String Who;
  final String Content;

  Chat(this.Who, this.Content);
}
