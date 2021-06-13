import 'dart:convert';

import 'package:flutter/material.dart';

class Library {
  final List<Book> books;

  Library({this.books});

  factory Library.fromRawJson(String str) =>
      Library.fromJson(json.decode(str));

  // factory Library.fromJson(Map<String, dynamic> json) => Library(
  //     books: List<Book>.from(
  //         json["books"
  //             ""].map((x) => Book.fromJson(x)))
  // );

  factory Library.fromJson(Map<String, dynamic> json) {
    List<Book> books = [];

    for(int i=0; i<json['books'].length; ++i) {
      Book tempBook = Book.fromJson(json['books'][i]);
      books.add(tempBook);
    }
    return Library(books: books);
  }

  Map<String, dynamic> toJson() => {
    "books": List<dynamic>.from(books.map((x) => x.toJson())),
  };

}

class Book {
  final String name;
  final String author;
  final String description;

  Book({this.name, this.author, this.description});

  factory Book.fromJson(Map<String, dynamic> json) =>
      Book(
          name: json["name"],
          author: json["author"],
          description: json["description"]
      );

  Map<String, dynamic> toJson() =>
      {"name": name, "author": author, "description": description};
}
