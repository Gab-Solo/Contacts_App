import 'package:contacts_app/ui/contacts_list/contacts_list_page.dart';
import 'package:contacts_app/ui/model/contacts_model.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // Scoped model will make sure that we can access the ContactsModel
    // anywhere down the widget tree. This is possible because of Flutter's
    // InheritedWidget which is a bit advanced to briefly explain, but if you
    // have the drive to learn about it, official Flutter docs can help you.
    return ScopedModel(
      //  Loads all contacts from the database as soon as the app starts
      model: ContactsModel()..loadContacts(),
      child: MaterialApp(
        title: 'Contacts',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: ContactsListPage(),
      ),
    );
  }
}
