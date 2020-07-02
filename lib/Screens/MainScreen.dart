import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firestore/Screens/ImageLabeling.dart';
import 'package:firestore/Screens/Votes.dart';
import 'package:firestore/Screens/TextRecog.dart';
import 'package:firestore/Screens/PlaceRecog.dart';
import 'package:camera/camera.dart';
import 'dart:async';

List<CameraDescription> cameras;

Future<Null> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  runApp(new MainScreen());
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Baby Names',
      home: MyHomePage(cameras : cameras),
    );
  }
}

class AboutWidget extends StatelessWidget {
  Color myColor = Color(0xff00bfa5);
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      contentPadding: EdgeInsets.only(top: 10.0),
      title: Column(
        children: <Widget>[
          Icon(
            Icons.error,
            size: 80.0,
          ),
          Text(
            "Are you sure?",
            textAlign: TextAlign.center,
          )
        ],
      ),
      content: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              child: Container(
                padding: EdgeInsets.only(top: 15.0, bottom: 20.0),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
                    ],
                    stops: [0.1, 0.4, 0.7, 0.9],
                  ),
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(32.0),
                      bottomRight: Radius.circular(32.0)),
                ),
                child: Text(
                  "Log Out",
                  style: TextStyle(color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              onTap: () {
                FirebaseAuth.instance.signOut().then((value) {
                  Navigator.of(context).pop();
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
final List<CameraDescription> cameras;
  MyHomePage({this.cameras});
  @override
  _MyHomePageState createState() {
    return _MyHomePageState();
  }
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 4, vsync: this, initialIndex: 1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text('Lensify'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF73AEF5),
                      Color(0xFF61A4F1),
                      Color(0xFF478DE0),
                      Color(0xFF398AE5),
              ],
            ),
          ),
        ),
        elevation: 0.7,
        bottom: new TabBar(
          labelColor: Color(0xFF002366),
          controller: _tabController,
          indicatorColor: Colors.white,
          unselectedLabelColor: Colors.white,
          indicatorSize: TabBarIndicatorSize.label,
          indicator: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              color: Colors.white),
          tabs: <Widget>[
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text('IMAGE ',
                style: TextStyle(
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.bold,
                ),
                ),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text('PLACE ',
                style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text('TEXT ',
                style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Text('VOTES ',
                style: TextStyle(fontWeight: FontWeight.bold),),
              ),
            ),
          ],
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.power_settings_new),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AboutWidget(),
              );
            },
          )
        ],
      ),
      body: Stack(
        children: <Widget>[
          new TabBarView(
            controller: _tabController,
            children: <Widget>[
              new ImageLabeling(),
              new PlaceRecog(widget.cameras),
              new TextRecog(),
              new Votes(),
            ],
          ),
        ],
      ),
    );
  }
}
