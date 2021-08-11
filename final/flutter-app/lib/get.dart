import "dart:convert";

import "package:http/http.dart" as http;
// 서버에서 값을 넘겨받는 get을 구현한 코드
// 데이터베이스에 값을 넘기거나 받을 때는 반드시 get, post가 필요함
// flutter 단독으로 DB에 값 넘기는 것은 불가능

// 넘겨받을 데이터 타입 정의
class RequestResult{
  bool ok;
  dynamic data;
  RequestResult(this.ok, this.data);
}

// get 구현 부분
Future<RequestResult> http_get(String route, [dynamic data]) async{
  var dataStr = jsonEncode(data);
  // 데이터를 json 타입으로 변환해줌
  // 웹으로 값을 넘길 때는 json 형태의 값만 넘기고 받을 수 있음
  // json 형태의 String도 값이 넘어가지 않기 때문에 꼭 표시해주어야하는 부분
  var url = "http://localhost:3000/get";
  // 지정한 url에서 값을 넘겨받도록 함
  // localhost:3000/get_chat 등과 같이 포트 뒷부분을 따로 지정해줄 수 있음
  // 단, 서버의 get 부분과 동일하게 지정해주어야함
  var result = await http.get(Uri.parse(url));
  // 동기 방식으로 url을 파싱해서 데이터를 받아옴
  return RequestResult(true, jsonDecode(result.body));
  // 해당 함수를 호출받으면 class로 지정해둔 형태에 맞춰서 데이터를 변환하고 return 함
}
