import 'dart:io';

import 'package:book_app/model/library.dart';
import 'package:book_app/model/network_response.dart';
import 'package:book_app/model/result.dart';
import 'package:book_app/network/book_client.dart';
import 'package:book_app/network/remote_data_source.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';

import 'mock_client.dart';

void main() {
  group("BookRepository", () {
    var client = MockedClient();
    final String baseUrl = "http://127.0.0.1:8888";
    test("Testing successful get request", () async {
      RemoteDataSource apiResponse = RemoteDataSource();
      apiResponse.client = BookClient(client);
      when(client.get("$baseUrl/books")).thenAnswer((_) async =>
          Response(
              '{"bookList": [{"name": "To Kill a Mockingbird","author": "Harper Lee","description": "To Kill a Mockingbird was published in 1960 and became an immediate classic of literature. The novel examines racism in the American South through the innocent wide eyes of a clever young girl named Jean Louise (“Scout”) Finch."}]}',
              200,
              headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));

      expect(
          await apiResponse.getBooks(), isInstanceOf<SuccessState<Library>>());
    });

    test("Testing successful delete request", () async {
      RemoteDataSource apiResponse = RemoteDataSource();
      apiResponse.client = BookClient(client);
      final index = 0;
      when(client.delete("http://127.0.0.1:8888/deleteBook/$index")).thenAnswer(
          (_) async => Response(
                  '{"message": "Book deleted successfully"}', 200, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));

      expect(await apiResponse.deleteBook(index),
          isInstanceOf<SuccessState<NetworkResponse>>());
    });

    test("Testing failed delete request", () async {
      RemoteDataSource apiResponse = RemoteDataSource();
      apiResponse.client = BookClient(client);
      final index = 100;
      when(client.delete("http://127.0.0.1:8888/deleteBook/$index")).thenAnswer(
          (_) async => Response('{"message": "Book not found"}', 404, headers: {
                HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
              }));

      expect(await apiResponse.deleteBook(index),
          isInstanceOf<ErrorState<NetworkResponse>>());
    });
  });
}
