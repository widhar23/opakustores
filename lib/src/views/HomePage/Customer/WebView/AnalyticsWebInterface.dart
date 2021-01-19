// import 'dart:convert';
//
// import 'package:firebase_analytics/firebase_analytics.dart';
// import 'package:flutter/cupertino.dart';
// import 'dart:developer';
//
// import 'package:flutter/services.dart';
// import 'package:flutter_inappwebview/flutter_inappwebview.dart';
// import 'package:webview_flutter/webview_flutter.dart';
//
// // ignore: must_be_immutable
// class AnalyticsWebInterface extends StatelessWidget {
//   InAppWebViewController _webViewController;
//   get analytics => FirebaseAnalytics();
//   // ignore: non_constant_identifier_names
//   //String TAG  = "AnalyticsWebInterface";
//
//   logEvent(String name, String jsonParams){
//     return analytics.logEvent(name, bundleFromJson(jsonParams));
//   }
//
//   bundleFromJson(String jsonParams) async {
//     String data = await rootBundle.loadString(jsonParams);
//     String jsonResult = json.decode(data);
//     print(jsonResult);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return InAppWebView(
//       initialUrl: 'about/blank',
//       onWebViewCreated: (_webViewController)=>
//       ,
//     );
//   }
// }
