// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:book_app/model/library.dart';
import 'package:book_app/ui/addscreen/add_book_screen.dart';
import 'package:book_app/ui/editscreen/edit_book_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
 group("Button State tester on add books page",(){
   testWidgets("Button should be disabled when one of the text field is empty",
       (WidgetTester tester) async{
     await tester.pumpWidget(MaterialApp(
     home: AddBookScreen(
     )));
     await tester.pump();

     final elevatedButton =find.byType(ElevatedButton);
     expect(elevatedButton, findsOneWidget );

     final ElevatedButton elevatedButton2 = tester.widget(find.byType(ElevatedButton)) ;
     final bool state = elevatedButton2.enabled;

     expect(false, state);

   });
   testWidgets("Button should be enabled when one of the text field is populated",
           (WidgetTester tester) async{
         await tester.pumpWidget(MaterialApp(
             home: AddBookScreen(


             )));
         await tester.pump();

         final textField =find.byType(TextField);
         expect(textField, findsNWidgets(3));
         final  tf1 = find.byType(TextField);
         final TextField tf2 = tester.widgetList(find.byType(TextField)).elementAt(1);
         final TextField tf3 = tester.widgetList(find.byType(TextField)).elementAt(2);

         await tester.enterText(tf1.first, 'Flutter Devs');
         await tester.enterText(tf1.at(1), 'Flutter Devs');
         await tester.enterText(tf1.last, 'Flutter Devs');
         await tester.pump();
         // await tester.pumpWidget(tf4);
         // await tester.enterText(find.text("Book Description"), "desc");


         // await tester.pumpAndSettle();

         final ElevatedButton elevatedButton2 = tester.widget(find.byType(ElevatedButton)) ;
         final bool state2 = elevatedButton2.enabled;

         expect(true, state2);

       });

 });

 group("Button State tester on Edit books page",(){
   Book book = Book(name: "1",author: "1",description: "1");
   int index = 1;
   testWidgets("Button should be enabled when we enter the page",
           (WidgetTester tester) async{
         await tester.pumpWidget(MaterialApp(
             home: EditBookScreen(book, index
                ),
             ));
         await tester.pump();

         final elevatedButton =find.byType(ElevatedButton);
         expect(elevatedButton, findsOneWidget );

         final ElevatedButton elevatedButton2 = tester.widget(find.byType(ElevatedButton)) ;
         final bool state = elevatedButton2.enabled;

         expect(true, state);

       });
   testWidgets("Button should be disabled when one of the text field is cleared",
           (WidgetTester tester) async{
         await tester.pumpWidget(MaterialApp(
             home: AddBookScreen(


             )));
         await tester.pump();

         final textField =find.byType(TextField);
         expect(textField, findsNWidgets(3));

         // await tester.pump();
         final TextField tf = tester.widget(textField.last);

         // await tester.pumpWidget(tf4);
         // await tester.enterText(find.text("Book Description"), "desc");
         await tester.enterText(textField.last, '');

         // await tester.pumpAndSettle();
         await tester.pump();
         final ElevatedButton elevatedButton2 = tester.widget(find.byType(ElevatedButton)) ;
         final bool state2 = elevatedButton2.enabled;

         expect(false, state2);

       });

 });


}
