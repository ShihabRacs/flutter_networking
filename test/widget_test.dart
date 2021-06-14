// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:book_app/main.dart';
import 'package:book_app/model/library.dart';
import 'package:book_app/ui/favorite_book_screen/favorite_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  List<Book> smallbook = List.generate(2, (index) => Book(name: "$index",author: "$index", description: "$index"));
  Library library =Library(books: smallbook);
  group("testing scrollable list of books", (){
    testWidgets("should not scroll with less items", (WidgetTester tester) async{
      await tester.pumpWidget(MaterialApp(
          home: FavoriteBooksScreen(),
      ));
    });
  });
}
