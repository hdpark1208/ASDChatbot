import "dart:convert";

import "package:http/http.dart" as http;

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

const PROTOCOL = "http";
const DOMAIN = "localhost:3000";

Future<PostChat> http_post(content) async{
  print("http_post TESTS~!~!~!~!~!!");
  final response = await http.post(
    Uri.parse("http://localhost:3000/post"),
    body: <String, String>{"content":content}
  );


  var test = jsonDecode(response.body.toString());
  print(test);
  print(test["status"]);
  return PostChat(ok:true, Content:test["status"]);
}

