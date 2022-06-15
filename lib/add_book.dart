import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rentales_books/all_books.dart';

class addBook extends StatefulWidget {
  @override
  State<addBook> createState() => _addBookState();
}

class _addBookState extends State<addBook> {
  CollectionReference books = FirebaseFirestore.instance.collection('books');

  static String? userUid;

  TextEditingController IDController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();
  TextEditingController yearController = new TextEditingController();
  TextEditingController typeController = new TextEditingController();

  int _BooksCounter = 0;
  int _RentedBooksCounter = 0;
  int _ExchangedBooksCounter = 0;
  int _doesExist = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rentales Add Book"),
      ),
      body: Container(
          padding: EdgeInsets.all(40.0),
          child: Center(
            child: Column(
              children: [
                TextFormField(
                    controller: IDController,
                    decoration: InputDecoration(hintText: "Book ID")),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(hintText: "Book name")),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                    controller: authorController,
                    decoration: InputDecoration(hintText: "Book author")),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                    controller: yearController,
                    decoration: InputDecoration(hintText: "Published year")),
                SizedBox(
                  height: 10.0,
                ),
                TextFormField(
                    controller: typeController,
                    decoration: InputDecoration(hintText: "Rented/Exchanged")),
                SizedBox(
                  height: 10.0,
                ),
                Row(children: [
                  //MainAxisAlignment: MainAxisAlignment.center,
                  Column(children: [
                    FlatButton(
                        onPressed: () {
                          addBook();
                        },
                        child: Text('Add Book'),
                        color: Colors.teal),
                    FlatButton(
                        onPressed: () {
                          getRented();
                        },
                        child: Text('Rented Books'),
                        color: Colors.teal),
                    FlatButton(
                        onPressed: () async {
                          deleteBook();
                        },
                        child: Text('Delete Book by ID'),
                        color: Colors.teal),
                  ]),

                  SizedBox(
                    width: 20.0,
                  ),
                  Column(children: [
                    FlatButton(
                        onPressed: () async {
                          getBooks();
                        },
                        child: Text('Get Books'),
                        color: Colors.teal),
                    FlatButton(
                        onPressed: () {
                          getExchanged();
                        },
                        child: Text('Exchanged Books'),
                        color: Colors.teal),
                    FlatButton(
                        onPressed: () async {
                          updateBook();
                        },
                        child: Text('Update Book by ID'),
                        color: Colors.teal),
                  ]),
                ]),
                FlatButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => allBooks()));
                    },
                    child: Text('All Books'),
                    color: Colors.teal),
              ],
            ),
          )),
    );
  }

  Future<void> addBook() async {
    //QuerySnapshot querySnapshot = await books.get();
    doesNameAlreadyExist(nameController.text);
    if (_doesExist > 0) {
      print('This book already exists');
      _doesExist = 0;
    } else {
      Map<String, dynamic> data = {
        "name": nameController.text,
        "author": authorController.text,
        "year": yearController.text,
        "type": typeController.text,
      };
      return books
          .add(data)
          .then((value) => print("Book Added"))
          .catchError((error) => print("Failed to add Book: $error"));
    }
  }

  Future<void> doesNameAlreadyExist(String name) async {
    await books.where('name', isEqualTo: name).get().then((value) {
      for (var element in value.docs) {
        _doesExist++;
      }
    });
  }

  Future<void> getBooks() async {
    QuerySnapshot querySnapshot = await books.get();

    print('List of All Books:');
    for (var querySnapshot in querySnapshot.docs) {
      print(querySnapshot.data());
      _BooksCounter++;
    }
    print('Number of Books in Database = ' + _BooksCounter.toString());
    print('=========================================================');
    _BooksCounter = 0;
  }

  Future<void> getRented() async {
    print('List of Rented Books:');
    await books.where('type', isEqualTo: 'Rented').get().then((value) {
      for (var element in value.docs) {
        print(element.data());
        _RentedBooksCounter++;
      }
    });
    print('Number of Rented Books = ' + _RentedBooksCounter.toString());
    print('=========================================================');
    _RentedBooksCounter = 0;
  }

  Future<void> getExchanged() async {
    print('List of Exchanged Books:');
    await books.where('type', isEqualTo: 'Exchanged').get().then((value) {
      for (var element in value.docs) {
        print(element.data());
        _ExchangedBooksCounter++;
      }
    });
    print('Number of Exchanged Books = ' + _ExchangedBooksCounter.toString());
    print('=========================================================');
    _ExchangedBooksCounter = 0;
  }

  Future<void> getBook() async {
    return books
        .doc(IDController.text)
        .get()
        .then((snapshot) => snapshot.data()!);
  }

  Future<void> deleteBook() {
    return books
        .doc(IDController.text)
        .delete()
        .then((value) => print("Book Deleted"))
        .catchError((error) => print("Failed to delete Book: $error"));
  }

  Future<void> updateBook() {
    return books
        .doc('rcpoBjhfOxB0o1KRVRq1')
        .update({
          'name': nameController,
          'author': authorController,
          'year': yearController,
          'type': typeController,
        })
        .then((value) => print("Book Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }

  @override
  void initState() {
    getBooks();
    super.initState();
  }
}
