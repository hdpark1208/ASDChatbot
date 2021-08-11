import "dart:convert";

import "package:http/http.dart" as http;
// post 부분을 구현한 코드

// 값의 형태를 정의해 둔 부분
class PostChat {
  // final String who;
  final bool ok;
  final String Content;

  PostChat({
    required this.ok,
    required this.Content
  });

  factory PostChat.fromJSON(Map<bool, dynamic> json) {
    return PostChat(
      ok: json['ok'],
        Content: json['Content']
    );
  }
}

// post 를 구현한 코드
Future<PostChat> http_post(content) async{
  // 지정한 url을 파싱하고, body에서 값을 넘겨받음
  final response = await http.post(
    Uri.parse("http://localhost:3000/post"),
    body: <String, String>{"content":content}
  );


  // 테스트 부분에 넘겨온 url 의 body를 문자열 형태로 변환하고
  // 그 값을 json으로 디코딩함
  var test = jsonDecode(response.body.toString());
//   print(test);
//   print(test["status"]);
  
  // 지정한 값들을 class에 보내고 다시 넘어온 값을 함수를 호출한 부분에 리턴해줌
  return PostChat(ok:true, Content:test["status"]);
}

