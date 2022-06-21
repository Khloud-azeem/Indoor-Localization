import 'package:flutter/material.dart';
import 'package:map/models/painter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double x = 0, y = 0;
  List<List<double>> oldData = [];

  bool replayMode = false;
  LocationPainter oldLocationPainter =
      LocationPainter(x: 0, y: 0, color: Colors.blue);

  Future<void> getData(double width, double height) async {
    String url = 'http://toto3.pythonanywhere.com/Get_Position/';
    setState(() {
      replayMode = false;
    });
    while (true) {
      if (replayMode) {
        break;
      }
      var response = await http.get(
        Uri.parse(url),
      );
      var jsonData = json.decode(response.body);
      print('Lable is $jsonData');
      if (jsonData == '1.0') {
        // Lectures Hall
        x = width * 0.63;
        y = height * 0.25;
      } else if (jsonData == '2.0') {
        // hallway salah
        x = width * 0.53;
        y = height * 0.80;
      } else if (jsonData == '3.0') {
        // dr sherif
        x = width * 0.73;
        y = height * 0.35;
      } else if (jsonData == '4.0') {
        // tamer office
        x = width * 0.37;
        y = height * 0.70;
      } else if (jsonData == '5.0') {
        // electronics lab
        x = width * 0.33;
        y = height * 0.53;
      } else if (jsonData == '6.0') {
        // TA
        x = width * 0.53;
        y = height * 0.41;
      } else if (jsonData == '7.0') {
        // dr kandeel
        x = width * 0.33;
        y = height * 0.35;
      } else {
        x = 0;
        y = 0;
      }
      oldData.insert(0, [x, y]);
      setState(() {});
      print('x: $x, y: $y');
      print('old data count: ${oldData.length}');
      await Future.delayed(Duration(seconds: 1));
    }
  }

  Future<void> replayData() async {
    setState(() {
      replayMode = true;
    });
    print('replay mode is $replayMode');
    for (var i = 0; i < oldData.length; i++) {
      print('i : $i');
      x = oldData[i][0];
      y = oldData[i][1];
      print('x: $x, y: $y');
      setState(() {
        oldLocationPainter = LocationPainter(x: x, y: y, color: Colors.blue);
      });
      await Future.delayed(Duration(seconds: 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height -
        (MediaQuery.of(context).padding.top + kToolbarHeight);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text('SBME MAP'),
        backgroundColor: Colors.teal,
        actions: <Widget>[
          IconButton(
            onPressed: () => getData(width, height),
            icon: Icon(Icons.download),
          ),
          IconButton(
            onPressed: replayData,
            icon: Icon(Icons.replay),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Stack(
            children: [
              Container(
                width: double.infinity,
                height: height * 0.9,
                child: Center(
                  child: Image.asset('assets/images/map.jpg'),
                ),
              ),
              Center(
                child: Container(
                  width: double.infinity,
                  height: height * 0.9,
                  child: !replayMode
                      ? CustomPaint(
                          painter:
                              LocationPainter(x: x, y: y, color: Colors.red),
                        )
                      : CustomPaint(painter: oldLocationPainter),
                ),
              ),
            ],
          ),
          Container(
            height: height * 0.1,
            padding: EdgeInsets.all(7),
            alignment: Alignment.center,
            child: Text(
              'x: ' +
                  this.x.toStringAsFixed(2) +
                  ', y: ' +
                  this.y.toStringAsFixed(2),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
