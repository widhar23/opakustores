import 'package:auto_size_text/auto_size_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opakuStore/src/helpers/TextStyle.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/helpers/utils.dart';
import 'package:opakuStore/src/model/orderInfo.dart';
import 'package:opakuStore/src/widgets/card_product_order.dart';
import 'package:opakuStore/src/widgets/widget_title.dart';

class OrderInfoView extends StatefulWidget {
  OrderInfoView({this.id, this.orderInfo, this.descriptionCancel = ' '});
  final OrderInfo orderInfo;
  final String id;
  final String descriptionCancel;
  @override
  _OrderInfoViewState createState() => _OrderInfoViewState();
}

class _OrderInfoViewState extends State<OrderInfoView> {
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Order Info',
          style: kBoldTextStyle.copyWith(
            fontSize: FontSize.setTextSize(32),
          ),
        ),
        backgroundColor: kColorWhite,
        iconTheme: IconThemeData.fallback(),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ConstScreen.setSizeHeight(25),
        ),
        child: ListView(
          children: <Widget>[
            //TODO: Main Info
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: ConstScreen.setSizeWidth(25)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  //TODO: Order ID
                  TitleWidget(
                    title: 'Order Id',
                    content: widget.id,
                  ),
                  TitleWidget(
                    title: 'Date',
                    content: widget.orderInfo.createAt,
                  ),
                  TitleWidget(
                    title: 'Customer',
                    content: widget.orderInfo.customerName,
                  ),
                  TitleWidget(
                    title: 'Receiver',
                    content: widget.orderInfo.receiverName,
                  ),
                  TitleWidget(
                    title: 'Status',
                    content: widget.orderInfo.status,
                  ),
                  TitleWidget(
                    title: 'SubTotal',
                    content:
                        '${r'$'+Util.intToMoneyType(int.parse(widget.orderInfo.total) + int.parse(widget.orderInfo.shipping) + int.parse(widget.orderInfo.maxBillingAmount))} ',
                  ),
                  TitleWidget(
                    title: 'Shipping',
                    content:
                        '+${r'$'+ Util.intToMoneyType(int.parse(widget.orderInfo.shipping))} ',
                  ),
                  TitleWidget(
                    title: 'Coupon',
                    content:
                        'Discount: ${widget.orderInfo.discount}% \n-${Util.intToMoneyType(int.parse(widget.orderInfo.discountPrice))}',
                  ),

                  // TODO: Err total 200,000
                  Card(
                    child: TitleWidget(
                        title: 'Total',
                        content: r'$''${widget.orderInfo.total} '),
                  ),
                ],
              ),
            ),
            //TODO: Cancelled Order
            (widget.descriptionCancel != ' ')
                ? Container(
                    color: kColorLightGrey,
                    height: ConstScreen.setSizeHeight(70),
                    child: Padding(
                      padding:
                          EdgeInsets.only(left: ConstScreen.setSizeWidth(30)),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: AutoSizeText(
                          'Order Was Cancelled!',
                          maxLines: 1,
                          minFontSize: 10,
                          style: kBoldTextStyle.copyWith(
                              fontSize: FontSize.setTextSize(32),
                              color: kColorRed),
                        ),
                      ),
                    ),
                  )
                : Container(),

            (widget.descriptionCancel != ' ')
                ? Padding(
                    padding: EdgeInsets.only(
                        top: ConstScreen.setSizeHeight(10),
                        left: ConstScreen.setSizeHeight(27)),
                    child: AutoSizeText(
                      widget.descriptionCancel,
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      minFontSize: 10,
                      style: kBoldTextStyle.copyWith(
                          fontSize: FontSize.s28, color: kColorBlack),
                    ),
                  )
                : Container(),
            SizedBox(
              height: ConstScreen.setSizeHeight(15),
            ),
            Container(
              color: kColorLightGrey,
              height: ConstScreen.setSizeHeight(70),
              child: Padding(
                padding: EdgeInsets.only(left: ConstScreen.setSizeWidth(30)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    'Product Detail',
                    maxLines: 1,
                    minFontSize: 10,
                    style: kBoldTextStyle.copyWith(
                        fontSize: FontSize.setTextSize(32), color: kColorBlue),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: ConstScreen.setSizeHeight(15),
            ),
            //TODO: List Product
            StreamBuilder<QuerySnapshot>(
              stream: Firestore.instance
                  .collection('Orders')
                  .document(widget.orderInfo.subId)
                  .collection(widget.orderInfo.id)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: snapshot.data.documents
                        .map((DocumentSnapshot document) {
                      return ProductOrderDetail(
                        name: document['name'],
                        price: document['price'],
                        quantity: document['quantity'],
                        color: Color(document['color']),
                        size: document['size'],
                      );
                    }).toList(),
                  );
                } else {
                  return Container();
                }
              },
            ),

            //TODO: Phone number
            Container(
              color: kColorLightGrey,
              height: ConstScreen.setSizeHeight(70),
              child: Padding(
                padding: EdgeInsets.only(left: ConstScreen.setSizeWidth(30)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    'Phone Number',
                    maxLines: 1,
                    minFontSize: 10,
                    style: kBoldTextStyle.copyWith(
                        fontSize: FontSize.setTextSize(32), color: kColorBlue),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                  top: ConstScreen.setSizeHeight(10),
                  left: ConstScreen.setSizeHeight(27)),
              child: AutoSizeText(
                widget.orderInfo.phone,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                minFontSize: 10,
                style: kBoldTextStyle.copyWith(
                    fontSize: FontSize.s30, color: kColorBlack),
              ),
            ),
            //TODO: Shipping Address
            Container(
              color: kColorLightGrey,
              height: ConstScreen.setSizeHeight(70),
              child: Padding(
                padding: EdgeInsets.only(left: ConstScreen.setSizeWidth(30)),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: AutoSizeText(
                    'Shipping Address',
                    maxLines: 1,
                    minFontSize: 10,
                    style: kBoldTextStyle.copyWith(
                        fontSize: FontSize.setTextSize(32), color: kColorBlue),
                  ),
                ),
              ),
            ),

            Padding(
              padding: EdgeInsets.only(
                  top: ConstScreen.setSizeHeight(10),
                  left: ConstScreen.setSizeHeight(27)),
              child: AutoSizeText(
                widget.orderInfo.address,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                minFontSize: 10,
                style: kBoldTextStyle.copyWith(
                    fontSize: FontSize.s30, color: kColorBlack),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
