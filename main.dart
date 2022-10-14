import 'dart:convert';
import 'package:buscadordegifs/home_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';

const request = "";

void main() {
  runApp(MaterialApp(
      home: HomePage(),
      theme: ThemeData(hintColor: Colors.white),
  ));
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super (key: key);
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Image.network("https://upload.wikimedia.org/wikipedia/commons/thumb/8/82/Giphy-logo.svg/2500px-Giphy-logo.svg.png",
          width: 250, height: 150
        ),
        centerTitle: true,
        backgroundColor: Colors.white12,
      ),
      backgroundColor: Colors.black12,
      body: Column(),
    );
  }
}
