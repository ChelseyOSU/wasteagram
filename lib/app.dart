import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'screens/list_screen.dart';


class App extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(analytics: analytics);
  
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Wastegram",
      home: Scaffold(
        body: ListScreen(analytics: analytics, observer: observer),
      ),
      navigatorObservers: <NavigatorObserver>[observer],
    );
  }
}