import 'dart:ffi';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:opakuStore/src/helpers/TextStyle.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/helpers/utils.dart';
import 'package:opakuStore/src/widgets/button_raised.dart';

class PaymentCompleteView extends StatefulWidget {
  PaymentCompleteView({this.totalPrice});
  final int totalPrice;
  @override
  _PaymentCompleteViewState createState() => _PaymentCompleteViewState();
}

class _PaymentCompleteViewState extends State<PaymentCompleteView> {
  get analytics => FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    // analytics.logEvent(
    // name: "ecommerce_purchase",
    // // ignore: invalid_use_of_visible_for_testing_member
    // parameters: filterOutNulls(<String, dynamic>{
    //   "item_id" : "",
    //   "item_name": item_name,
    //   "item_category" : item_category,
    //   "item_variant" : item_variant,
    //   "item_brand":item_brand,
    //   "price" : price,
    //   "quantity": quantity,
    // }),
    //);
    return Scaffold(
      backgroundColor: kColorWhite,
      body: SafeArea(
        child: Container(
          height: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Center(
                  child: Icon(
                    Icons.check_circle,
                    color: kColorGreen,
                    size: ConstScreen.setSizeHeight(250),
                  ),
                ),
              ),
              Expanded(
                flex: 2,
                child: Column(
                  children: <Widget>[
                    Text(
                      r'$ '+Util.intToMoneyType(widget.totalPrice) ,
                      textAlign: TextAlign.center,
                      style: kNormalTextStyle.copyWith(
                          fontSize: FontSize.setTextSize(75)),
                    ),
                    Text(
                      'Your payment is complete.',
                      textAlign: TextAlign.center,
                      style: kNormalTextStyle.copyWith(
                          fontSize: FontSize.setTextSize(40)),
                    )
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Container(),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: ConstScreen.setSizeWidth(30),
                        ),
                        child: CusRaisedButton(
                          title: 'CONTINUTE SHOPPING',
                          backgroundColor: kColorGreen,
                          onPress: () {
                            Navigator.pushNamedAndRemoveUntil(
                                context,
                                'customer_home_screen',
                                (Route<dynamic> route) => false);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: ConstScreen.setSizeHeight(80),
              )
            ],
          ),
        ),
      ),
    );
  }
}


Future<void> Purchase({
  String item_id,
  String item_name,
  String item_category,
  String item_variant,
  String item_brand,
  Double price,
  Int8 quantity,
  String transaction_id,
  String affiliation,
  Double value,
  Double tax,
  Double shipping,
  String currency,
  String coupon,
}){
  var product1 = {
    "item_id" : item_id,
    "item_name": item_name,
    "item_category" : item_category,
    "item_variant" : item_variant,
    "item_brand":item_brand,
    "price" : price,
    "quantity": quantity,
  };
  var product2 = {
    "item_id" : item_id,
    "item_name": item_name,
    "item_category" : item_category,
    "item_variant" : item_variant,
    "item_brand":item_brand,
    "price" : price,
    "quantity": quantity,
  };
  var items = [product1,product2];
  var ecommerce = {
    'items': items,
    'transaction_id':transaction_id,
    'affiliation':affiliation,
    'tax':tax,
    'shipping':shipping,
    'currency':currency,
    'coupon':coupon,
  };
  FirebaseAnalytics analytics = FirebaseAnalytics();
  return analytics.logEvent(
      name: "ecommerce_purchase",
      // ignore: invalid_use_of_visible_for_testing_member
      parameters: ecommerce,
   );
}

