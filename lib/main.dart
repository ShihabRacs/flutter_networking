
import 'package:book_app/model/library.dart';
import 'package:flutter/material.dart';
import 'ui/favorite_book_screen/favorite_book_screen.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FavoriteBooksScreen(),
    );
  }
}
