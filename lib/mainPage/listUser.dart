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
            print("BERHASIL GET DATA FIREBASE");
            print(users.asMap());

            return ListView(
              children: users.map(buildUser).toList(),
            );
          } else {
            return const Center(
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
      .collection("narindo")
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => User.fromJson(doc.data())).toList());

  Widget buildUser(User user) => Container(
        width: 328,
        // height: 135,
        margin: EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        child: Card(
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: <Widget>[
              ListTile(
                leading: CircleAvatar(
                  child: Text("${user.description}"),
                ),
                title: Text(user.msisdn),
                subtitle: Text(user.time.toIso8601String()),
              ),
              ListTile(
                leading: CircleAvatar(
                  child: Text("${user.success}"),
                ),
                title: Text(user.title),
                subtitle: Text(user.type),
              ),
            ],
          ),
        ),
      );
}

class User {
  String id;
  final String description;
  final String msisdn;
  final String success;
  final DateTime time;
  final String title;
  final String type;

  // User({
  //   this.id = "",
  //   required this.name,
  //   required this.age,
  //   required this.birthday,
  // });

  User(
      {this.id = "",
      required this.description,
      required this.msisdn,
      required this.success,
      required this.time,
      required this.title,
      required this.type});

  Map<String, dynamic> toJson() => {
        "description": description,
        "msisdn": msisdn,
        "success": success,
        "time": time,
        "title": title,
        "type": type
      };

  static User fromJson(Map<String, dynamic> json) => User(
        description: json['description'],
        msisdn: json['msisdn'],
        success: json['success'],
        time: (json["time"] as Timestamp).toDate(),
        title: json['title'],
        type: json['type'],
      );
}
