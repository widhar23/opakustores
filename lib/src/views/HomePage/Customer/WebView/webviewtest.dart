// import 'dart:async';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
//
// Future main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(new MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => new _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> {
//   InAppWebViewController _webViewController;
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('InAppWebView Example'),
//         ),
//         body: Container(
//             child: Column(children: <Widget>[
//               Expanded(
//                 child:InAppWebView(
//                   initialData: InAppWebViewInitialData(
//                       data: """
// <!DOCTYPE html>
// <html lang="en">
//     <head>
//         <meta charset="UTF-8">
//         <meta name="viewport" content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
//     </head>
//     <body>
//         <h1>JavaScript Handlers (Channels) TEST</h1>
//         <button id='myBtn' onClick="wishlist(this.id)"> add to my wishlist</button>
//         <script>
//         document.getElementById("myBtn").addEventListener("click", function(event) {
//         window.flutter_inappwebview.callHandler('WishlistInvoke', 'Product List Event', 'Add to Favourite' ,'Little man Shirt').then(function(result) {
//         });
//    });
// </script>
//     </body>
// </html>
//                   """
//                   ),
//                   initialOptions: InAppWebViewGroupOptions(
//                       crossPlatform: InAppWebViewOptions(
//                         debuggingEnabled: true,
//                       )
//                   ),
//                   onWebViewCreated: (InAppWebViewController controller) {
//                     _webViewController = controller;
//
//                     // _webViewController.addJavaScriptHandler(handlerName:'handlerFoo', callback: (args) {
//                     //   // return data to JavaScript side!
//                     //   // return {
//                     //   //   'bar': 'bar_value', 'baz': 'baz_value'
//                     //   // };
//                     // });
//
//                     _webViewController.addJavaScriptHandler(handlerName: 'WishlistInvoke', callback: (args) async{
//                       print(args);
//                       await FirebaseAnalytics().logEvent(
//                           name:'general_event_WebView',
//                           parameters: filterOutNulls(<String, dynamic>{
//                             "event_category": args[0],
//                             "event_action" : args[1],
//                             "event_label" : args[2],
//                           }));
//                        //it will print: [1, true, [bar, 5], {foo: baz}, {bar: bar_value, baz: baz_value}]
//                     });
//                   },
//                   // onConsoleMessage: (controller, consoleMessage) {
//                   //   print(consoleMessage);
//                   //   // it will print: {message: {"bar":"bar_value","baz":"baz_value"}, messageLevel: 1}
//                   // },
//                 ),
//               ),
//             ])
//         ),
//       ),
//     );
//   }
// }

// import 'dart:convert';
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:opakuStore/routes.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// class MyApp extends StatefulWidget {
//   MyApp({Key key, this.title}) : super(key: key);
//   final String title;
//   @override
//   _MyAppTestState createState() => _MyAppTestState();
// }
//
// class _MyAppTestState extends State<MyApp> {
//   WebViewController _controller;
//   Future<void> loadHtmlFromAssets(String filename, controller) async {
//     String fileText = await rootBundle.loadString(filename);
//     controller.loadUrl(Uri.dataFromString(fileText,
//         mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
//         .toString());
//   }
//   Future<String> loadLocal() async {
//     return await rootBundle.loadString('lib/src/assets/index.html');
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Mytest"),
//       ),
//       body: FutureBuilder<String>(
//         //future: loadLocal(),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return WebView(
//                initialUrl:
//                 new Uri.dataFromString(snapshot.data, mimeType: 'text/html')
//                     .toString(),
//               javascriptMode: JavascriptMode.unrestricted,
//               javascriptChannels: <JavascriptChannel>[
//                 JavascriptChannel(name: 'flutter_inappwebview', onMessageReceived: (s) {
//                       var a = s.message.toString();
//                       var parsedJson = json.decode(a);
//                       print(parsedJson);
//                       analytics.logEvent(
//                         name:'view_item',
//                         parameters:
//                           parsedJson,
//                       );
//                     }),
//                 JavascriptChannel(name: 'flutter_inappwebview2', onMessageReceived: (s){
//                   var a2 = s.message.toString();
//                   var parsedJson2 = json.decode(a2);
//                   print(parsedJson2);
//                   analytics.logEvent(
//                     name:'add_to_cart',
//                     parameters:
//                       parsedJson2,
//                   );
//                 })
//               ].toSet(),
//             );
//           } else if (snapshot.hasError) {
//             return Text("Still Has An Error");
//           }
//           return CircularProgressIndicator();
//         },
//       ), // This trailing comma makes auto-formatting nicer for build methods.
//     );
//   }
// }


import 'dart:convert';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opakuStore/routes.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MyApp extends StatefulWidget {
  MyApp({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyAppTestState createState() => _MyAppTestState();
}

class _MyAppTestState extends State<MyApp> {
  WebViewController _controller;

  Future<void> loadHtmlFromAssets(String filename, controller) async {
    String fileText = await rootBundle.loadString(filename);
    controller.loadUrl(Uri.dataFromString(fileText,
        mimeType: 'text/html', encoding: Encoding.getByName('utf-8'))
        .toString());
  }

  Future<String> loadLocal() async {
    return await rootBundle.loadString('lib/src/assets/index.html');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text('WebView in Flutter')),
        body:Builder(builder: (BuildContext context) {
          return WebView(
            //initialUrl: 'https://bagusdummy.000webhostapp.com/',
            initialUrl: 'https://testwebviewiod.000webhostapp.com/',
            javascriptMode: JavascriptMode.unrestricted,
            javascriptChannels: <JavascriptChannel>{
              JavascriptChannel(
                  name: 'flutter_inappwebview', onMessageReceived: (s) {
                var a = s.message.toString();
                var parsedJson = json.decode(a);
                print(parsedJson);
                analytics.logEvent(
                  name: 'view_item',
                  parameters:
                  parsedJson,
                );
              }),
              JavascriptChannel(
                  name: 'flutter_inappwebview2', onMessageReceived: (s) {
                var a2 = s.message.toString();
                var parsedJson2 = json.decode(a2);
                print(parsedJson2);
                analytics.logEvent(
                  name: 'view_item_list',
                  parameters:
                    parsedJson2,
                    // "items" : {"item_id" : "test_out"}.toString().split('{}')
                );
              }),
              JavascriptChannel(
                  name: 'flutter_inappwebview3', onMessageReceived: (s) {
                var a3 = s.message.toString();
                var parsedJson3 = json.decode(a3);
                print(parsedJson3);
                analytics.logEvent(
                  'view_promotion',
                    {"promotions":parsedJson3}
                );
              })
            }.toSet(),
          );
        }),
    );
  }
}