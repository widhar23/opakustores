// ignore: non_constant_identifier_names
import 'dart:collection';
import 'dart:ffi';
import 'dart:convert';
import 'dart:io';


import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:opakuStore/routes.dart';

Future<void> viewItem({
  // ignore: non_constant_identifier_names
  String item_id,
  // ignore: non_constant_identifier_names
  String item_name,
  // ignore: non_constant_identifier_names
  String item_category,
  // ignore: non_constant_identifier_names
  String item_variant,
  // ignore: non_constant_identifier_names
  String item_brand,
  double price,
  String currency,
}){
  var product1 = {
    'item_id': item_id,
    'item_name': item_name,
    'item_category': item_category,
    'item_brand': item_brand,
    'item_variant': 'Baju Anak',
    'price': price, //TODO: Still TRigger wrong price --> Check
    'currency': currency,
  };
  var product2 = {
    'item_id': item_id,
    'item_name': item_name,
    'item_category': item_category,
    'item_brand': item_brand,
    'item_variant': 'Baju Anak',
    'price': price, //TODO: Still TRigger wrong price --> Check
    'currency': currency,
  };
  var mapList={}..addAll(product1)..addAll(product2);

  var a = json.encode(mapList).toString();
  var parsedJson = json.decode(a);

  // var a = product1.toString();
  // var parsedJson = json.decode(a);

  //var product1;
  _requireValueAndCurrencyTogether(price,currency);
  return analytics.logEvent(
    name:'view_item',
    parameters:
      parsedJson,
  );
  // return FirebaseAnalytics().logEvent(
  //   name: "view_item",
  //   // ignore: invalid_use_of_visible_for_testing_member
  //   parameters:{
  //     // "items": product1,
  //       "item_id": item_id,
  //       "item_name": item_name,
  //       "item_category": item_category,
  //       "item_brand": item_brand,
  //       "item_variant": 'Baju Anak',
  //       "price": price, //TODO: Still TRigger wrong price --> Check
  //       "currency": currency,
  //   },
  // );
}

const String valueAndCurrencyMustBeTogetherError = 'If you supply the "value" '
    'parameter, you must also supply the "currency" parameter.';

Future<void> _requireValueAndCurrencyTogether(double value, String currency) {
  if (value != null && currency == null) {
    throw ArgumentError(valueAndCurrencyMustBeTogetherError);
  }
}