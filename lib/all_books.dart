import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class allBooks extends StatefulWidget {
  @override
  State<allBooks> createState() => _allBooksState();
}

class _allBooksState extends State<allBooks> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Books in Database'),
      ),
      body: Container(
          padding: EdgeInsets.all(40.0),
          child: StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('books').snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Text("No Data");
                }
                return ListView(
                  children:
                      (snapshot.data! as QuerySnapshot).docs.map((document) {
                      
                    return Text('Book Name: ' + document['name']+'\n' +'Book Author: ' + document['author']+'\n'+'Published Year: ' + document['year']+'\n'+'Rented/Exchanged: ' + document['type']+'\n'+'\n');
                  }).toList(),
                );
              })),
    );
  }
}
