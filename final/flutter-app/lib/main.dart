import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_app/all_chat.dart';
import 'package:flutter_app/bot_chat.dart';
import 'package:flutter_app/http.dart';
import 'package:flutter_app/post.dart';
import 'package:mysql1/mysql1.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_app/user_chat.dart';
import 'package:logger/logger.dart';
// 코드들이 넘어와 실제로 동작하는 부분. 메인.

// 생성한 인터페이스의 타이틀 지정 및 색상 지정
// home 부분에 생성된 페이지가 홈 페이지
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

// 처음 실행하면 보이는 페이지부분
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
              // 위에 지정해둔 아이콘 버튼이 눌리면 BasePage로 화면이 넘어가게 함
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

// 채팅 인터페이스가 실질적으로 구현되어있는 코드
class BasePage extends StatefulWidget {
  const BasePage({Key? key}) : super(key: key);

  @override
  State<BasePage> createState() => _BasePageState();
}

class _BasePageState extends State<BasePage> {
  // 입력을 받을 수 있도록 하는 
  TextEditingController _textEditingController = TextEditingController();

  // 채팅들이 담기는 리스트
  List<UserChat> _chats = [];
  List<AllChat> allChat = [];
  // List<GetChat> getChat = [];
  List<Chat> chat = [];



  // 인터페이스적인 측면
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
                  // 버튼 눌리면 입력 받은 텍스트의 값을 지정한 함수에 넘김
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


  // 텍스트 값이 넘어오면 동작하는 함수 동기방식
  void _handleSubmitted(String text) async {
    // print(text);
    // 넘어온 텍스트 로그 보는 코드
    // 없어도 괜찮지만, 값을 보기 용이함
    Logger().d(text);
    // 텍스트 창을 clear 하는 코드
    _textEditingController.clear();

    // 다른 모듈에서 만들어둔 http_post 함수를 실행하고
    // 텍스트 컨트롤러에서 넘겨받은 text값을 함수에 넘겨줌
    http_post(text);
    
    // 함수에 "get"이라는 부분을 넘겨주고 result를 넘겨받음
    // "get"은 실질적으로 함수 내에서 구현해둔 것이 없어서 넘겨주지 않아도 되는 인자임
    // http_get에서 함수를 보면 "get"이 아무런 역할도 하지 않음을 알 수 있음
    final result = await http_get("get");
    // Logger().d(json.decode(response.body));
    
    // 상태를 업데이트 해주는 코드
    setState(() {
      // allChat 이라는 위쪽에 구현해둔 리스트를 초기화
      allChat.clear();
      // in_chat에 get으로 넘겨받은 값의 data 부분을 리스트 형식으로 넣어둠
      var in_chat = result.data as List<dynamic>;
      // allChat에 in_chat에 들어있는 각각의 who와 content 부분을 담음
      in_chat.forEach((in_chat) {
        allChat.add(AllChat(
            in_chat["Who"],
            in_chat["Content"]
        ));
      });
    });

    // 로그 보여줌
    Logger().d(allChat);
  }
}

// 실질적으로 사용하지 않았던 부분 같음
// Chat에서 지정한 형태로 데이터들을 담아두는 코드임
class Chat {
  final String Who;
  final String Content;

  Chat(this.Who, this.Content);
}
