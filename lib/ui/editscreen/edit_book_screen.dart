import 'package:book_app/model/library.dart';
import 'package:book_app/model/result.dart';
import 'package:book_app/network/remote_data_source.dart';
import 'package:book_app/ui/common_widget/progress_dialog.dart';
import 'package:flutter/material.dart';

class EditBookScreen extends StatefulWidget {
  Book book;
  int index;
  
  EditBookScreen(this.book, this.index);
  
  @override
  _EditBookScreenState createState() => _EditBookScreenState();
}

class _EditBookScreenState extends State<EditBookScreen> {
  //variables to hold values that is provided in the TextFields
  TextEditingController nameController = TextEditingController();
  TextEditingController authorController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  bool isUpdateEnabled;

  RemoteDataSource _apiResponse = RemoteDataSource();

  @override
  void initState() {
    super.initState();
    isUpdateEnabled = true;
    nameController.text = widget.book.name;
    authorController.text = widget.book.author;
    descriptionController.text = widget.book.description;
    _apiResponse.init();
    hasBookUpdatedListener();
  }

  void hasBookUpdatedListener() {
    _apiResponse.hasBookUpdated().listen((Result result) {
      if (result is LoadingState) {
        showProgressDialog();
      } else if (result is SuccessState) {
        Navigator.pop(context); //close the progress dialog
        Navigator.pop(context); //navigate back to Favorite Book screen
      } else {
        SnackBar(
          content: Text("Unable to update book"),
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
        title: Text("Edit Book"),
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
      onChanged: (value) {
        setButton();
      },
      controller: nameController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Book Title",
        labelText: "Title",
      ),
    );
  }

  TextField bookAuthorTextField() {
    return TextField(
      onChanged: (value) {
        setButton();
      },
      controller: authorController,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Book Author",
        labelText: "Author",
      ),
    );
  }

  TextField bookDescriptionTextField() {
    return TextField(
      onChanged: (value) {
        setButton();
      },
      controller: descriptionController,
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        hintText: "Book Description",
        labelText: "Description",
      ),
    );
  }

  void setButton() {
    setState(() {
      if(
      nameController.text == '' ||
          authorController.text == '' ||
          descriptionController.text == ''
      ) {
        isUpdateEnabled = false;
      } else {
        isUpdateEnabled = true;
      }
    });
  }

  void updateApiCall() {
    final book = Book(
        name: nameController.text, author: authorController.text, description: descriptionController.text);
    _apiResponse.updateBook(book, widget.index);
  }

  ElevatedButton submitButton() {
    return ElevatedButton(
      onPressed: isUpdateEnabled ? updateApiCall : null,
      child: Text(
        "Update",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}
