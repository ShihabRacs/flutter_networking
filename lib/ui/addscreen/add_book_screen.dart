import 'package:book_app/model/library.dart';
import 'package:book_app/model/result.dart';
import 'package:book_app/network/remote_data_source.dart';
import 'package:book_app/ui/common_widget/progress_dialog.dart';
import 'package:flutter/material.dart';

class AddBookScreen extends StatefulWidget {
  @override
  _AddBookScreenState createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  //variables to hold values that is provided in the TextFields
  String _name, _author, _description;

  RemoteDataSource _apiResponse = RemoteDataSource();

  bool isAddEnabled = false;

  @override
  void initState() {
    super.initState();
    _apiResponse.init();
    hasBookAddedListener();
  }

  void hasBookAddedListener() {
    _apiResponse.hasBookAdded().listen((Result result) {
      if (result is LoadingState) {
        showProgressDialog();
      } else if (result is SuccessState) {
        Navigator.pop(context); //close the progress dialog
        Navigator.pop(context); //navigate back to Favorite Book screen
      } else {
        SnackBar(
          content: Text("Unable to add book"),
          duration: Duration(seconds: 2),
        );
      }
    });
  }

  showProgressDialog() => showDialog(context: context, builder: (BuildContext context) => ProgressDialog());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Book"),
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            bookTitleTextField(),
            SizedBox(
              height: 10.0,
            ),
            bookAuthorTextField(),
            SizedBox(
              height: 10.0,
            ),
            bookDescriptionTextField(),
            SizedBox(
              height: 10.0,
            ),
            submitButton(),
          ],
        ),
      ),
    );
  }

  TextField bookTitleTextField() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Book Title",
        labelText: "Title",
      ),
      onChanged: (value) {
        _name = value;
        setButton();
      },
    );
  }

  TextField bookAuthorTextField() {
    return TextField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Book Author",
        labelText: "Author",
      ),
      onChanged: (value) {
        _author = value;
        setButton();
      },
    );
  }

  TextField bookDescriptionTextField() {
    return TextField(

      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Book Description",
        labelText: "Description",
      ),
      onChanged: (value) {
        _description = value;
        setButton();
      },
    );
  }

  void setButton() {
    setState(() {
      if(
      _name.isEmpty||
      _description.isEmpty||
      _author.isEmpty
      ) {
        isAddEnabled = false;
      } else {
        isAddEnabled = true;
      }
    });
  }

  void addApiCall() {
    final book = Book(
        name: _name, author: _author, description: _description);
    _apiResponse.addBook(book);
  }
  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: isAddEnabled ? addApiCall:null,

      child: Text(
        "Add",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
