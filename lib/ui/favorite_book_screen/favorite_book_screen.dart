import 'package:book_app/model/library.dart';
import 'package:book_app/model/result.dart';
import 'package:book_app/network/remote_data_source.dart';
import 'package:book_app/ui/addscreen/add_book_screen.dart';
import 'package:book_app/ui/editscreen/edit_book_screen.dart';
import 'package:flutter/material.dart';

class FavoriteBooksScreen extends StatefulWidget {
  @override
  _FavoriteBooksScreenState createState() => _FavoriteBooksScreenState();
}

class _FavoriteBooksScreenState extends State<FavoriteBooksScreen> {
  RemoteDataSource _apiResponse = RemoteDataSource();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Favorite Books"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddBookScreen()),
          ).then((value) {
            if (value) {
              final snackBar = SnackBar(
                content: Text("Add Success"),
                duration: Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });
        },
        child: Icon(Icons.add),
      ),
      body: Center(
        child: FutureBuilder(
            future: _apiResponse.getBooks(),
            builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
              if (snapshot.data is SuccessState) {
                Library bookCollection = (snapshot.data as SuccessState).value;
                return ListView.builder(
                    itemCount: bookCollection.books.length,
                    itemBuilder: (context, index) {
                      return bookListItem(index, bookCollection, context);
                    });
              } else if (snapshot.data is ErrorState) {
                String errorMessage = (snapshot.data as ErrorState).msg;
                return Text(errorMessage);
              } else {
                return CircularProgressIndicator();
              }
            }),
      ),
    );
  }

  Dismissible bookListItem(
      int index, Library bookCollection, BuildContext context) {
    return Dismissible(
      onDismissed: (direction) async {
        Result result = await _apiResponse.deleteBook(index);
        if (result is SuccessState) {
          setState(() {
            bookCollection.books.removeAt(index);
          });
        }
      },
      background: Container(
        color: Colors.red,
      ),
      key: Key(bookCollection.books[index].name),
      child: ListTile(
        leading: Image.asset("images/book.png"),
        title: Text(bookCollection.books[index].name),
        subtitle: Text(
          bookCollection.books[index].description,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: Theme.of(context).textTheme.caption,
        ),
        isThreeLine: true,
        trailing: Text(
          bookCollection.books[index].author,
          style: Theme.of(context).textTheme.caption,
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EditBookScreen(bookCollection.books[index], 100)), // Hardcoded index 100 because the mock server is set to receive only id 100
          ).then((value) {
            if (value) {
              final snackBar = SnackBar(
                content: Text("Update Success"),
                duration: Duration(seconds: 2),
              );
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            }
          });
        },
      ),
    );
  }
}
