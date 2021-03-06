import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:soul_train/models/Train.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final myController = TextEditingController();
  Autogenerated _result;

  Future<Autogenerated> fetchData() async {
    var url = Uri.parse(
        'http://swopenapi.seoul.go.kr/api/subway/sample/json/realtimeStationArrival/0/5/%EB%8F%99%EB%8C%80%EB%AC%B8');
    var response = await http.get(url);

    Autogenerated result = Autogenerated.fromJson(json.decode(response.body));

    return result;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      drawer: Drawer(
        child: Container(
          color: Colors.black54,
          child: ListView(
            padding: EdgeInsets.only(top: 0.0),
            children: <Widget>[
              ListTile(
                title: Text('Dashboard'),
              ),
              ListTile(
                title: Text('Submit Reports'),
              ),
              ListTile(
                title: Text('Inbox Requests'),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        leading: IconButton(icon: Icon(Icons.menu), onPressed: () {}),
        actions: <Widget>[
          //    IconButton(icon: Icon(Icons.search), onPressed: () {}),
          IconButton(icon: Icon(Icons.help), onPressed: () {}),
        ],
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 0.0, 15.0, 16.0),
            child: Container(
              margin: EdgeInsets.only(left: 16.0),
              child: TextField(
                decoration: new InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          debugPrint('222');
                          fetchData().then((result) {
                            setState(() {
                              _result = result;
                            });
                          });
                        }),
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(50.0),
                      ),
                    ),
                    filled: true,
                    hintStyle: new TextStyle(color: Colors.grey[800]),
                    hintText: "Search",
                    fillColor: Colors.white),
              ),
            ),
          ),
          preferredSize: Size(0.0, 80.0),
        ),
      ),
      body: Scaffold(
        body: _result == null
            ? CircularProgressIndicator()
            : GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 2 / 2,
                children: _result.realtimeArrivalList
                    .map((e) => _buildItem(e))
                    .toList(),
              ),
      ),
    );
  }

  Widget _buildItem(RealtimeArrivalList item) {
    return Card(
      child: Column(
        children: [
          Image.network(
              'https://static.toiimg.com/thumb/msid-78287167,width-1200,height-900,resizemode-4/.jpg'),
          Text('${item.trainLineNm}'),
          Text('${item.arvlMsg2}'),
        ],
      ),
    );
  }
}
