import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:transparent_image/transparent_image.dart';
import 'gif_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search = "";
  int _offset = 0;

  Future<Map> _getGifs() async{
    http.Response response;
    if(_search == ""){
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=o8NCqT4PUwhwLj77yrc647U2bKRkVVWT&limit=25&rating=G"));
    } else{
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=o8NCqT4PUwhwLj77yrc647U2bKRkVVWT&q=$_search&limit=25&offset=$_offset&rating=G&lang=en"));
    }
    return json.decode(response.body);

  }

  int _getCount(List data){
    if (_search == ""){
      return data. length;
    } else {
      return data. length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if (_search == "" || index < snapshot.data["data"].length) {
            return GestureDetector(
            child: FadeInImage.memoryNetwork(
              placeholder: kTransparentImage,
              image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
              height: 300.0,
              fit: BoxFit.cover,
            ),
            onTap: (){
              Navigator.push(context,
                MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index]))
              );
            },
          );
          } else {
            return Container(
            child: GestureDetector(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Icon(Icons.add, color: Colors.white, size: 70.0,),
                  Text("Load More",
                    style: TextStyle(color: Colors.white, fontSize: 22.0)
                  ),
                ],
              ),
            onTap: (){
              setState(() {
                _offset += 25;
              });
            },
            ),
          );
          }
        }
    );
  }

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
      body: Stack(
        children: <Widget>[
          const Image(
            image: AssetImage('images/galaxy.png'),
            alignment: Alignment.center,
            height: double.infinity,
            width: double.infinity,
            fit: BoxFit.fill,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: const InputDecoration(
                    labelText: "Pesquise Aqui",
                    labelStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder()
                ),
                onSubmitted: (text){
                  setState(() {
                    _search = text;
                  });
                },
                style: const TextStyle(color: Colors.white, fontSize: 10.0),
                textAlign: TextAlign.center ,
              ),
            ),
            Expanded(
              child: FutureBuilder(
                  future: _getGifs(),
                  builder: (context, snapshot){
                    switch(snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Container(
                            width: 200.0,
                            height: 200.0,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 5.0,
                            )
                        );
                      default:
                        if(snapshot.hasError)
                          return Container();
                        else {
                          return _createGifTable(context, snapshot);
                        }
                    }
                  }
              ),
            ),
            ],
          ),
        ],
      ) ,
    );
  }
}