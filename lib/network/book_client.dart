

import 'dart:convert';

import 'package:http/http.dart';
import 'package:meta/meta.dart';

import '../util/nothing.dart';
import '../util/request_type.dart';
import '../util/request_type_exception.dart';

class BookClient {
  //Base url
  static const String _baseUrl = "http://10.0.2.2";
  final Client _client;

  BookClient(this._client);

  Future<Response> request({@required RequestType requestType, @required String path, dynamic parameter = Nothing}) async {
    switch (requestType) {
      //
      case RequestType.GET:
        return _client.get("$_baseUrl/$path");
      case RequestType.POST:
        return _client.post("$_baseUrl/$path",
            headers: {"Content-Type": "application/json"}, body: json.encode(parameter));
      case RequestType.PUT:
        return _client.put("$_baseUrl/$path",
            headers: {"Content-Type": "application/json"}, body: json.encode(parameter));
      case RequestType.DELETE:
        return _client.delete("$_baseUrl/$path");
      default:
        return throw RequestTypeNotFoundException("The HTTP request mentioned is not found");
    }
  }
}
