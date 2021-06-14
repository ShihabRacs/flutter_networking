import 'dart:math';

import 'package:book_app/model/library.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:book_app/main.dart' as app;

void main(){
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("full App test", (tester) async{
    app.main();


    final dismissibleElement = find.byType(Text).first;
    final Text lt = tester.widget(dismissibleElement);

    await tester.pumpAndSettle();


    await Future.delayed(const Duration(seconds: 2), (){});
    await tester.tap(dismissibleElement);
    await tester.pumpAndSettle();

    final textField =find.byType(TextField);



    await Future.delayed(const Duration(seconds: 2), (){});

    await tester.enterText(textField.at(1), 'gru'+Random.secure().nextInt(9999).toString());
    await tester.enterText(textField.at(2), 'gru'+Random.secure().nextInt(9999).toString());
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2), (){});




    final floatingActionButton = find.byType(FloatingActionButton);

    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2), (){});
    await tester.tap(floatingActionButton);

    await tester.pumpAndSettle();

    final tb0 = find.byType(TextField).at(0);
    final tb1 = find.byType(TextField).at(1);
    final tb2 = find.byType(TextField).at(2);
    final btn1 = find.byType(ElevatedButton);
    final ElevatedButton elevatedButton2 = tester.widget(btn1) ;
    final bool state2 = elevatedButton2.enabled;


    expect(false,state2);

    await tester.enterText(tb0, 'gru'+Random.secure().nextInt(9999).toString());
    await tester.enterText(tb1, "hello"+'gru'+Random.secure().nextInt(9999).toString());
    await tester.enterText(tb2, "world world!"+'gru'+Random.secure().nextInt(9999).toString());

    await tester.tap(btn1);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2), (){});
    final dismissibleElement2 = find.byType(Text).first;
    final Text lt2 = tester.widget(dismissibleElement2);

    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2), (){});

    await tester.tap(dismissibleElement2);
    await tester.pumpAndSettle();
    await Future.delayed(const Duration(seconds: 2), (){});
    final textField2 =find.byType(TextField);





    await tester.enterText(textField2.at(1), 'gru'+Random.secure().nextInt(9999).toString());
    await tester.enterText(textField2.at(2), 'gru'+Random.secure().nextInt(9999).toString());
    await tester.tap(find.byType(ElevatedButton));
    await tester.pumpAndSettle();

    await Future.delayed(const Duration(seconds: 2), (){});








  });
}