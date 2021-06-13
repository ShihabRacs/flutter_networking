import 'dart:async';

import 'package:book_app/network/book_client.dart';
import 'package:http/http.dart';

import '../model/library.dart';
import '../model/network_response.dart';
import '../model/result.dart';
import '../util/request_type.dart';

class RemoteDataSource {
  //Creating Singleton
  RemoteDataSource._privateConstructor();
  static final RemoteDataSource _apiResponse = RemoteDataSource._privateConstructor();
  factory RemoteDataSource() => _apiResponse;

  BookClient client = BookClient(Client());

  StreamController<Result> _addBookStream;
  Stream<Result> hasBookAdded() => _addBookStream.stream;

  void init() => _addBookStream = StreamController();

  Future<Result> getBooks() async {
    try {
      final response = await client.request(requestType: RequestType.GET, path: "books");
      if (response.statusCode == 200) {
        return Result<Library>.success(Library.fromRawJson(response.body));
      } else {
        return Result.error("Book list not available");
      }
    } catch (error) {
      print(error);

      return Result.error("Something went wrong!");
    }
  }

  void addBook(Book book) async {
    _addBookStream.sink.add(Result<String>.loading("Loading"));
    try {
      final response = await client.request(
          requestType: RequestType.POST, path: "books", parameter: book);
      if (response.statusCode == 200) {
        _addBookStream.sink.add(Result<NetworkResponse>.success(
            NetworkResponse.fromRawJson(response.body)));
      } else {
        _addBookStream.sink.add(Result.error("Something went wrong"));
      }
    } catch (error) {
      _addBookStream.sink.add(Result.error("Something went wrong!"));
    }
  }

  Future<Result> deleteBook(int index) async {
    try {
      final response = await client.request(
          requestType: RequestType.DELETE, path: "books/$index");
      if (response.statusCode == 200) {
        return Result<NetworkResponse>.success(
            NetworkResponse.fromRawJson(response.body));
      } else {
        return Result<NetworkResponse>.error(
            NetworkResponse.fromRawJson(response.body));
      }
    } catch (error) {
      return Result.error("Something went wrong!");
    }
  }

  void dispose() => _addBookStream.close();
}
