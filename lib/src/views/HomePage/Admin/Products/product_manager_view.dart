import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:opakuStore/src/helpers/TextStyle.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/helpers/utils.dart';
import 'package:opakuStore/src/views/HomePage/Admin/Products/product_comment_view.dart';
import 'package:opakuStore/src/views/HomePage/Customer/HomePage/ProductDetail/RatingPage/rating_product_page.dart';
import 'package:opakuStore/src/widgets/button_raised.dart';
import 'package:opakuStore/src/widgets/card_admin_product.dart';
import 'package:opakuStore/src/widgets/input_text.dart';
import 'package:opakuStore/src/widgets/input_text_product.dart';

class ProductManager extends StatefulWidget {
  @override
  _ProductManagerState createState() => _ProductManagerState();
}

class _ProductManagerState extends State<ProductManager> {
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Product Manager',
            style: kBoldTextStyle.copyWith(
              fontSize: FontSize.setTextSize(32),
            ),
          ),
          backgroundColor: kColorWhite,
          iconTheme: IconThemeData.fallback(),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.add_comment,
                  size: ConstScreen.setSizeWidth(45),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, 'admin_home_product_adding');
                })
          ],
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection('Products').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: snapshot.data.documents.map((document) {
                  return AdminProductCard(
                    productName: document['name'],
                    quantity: document['quantity'],
                    productPrice: int.parse(document['price']),
                    productSalePrice: int.parse(document['sale_price']),
                    brand: document['brand'],
                    category: document['category'],
                    madeIn: document['made_in'],
                    createAt:
                        Util.convertDateToFullString(document['create_at']),
                    productSizeList: document['size'],
                    productColorList: document['color'],
                    productImage: document['image'][0],
                    onComment: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AdminProductCommentView(
                                    productId: document['id'],
                                  )));
                    },
                    onClose: () {
                      Firestore.instance
                          .collection('Products')
                          .document(document.documentID)
                          .delete();
                    },
                    onEdit: () {
                      String productName = document['name'];
                      String quantity = document['quantity'];
                      String constPrice = document['price'];
                      String constSalePrice = document['sale_price'];
                      String price = document['price'];
                      String salePrice = document['sale_price'];
                      String productId = document['id'];
                      showDialog(
                          context: context,
                          builder: (context) => Dialog(
                                child: Container(
                                  height: ConstScreen.setSizeHeight(750),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal:
                                            ConstScreen.setSizeWidth(30),
                                        vertical:
                                            ConstScreen.setSizeHeight(20)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: <Widget>[
                                        Center(
                                          child: Text(
                                            'Edit Product',
                                            style: kBoldTextStyle.copyWith(
                                                fontSize: FontSize.s36,
                                                color: kColorBlack),
                                          ),
                                        ),
                                        SizedBox(
                                          height: ConstScreen.setSizeHeight(40),
                                        ),
                                        //TODO: product name
                                        InputTextProduct(
                                          title: 'Product Name',
                                          initValue: document['name'],
                                          inputType: TextInputType.text,
                                          onValueChange: (name) {
                                            productName = name;
                                          },
                                          icon: null,
                                        ),
                                        SizedBox(
                                          height: ConstScreen.setSizeHeight(15),
                                        ),
                                        //TODO:quantity
                                        InputTextProduct(
                                          title: 'Quantity',
                                          initValue: document['quantity'],
                                          inputType: TextInputType.number,
                                          onValueChange: (qty) {
                                            quantity = qty;
                                          },
                                          icon: null,
                                        ),
                                        SizedBox(
                                          height: ConstScreen.setSizeHeight(15),
                                        ),
                                        //TODO: Price
                                        InputTextProduct(
                                          title: 'Price',
                                          initValue: document['price'],
                                          inputType: TextInputType.number,
                                          onValueChange: (value) {
                                            price = value;
                                          },
                                          icon: null,
                                        ),
                                        SizedBox(
                                          height: ConstScreen.setSizeHeight(15),
                                        ),
                                        //TODO: Sale price
                                        InputTextProduct(
                                          title: 'Sale Price',
                                          initValue: document['sale_price'],
                                          inputType: TextInputType.number,
                                          onValueChange: (value) {
                                            salePrice = value;
                                          },
                                          icon: null,
                                        ),
                                        SizedBox(
                                          height: ConstScreen.setSizeHeight(20),
                                        ),
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                              flex: 1,
                                              child: CusRaisedButton(
                                                title: 'SAVE',
                                                backgroundColor: kColorBlack,
                                                onPress: () {
                                                  Firestore.instance
                                                      .collection('Products')
                                                      .document(document['id'])
                                                      .updateData({
                                                    'name': (productName !=
                                                                null &&
                                                            productName != '')
                                                        ? productName
                                                        : document['name'],
                                                    'quantity': (quantity !=
                                                                null &&
                                                            quantity != '')
                                                        ? quantity
                                                        : document['quantity'],
                                                    'price': (price != null &&
                                                            price != '')
                                                        ? price
                                                        : document['price'],
                                                    'sale_price': (salePrice !=
                                                                null &&
                                                            salePrice != '')
                                                        ? salePrice
                                                        : document['salePrice'],
                                                  });
                                                  // TODO: save Price volatility
                                                  if ((constPrice != price ||
                                                          constSalePrice !=
                                                              salePrice) &&
                                                      (price != '' &&
                                                          salePrice != '')) {
                                                    Firestore.instance
                                                        .collection(
                                                            'PriceVolatility')
                                                        .document()
                                                        .setData({
                                                      'product_id': productId,
                                                      'price': price,
                                                      'sale_price': salePrice,
                                                      'create_at':
                                                          DateTime.now()
                                                              .toString(),
                                                      'timeCreate': DateTime
                                                              .now()
                                                          .millisecondsSinceEpoch
                                                    });
                                                  }
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                            SizedBox(
                                              width:
                                                  ConstScreen.setSizeHeight(20),
                                            ),
                                            Expanded(
                                              flex: 1,
                                              child: CusRaisedButton(
                                                title: 'CANCEL',
                                                backgroundColor:
                                                    kColorLightGrey,
                                                onPress: () {
                                                  Navigator.pop(context);
                                                },
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ));
                    },
                  );
                }).toList(),
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
