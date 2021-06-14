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

  StreamController<Result> _updateBookStream;
  Stream<Result> hasBookUpdated() => _updateBookStream.stream;

  void init() {
    _addBookStream = StreamController();
    _updateBookStream = StreamController();
  }

  Future<Result> getBooks() async {
    try {
      final response = await client.request(requestType: RequestType.GET, path: "/crudapps/api/book.php");
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
    print(book.toJson());
    _addBookStream.sink.add(Result<String>.loading("Loading"));
    try {
      final response = await client.request(
          requestType: RequestType.POST, path: "/crudapps/api/create.php", parameter: book.toJson());
      print(response.statusCode);
      print(response.body.toString());
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

  void updateBook(Book book) async {
    _updateBookStream.sink.add(Result<String>.loading("Loading"));
    String name = book.name;
    try {
      final response = await client.request(
          requestType: RequestType.PUT, path: "/crudapps/api/update.php?name=$name", parameter: book);
      print (book.toJson());
      print(response.body);
      if (response.statusCode == 200) {
        _updateBookStream.sink.add(Result<NetworkResponse>.success(
            NetworkResponse.fromRawJson(response.body)));
      } else {
        _updateBookStream.sink.add(Result.error("Something went wrong"));
      }
    } catch (error) {
      _updateBookStream.sink.add(Result.error("Something went wrong!"));
    }
  }

  Future<Result> deleteBook(Book book) async {
    String name = book.toJson()["name"];
    try {
      final response = await client.request(
          requestType: RequestType.DELETE,path: "/crudapps/api/delete.php?name=$name", parameter: book);
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
