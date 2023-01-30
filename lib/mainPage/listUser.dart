import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_flutter/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ListUser extends StatefulWidget {
  @override
  State<ListUser> createState() => _ListUserState();
}

class _ListUserState extends State<ListUser> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List All User"),
      ),
      body: StreamBuilder(
        stream: readUsers(),
        builder: ((context, snapshot) {
          if (snapshot.hasError) {
            return Text("Something when wrong! $snapshot");
          } else if (snapshot.hasData) {
            final users = snapshot.data!;

            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (bc) => MyApp()));
        },
      ),
    );
  }

  Stream<List<User>> readUsers() => FirebaseFirestore.instance
      .collection("users")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());
  // snapshot.docs.map((doc) => User.toJson(doc.data())).toList());

  Widget buildUser(User user) => ListTile(
        leading: CircleAvatar(
          child: Text("${user.age}"),
        ),
        title: Text(user.name),
        subtitle: Text(user.birthday.toIso8601String()),
      );
}

class User {
  String id;
  final String name;
  final int age;
  final DateTime birthday;

  User({
    this.id = "",
    required this.name,
    required this.age,
    required this.birthday,
  });

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "age": age,
        "birthday": birthday,
      };
  static User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        age: json['age'],
        birthday: (json["birthday"] as Timestamp).toDate(),
      );
}
