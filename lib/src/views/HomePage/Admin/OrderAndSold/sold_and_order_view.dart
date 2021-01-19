import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:opakuStore/src/helpers/TextStyle.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/helpers/shared_preferrence.dart';
import 'package:opakuStore/src/helpers/utils.dart';
import 'package:opakuStore/src/model/orderInfo.dart';
import 'package:opakuStore/src/model/quantityOrder.dart';
import 'package:opakuStore/src/services/stripe_payment.dart';
import 'package:opakuStore/src/views/HomePage/Customer/ProfilePage/OrderAndBill/order_info_view.dart';
import 'package:opakuStore/src/widgets/OrderAdminCard.dart';
import 'package:opakuStore/src/widgets/button_raised.dart';
import 'package:opakuStore/src/widgets/card_order.dart';
import 'package:opakuStore/src/widgets/input_text.dart';

class SoldAndOrderView extends StatefulWidget {
  SoldAndOrderView({this.title});
  final String title;
  final _globalKey = new GlobalKey<ScaffoldState>();
  @override
  _SoldAndOrderViewState createState() => _SoldAndOrderViewState();
}

class _SoldAndOrderViewState extends State<SoldAndOrderView> {
  StreamController _controller = new StreamController();
  String uid = '';
  bool isOrderPage;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.title == 'Order List') {
      isOrderPage = true;
    } else {
      isOrderPage = false;
    }
    StorageUtil.getUid().then((uid) {
      this.uid = uid;
      _controller.sink.add(true);
      _controller.close();
    });
    StripeService.init();
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      key: widget._globalKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          widget.title,
          style: kBoldTextStyle.copyWith(
            fontSize: FontSize.setTextSize(32),
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: ConstScreen.setSizeWidth(20),
              vertical: ConstScreen.setSizeHeight(20)),
          child: StreamBuilder(
            stream: _controller.stream,
            builder: (context, mainSnapshot) {
              if (mainSnapshot.hasData) {
                return StreamBuilder<QuerySnapshot>(
                    stream: isOrderPage
                        ? Firestore.instance
                            .collection('Orders')
                            .orderBy('create_at')
                            .where('status', isEqualTo: 'Pending')
                            .snapshots()
                        : Firestore.instance
                            .collection('Orders')
                            .where('status', isLessThan: 'Pending')
                            .snapshots(),
                    builder: (context, snapshot) {
                      if (mainSnapshot.hasData && snapshot.hasData) {
                        return ListView(
                          children: snapshot.data.documents
                              .map((DocumentSnapshot document) {
                            OrderInfo orderInfo = new OrderInfo(
                                id: document['id'],
                                subId: document['sub_Id'],
                                customerName: document['customer_name'],
                                receiverName: document['receiver_name'],
                                address: document['address'],
                                phone: document['phone'],
                                status: document['status'],
                                total: document['total'],
                                createAt: Util.convertDateToFullString(
                                    document['create_at']),
                                shipping: document['shipping'],
                                discount: document['discount'],
                                discountPrice: document['discountPrice'],
                                maxBillingAmount: document['billingAmount']);
                            if (isOrderPage) {
                              //TODO: Order List View
                              return OrderAdminCard(
                                id: document['sub_Id'],
                                date: Util.convertDateToFullString(
                                    document['create_at']),
                                customerName: document['customer_name'],
                                status: document['status'],
                                total: Util.intToMoneyType(
                                    int.parse(document['total'])),
                                isEnableCancel:
                                    (document['status'] != 'Canceled'),
                                onViewDetail: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderInfoView(
                                                orderInfo: orderInfo,
                                                id: document['sub_Id'],
                                              )));
                                },
                                onAccept: () async {
                                  //TODO: Accept order
                                  bool result =
                                      await StripeService.confirmPaymentIntent(
                                          clientSecret:
                                              document['client_secret'],
                                          paymentMethodId:
                                              document['payment_method_id']);
                                  if (result) {
                                    String adminName =
                                        await StorageUtil.geFullName();
                                    Firestore.instance
                                        .collection('Orders')
                                        .document(document['sub_Id'])
                                        .updateData({
                                      'status': 'Completed',
                                      'description': '',
                                      'admin': adminName
                                    });
                                    //TODO: delete coupon
                                    Firestore.instance
                                        .collection('Orders')
                                        .document(document['couponId'])
                                        .delete();
                                    setState(() {});
                                  } else {
                                    //TODO: invalid card
                                    widget._globalKey.currentState
                                        .showSnackBar(SnackBar(
                                      backgroundColor: kColorWhite,
                                      content: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.error,
                                            color: kColorRed,
                                            size: ConstScreen.setSizeWidth(50),
                                          ),
                                          SizedBox(
                                            width: ConstScreen.setSizeWidth(20),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Invalid Bank Cards.',
                                              style: kBoldTextStyle.copyWith(
                                                  fontSize: FontSize.s28),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                                  }
                                },
                                onCancel: () {
                                  showDialog(
                                      context: context,
                                      builder: (context) {
                                        String description = '';
                                        return Dialog(
                                          child: Container(
                                            height:
                                                ConstScreen.setSizeHeight(700),
                                            width:
                                                ConstScreen.setSizeWidth(600),
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical:
                                                      ConstScreen.setSizeHeight(
                                                          20),
                                                  horizontal:
                                                      ConstScreen.setSizeWidth(
                                                          15)),
                                              child: Column(
                                                children: <Widget>[
                                                  Expanded(
                                                    flex: 1,
                                                    child: Center(
                                                      child: Text(
                                                        'Cancel Order',
                                                        style: kBoldTextStyle
                                                            .copyWith(
                                                                fontSize:
                                                                    FontSize
                                                                        .s36),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: ConstScreen
                                                        .setSizeHeight(20),
                                                  ),
                                                  //TODO: description
                                                  Expanded(
                                                    flex: 5,
                                                    child: Align(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      child: TextField(
                                                        decoration: InputDecoration(
                                                            hintStyle: kBoldTextStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        FontSize
                                                                            .s25),
                                                            hintText:
                                                                'Description',
                                                            border:
                                                                OutlineInputBorder(),
                                                            labelStyle: kBoldTextStyle
                                                                .copyWith(
                                                                    fontSize:
                                                                        FontSize
                                                                            .s30)),
                                                        keyboardType:
                                                            TextInputType
                                                                .multiline,
                                                        maxLines: null,
                                                        onChanged: (value) {
                                                          description = value;
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    height: ConstScreen
                                                        .setSizeHeight(20),
                                                  ),
                                                  //TODO: Button
                                                  Expanded(
                                                    flex: 1,
                                                    child: Row(
                                                      children: <Widget>[
                                                        //TODO: accept cancel
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                              CusRaisedButton(
                                                            title: 'ACCEPT',
                                                            backgroundColor:
                                                                kColorBlack,
                                                            onPress: () async {
                                                              String adminName =
                                                                  await StorageUtil
                                                                      .geFullName();
                                                              Firestore.instance
                                                                  .collection(
                                                                      'Orders')
                                                                  .document(
                                                                      document[
                                                                          'sub_Id'])
                                                                  .updateData({
                                                                'status':
                                                                    'Canceled',
                                                                'description':
                                                                    (description ==
                                                                            null)
                                                                        ? '   '
                                                                        : description,
                                                                'admin':
                                                                    adminName
                                                              });
                                                              //TODO: increase quantity
                                                              Firestore.instance
                                                                  .collection(
                                                                      'Orders')
                                                                  .document(
                                                                      document[
                                                                          'sub_Id'])
                                                                  .collection(
                                                                      document[
                                                                          'id'])
                                                                  .getDocuments()
                                                                  .then(
                                                                      (document) {
                                                                List<QuantityOrder>
                                                                    quantityOrderList =
                                                                    [];
                                                                for (var document
                                                                    in document
                                                                        .documents) {
                                                                  QuantityOrder
                                                                      quantityOrder =
                                                                      new QuantityOrder(
                                                                          productId: document[
                                                                              'id'],
                                                                          quantity:
                                                                              int.parse(document['quantity']));
                                                                  quantityOrderList
                                                                      .add(
                                                                          quantityOrder);
                                                                }
                                                                for (var qtyOrder
                                                                    in quantityOrderList) {
                                                                  Firestore
                                                                      .instance
                                                                      .collection(
                                                                          'Products')
                                                                      .document(
                                                                          qtyOrder
                                                                              .productId)
                                                                      .get()
                                                                      .then(
                                                                          (document) {
                                                                    int quantity =
                                                                        int.parse(
                                                                            document.data['quantity']);
                                                                    int result =
                                                                        quantity +
                                                                            qtyOrder.quantity;
                                                                    print(
                                                                        result);
                                                                    Firestore
                                                                        .instance
                                                                        .collection(
                                                                            'Products')
                                                                        .document(
                                                                            qtyOrder.productId)
                                                                        .updateData({
                                                                      'quantity':
                                                                          result
                                                                              .toString(),
                                                                    });
                                                                  });
                                                                }
                                                              });
                                                              setState(() {});
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width: ConstScreen
                                                              .setSizeWidth(20),
                                                        ),
                                                        //TODO: cancel
                                                        Expanded(
                                                          flex: 1,
                                                          child:
                                                              CusRaisedButton(
                                                            title: 'CANCEL',
                                                            backgroundColor:
                                                                kColorWhite,
                                                            onPress: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      });
                                },
                              );
                            } else {
                              //TODO: Sold order list view
                              return OrderCard(
                                id: document['sub_Id'],
                                date: Util.convertDateToFullString(
                                    document['create_at']),
                                admin: document['admin'],
                                customerName: document['customer_name'],
                                status: document['status'],
                                total: Util.intToMoneyType(
                                    int.parse(document['total'])),
                                isEnableCancel:
                                    (document['status'] != 'Canceled' &&
                                        document['status'] != 'Completed'),
                                onViewDetail: () {
                                  bool isCancelled =
                                      document['status'] == 'Canceled';
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => OrderInfoView(
                                                orderInfo: orderInfo,
                                                id: document['sub_Id'],
                                                descriptionCancel: isCancelled
                                                    ? document['description']
                                                    : ' ',
                                              )));
                                },
                                onCancel: () {
                                  Firestore.instance
                                      .collection('Orders')
                                      .document(document['sub_Id'])
                                      .updateData({
                                    'status': 'Canceled',
                                    'client_secret': "null",
                                    'payment_method_id': "null"
                                  });
                                },
                              );
                            }
                          }).toList(),
                        );
                      } else
                        return Container();
                    });
              } else
                return Center(
                  child: CircularProgressIndicator(),
                );
            },
          )),
    );
  }
}
