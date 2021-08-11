import "dart:convert";

import "package:http/http.dart" as http;

class RequestResult{
  bool ok;
  dynamic data;
  RequestResult(this.ok, this.data);
}

Future<RequestResult> http_get(String route, [dynamic data]) async{
  var dataStr = jsonEncode(data);
  var url = "http://localhost:3000/get";
  var result = await http.get(Uri.parse(url));
  return RequestResult(true, jsonDecode(result.body));
}
