import 'package:flutter/material.dart';

// Bot의 채팅 인터페이스를 구현한 코드 
// txt를 넘겨받았을 때, 해당 값을 어떻게 보여줄지에 대한 내용이 들어있음
class BotChat extends StatelessWidget {
  final String txt;

  const BotChat(this.txt, {Key? key, }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      // symetric : 상하, 혹은 좌우로 여백을 지정해줄 수 있음
      // vertical : 상하, horizontal : 좌우
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Container(
        // 컨테이너 박스를 만들고 색상을 지정해주었음
        decoration: BoxDecoration(color: Colors.lightGreen[300]),
        child: Padding(
          // 컨테이너 박스 내부 패딩을 지정함
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: Row(
            // Row로 생성한 부분들이 들어가게 함
            // 추가로 인터페이스적인 측면의 코드를 넣으면 아래로 붙지 않고 옆으로 붙음
            children: [
              // 동그란 아바타 인터페이스
              // 색상과 안에 들어가는 텍스트 값을 지정해주었음
              // 아이콘을 넣을수도 있음
              CircleAvatar(
                  backgroundColor: Colors.lightGreen,
                  child: Text("B")
              ),
              // width를 지정하는 곳
              SizedBox(
                width: 16,
              ),
              Expanded(
                child: Column(
                  // 새로 추가한 부분이 Column 형태로 들어가도록 함
                  // 아래로 값이 붙음
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Bot이라는 텍스르를 넣어 화면에 표시
                    Text(
                      "Bot",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    // 상하 패딩지정
                    Padding(padding: EdgeInsets.symmetric(vertical: 2)),
                    // 넘겨받은 txt를 넣어 화면에 표시
                    Text(txt)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
