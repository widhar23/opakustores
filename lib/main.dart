import 'package:device_preview/device_preview.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:opakuStore/routes.dart';

//TODO: device review
//void main() => runApp(
//      DevicePreview(
//        builder: (context) => MyApp(),
//      ),
//    );

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//      locale: DevicePreview.of(context).locale,
//      builder: DevicePreview.appBuilder,
      initialRoute: initialRoute,
      routes: routes,
    );
  }
}
