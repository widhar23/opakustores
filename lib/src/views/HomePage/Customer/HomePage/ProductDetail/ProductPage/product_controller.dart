import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:opakuStore/src/helpers/shared_preferrence.dart';
import 'package:opakuStore/src/model/product.dart';

class ProductController {
  StreamController _sizeStreamController = new StreamController();
  StreamController _loveWishlistStreamController = new StreamController();
  get analytics => FirebaseAnalytics();

  Stream get sizeStream => _sizeStreamController.stream;
  Stream get loveWishlistStream => _loveWishlistStreamController.stream;

  //TODO: add product to cart
  addProductToCart({
    @required int color,
    @required String size,
    @required Product product,
  }) async {
    _sizeStreamController.add('');
    int countError = 0;
    if (size == null || size == '') {
      _sizeStreamController.addError('Picking your clothing size.');
      countError++;
    }
    print(countError);
    //TODO: Add Product to Your Cart
    if (countError == 0) {
      String userUid = await StorageUtil.getUid();
      print(userUid);
      await Firestore.instance
          .collection('Carts')
          .document(userUid)
          .collection(userUid)
          .document(product.id)
          .setData({
        'id': product.id,
        'name': product.productName,
        'image': product.imageList[0],
        'category': product.category,
        'size': size,
        'color': color,
        'price': product.price,
        'sale_price': product.salePrice,
        'brand': product.brand,
        'made_in': product.madeIn,
        'quantity': '1',
        'create_at': DateTime.now().toString(),
      }).catchError((onError){
        return false;
      });
      await FirebaseAnalytics().logEvent(
          name: "add_to_cart",
          parameters: filterOutNulls(<String, dynamic>{
            'item_id': product.id,
            'item_name': product.productName,
            'item_category': product.category,
            'item_brand': product.brand,
            'item_variant': 'Baju Anak',
            'price': double.parse(product.price),
        //TODO: Still TRigger wrong price --> Check
            'currency': 'USD',
            'quantity': product.quantity,
      }));
      return true;
    }
    return null;
  }

  //TODO Add product to Wish list
  addProductToWishlist({@required Product product}) async {
    String userUid = await StorageUtil.getUid();
    await Firestore.instance
        .collection('Wishlists')
        .document(userUid)
        .collection(userUid)
        .document(product.id)
        .setData({
      'id': product.id,
      'create_at': DateTime.now().toString()
    }).catchError((onError) {
      return false;
    });
    await analytics.logEvent(
      name:'general_event',
      parameters: filterOutNulls(<String, dynamic>{
        "event_category": "Product List Event",
        "event_action" : "Add to Favourite",
        "event_label" : product.productName,
      }));
    _loveWishlistStreamController.add(true);
    return true;
  }

  void dispose() {
    _sizeStreamController.close();
    _loveWishlistStreamController.close();
  }
}
