import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OpenSaturday Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'OpenSaturday Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<dynamic> usuarios = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  Future<Null> obtenerData() async {
    var res = await http.get("https://reqres.in/api/users");
    print(res.body);
    var json = jsonDecode(res.body);
    setState(() {
      usuarios = json['data'];
    });
  }

  Widget avatar({
    String firstname,
    String image,
  }) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(firstname),
          Hero(
            tag: firstname,
            child: Image.network(image),
          ),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    obtenerData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            ...usuarios.map((usuario) {
              return RaisedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AvatarDetalle(
                              firstName: usuario['first_name'],
                              image: usuario['avatar'],
                            )),
                  );
                },
                child: avatar(
                  firstname: usuario['first_name'],
                  image: usuario['avatar'],
                ),
              );
            }).toList()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          this.obtenerData();
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class AvatarDetalle extends StatelessWidget {
  const AvatarDetalle({
    Key key,
    this.firstName,
    this.image,
  }) : super(key: key);
  final String firstName;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Container(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(firstName),
                Center(
                  child: Hero(
                    tag: firstName,
                    child: Image.network(image),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
