import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import '../models/food_waste_post.dart';
import 'detail_screen.dart';
import 'new_post.dart';


class ListScreen extends StatefulWidget {
  ListScreen({
    Key? key, 
    required this.analytics, 
    required this.observer
  }) : super(key : key);
  
  final FirebaseAnalyticsObserver observer;
  final FirebaseAnalytics analytics;

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  // _ListScreenState(this.analytics, this.observer);
  // final FirebaseAnalyticsObserver observer;
  // final FirebaseAnalytics analytircs;

  String _message = '';
  int numOfItems = 0;
  num totalItems = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Wastegram ${this.totalItems.toString()}"),
        centerTitle: true,
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('posts').orderBy('date', descending: true).snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var post = snapshot.data!.docs[index];
                var foodWastePost = FoodWastePost.fromMap(post);
                // this.totalItems += post['numOfEntities'];
                return GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => DetailScreen(post:foodWastePost))
                    );
                  },
                  child: ListTile(
                    title: Text(post['date']),
                    trailing: Text(post['numOfEntities'].toString())
                  ),
                );
              }
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        }
      ),
      floatingActionButton: Semantics(
        label: 'Choose a picture from gallery for a new entry',
        child: FloatingActionButton(
          child: Icon(Icons.camera_alt_rounded),
          onPressed: () {
            _testSetCurrentScreen();
            // puash a new entry to the stack
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => NewPost())
            );
          },
        )
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void setMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  Future<void> _sendAnalyticsEvent() async {
    await widget.analytics.logEvent(
      name: 'test_event',
      parameters: <String, dynamic>{
        'string': 'string',
        'int': 42,
        'long': 12345678910,
        'double': 42.0
      },
    );
    setMessage('logEvent succeeded');
  }

  Future<void> _testSetCurrentScreen() async {
    await widget.analytics.setCurrentScreen(
      screenName: 'Analytics Demo',
      screenClassOverride: 'AnalyticsDemo',
    );
    setMessage('Tap on choose photos succeeded');
  }

}