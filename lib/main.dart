import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() => runApp(UIdesign());

class UIdesign extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'UI design',
      theme: ThemeData.light(),
      home: Prof_Page(),
    );
  }
}

class Prof_Page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final APIkey = "null"; //あなたのAPIキーを入力してください！
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.navigate_before),
        title: Text("prof_data"),
      ),
      body: Center(
        child: FutureBuilder(
            future: _callAPI(APIkey.toString()),
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return CircularProgressIndicator();
              }

              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }

              if (snapshot.hasData) {
                var prof_data = json.decode(snapshot.data.toString());
                var prof_name = (prof_data["avatarUrl"]);
                return Image.network(prof_name);
              } else {
                return const Text("データが存在しません");
              }
            }),
      ),
    );
  }
}

Future<String> _callAPI(String APIkey) async {
  print("API取得中...");
  final url = Uri.parse('https://voskey.icalo.net/api/i');
  final response = await http.post(url,
      body: json.encode({'i': '$APIkey', "detail": false}),
      headers: {
        'Content-Type': 'application/json',
      });
  //var prof_data = response.body;
  print('APIを取得しました。');
  //print(prof_data["name"]);
  return response.body;
}
