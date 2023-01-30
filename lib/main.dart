import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_field/date_field.dart';
import 'package:firebase_flutter/mainPage/listUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:intl/intl.dart'; //for date format
import 'package:intl/date_symbol_data_local.dart'; //for date locale

// void main() {
//   runApp(const MyApp());
// }

// ignore_for_file: prefer_const_constructors

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  final controllerName = TextEditingController();
  final controllerAge = TextEditingController();
  final controllerDate = TextEditingController();

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add User"),
        // actions: [
        //   IconButton(
        //       onPressed: () {
        //         final name = controller.text;
        //         createUser(name: name);
        //       },
        //       icon: Icon(Icons.add))
        // ],
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          // onPressed: () => Navigator.of(context).pop(),
          onPressed: () {
            print("ini buat navigate ke list user");
            Navigator.push(
                context, MaterialPageRoute(builder: (bc) => ListUser()));
          },
        ),

        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: <Widget>[
          TextField(
            controller: controllerName,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Name",
            ),
          ),
          SizedBox(
            height: 24,
          ),
          TextField(
            controller: controllerAge,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Number",
            ),
            keyboardType: TextInputType.number,
          ),
          SizedBox(
            height: 24,
          ),
          TextField(
            readOnly: true,
            onTap: _selectDate,
            controller: controllerDate,
          ),
          SizedBox(
            height: 24,
          ),
          ElevatedButton(
            child: Text("Create"),
            onPressed: () {
              final user = User(
                name: controllerName.text,
                age: int.parse(controllerAge.text),
                birthday: DateTime.parse(controllerDate.text),
              );
              createUser(user);
              // Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }

  DateTime dateTime = DateTime.now();

  _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: dateTime,
        initialDatePickerMode: DatePickerMode.day,
        firstDate: DateTime.now(),
        lastDate: DateTime(2101));
    if (picked != null) {
      dateTime = picked;
      //assign the chosen date to the controller
      controllerDate.text = DateFormat("yyyy-MM-dd").format(dateTime);
    }
  }

  Future createUser(User user) async {
    // final docUser = FirebaseFirestore.instance.collection("users").doc("my-id");

    final docUser = FirebaseFirestore.instance.collection("users");

    // final json = {
    //   "name": name,
    //   "age": 21,
    //   "birthday": DateTime(2001, 7, 28),
    // };

    // final user = User(
    //   id: docUser.id,
    //   name: name,
    //   age: 21,
    //   birthday: DateTime(2001, 7, 28),
    // );

    user.id = docUser.id;

    final json = user.toJson();

    await docUser.add(json);
  }
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
}
