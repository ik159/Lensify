import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

void main() => runApp(Votes());

class Votes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage> {
  List<Widget> makelistwidget(AsyncSnapshot snapshot) {
    return snapshot.data.documents.map<Widget>((document) {
      return Padding(
          padding: EdgeInsets.all(10.0),
          child: Container(
              padding: EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: ListTile(
                title: Text(document['name']),
                trailing: Text(document['votes'].toString()),
                onTap: () {
                  document.reference
                      .updateData({'votes': FieldValue.increment(1)});
                },
              )));
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return  Container(
        child: StreamBuilder(
          stream: Firestore.instance.collection('user').snapshots(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return Center(
                  child: CircularProgressIndicator(),
                );
              default:
                return ListView(
                  children: makelistwidget(snapshot),
                );
            }
          },
        ),
      );
  }
}