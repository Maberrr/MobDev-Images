import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ImageModel {
  int id;
  String url;
  String title;

  ImageModel(this.id, this.url, this.title);
  
  ImageModel.fromJson(Map<String, dynamic> parsedJson){
    id = parsedJson['id'];
    url = parsedJson['url'];
    title = parsedJson['title'];
  }
}

class App extends StatefulWidget{
  createState(){
    return AppState();
  }
}

class AppState extends State<App>{
  int counter = 0;

  Future<List<ImageModel>> fetchImage() async {
    var response = await http.get('https://jsonplaceholder.typicode.com/photos/');
    var decodedResponse = json.decode(response.body);

    List<ImageModel> images = [];

    for(var i in decodedResponse){
      ImageModel image = ImageModel(i['id'], i['url'], i['title']);
      images.add(image);
    }
    return images;
  }

  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        appBar : AppBar(
          title: Text("Click the button to see images!")
        ),
        body: Container(
          child: Center(
            child: FutureBuilder(
              future: fetchImage(),
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return ListView.builder(
                  itemCount: counter,
                  itemBuilder: (BuildContext context, int index){
                    return ListTile(
                      title: Image.network(
                        snapshot.data[index].url
                      ),
                      subtitle: Text(snapshot.data[index].title),
                      contentPadding: EdgeInsets.symmetric(horizontal: 25.0, vertical: 15.0),
                    );
                  },
                );
              }
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            setState((){
              counter++;
            });
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

