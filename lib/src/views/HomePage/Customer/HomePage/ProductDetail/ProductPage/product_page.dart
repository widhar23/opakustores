import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opakuStore/src/helpers/TextStyle.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/helpers/shared_preferrence.dart';
import 'package:opakuStore/src/helpers/utils.dart';
import 'package:opakuStore/src/model/product.dart';
import 'package:opakuStore/src/views/HomePage/Customer/HomePage/ProductDetail/ProductPage/product_controller.dart';
import 'package:opakuStore/src/views/HomePage/Customer/HomePage/ProductDetail/image_product_view.dart';
import 'package:opakuStore/src/widgets/button_raised.dart';
import 'package:progress_dialog/progress_dialog.dart';

class ProductPage extends StatefulWidget {
  ProductPage({this.product, Key key}) : super(key: key);
  final Product product;
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage>
    with AutomaticKeepAliveClientMixin {
  ProgressDialog pr;
  bool _isLogging = false;
  List _sizeList = ['NB', '3M', '6M', '9M', '12M', '18M', '24M'];
  bool _isLoveCheck = false;
  bool _isAddBtnPress = true;
  int _isColorFocus = 1;
  List<ColorInfo> _listColorPicker = [];
  ProductController _controller = new ProductController();
  CarouselController buttonCarouselController = CarouselController();
  bool _isSoldOut = false;
  int _indexPage = 1;
  //TODO: value
  int colorValue;
  String sizeValue;

  get analytics => FirebaseAnalytics();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (int.parse(widget.product.quantityMain) == 0) {
      _isSoldOut = true;
    }
    getIsCheckWishlist();
    int i = 1;
    for (var value in widget.product.colorList) {
      _listColorPicker.add(ColorInfo(id: i, color: Color(value)));
      i++;
    }
    _sizeList = widget.product.sizeList;
    colorValue = _listColorPicker.elementAt(0).color.value;

    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });
  }

  //TODO: Check isCheckWishList
  getIsCheckWishlist() async {
    String userUid = await StorageUtil.getUid();
    final snapShot = await Firestore.instance
        .collection('Wishlists')
        .document(userUid)
        .collection(userUid)
        .document(widget.product.id)
        .get();
    bool isExists = snapShot.exists;
    if (isExists) {
      setState(() {
        _isLoveCheck = true;
      });
    }
  }

  //TODO: Create Color Picker Bar
  Widget renderColorBar() {
    List<Widget> listWidget = [];
    for (var value in _listColorPicker) {
      listWidget.add(Padding(
        padding: EdgeInsets.only(left: ConstScreen.setSizeWidth(8)),
        child: ColorPicker(
          color: value.color,
          isCheck: _isColorFocus == value.id,
          onTap: () {
            setState(() {
              _isColorFocus = value.id;
            });
            //TODO: jump to color
            if (_listColorPicker.length > 1) {
              print(value.id);
              if (value.id <= 2) {
                if (value.id == 1) {
                  buttonCarouselController.jumpToPage(0);
                } else {
                  buttonCarouselController.jumpToPage(2);
                }
              } else {
                buttonCarouselController.jumpToPage(value.id - 2);
              }
            }
            //TODO: color value pick
            colorValue = value.color.value;
          },
        ),
      ));
    }
    return Row(
      children: listWidget,
    );
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Container(
      height: double.infinity,
      child: Column(
        children: <Widget>[
          //TODO: TOP
          Stack(
            children: <Widget>[
              CarouselSlider(
                options: CarouselOptions(
                  enableInfiniteScroll: false,
                  height: ConstScreen.setSizeHeight(800),
                  scrollDirection: Axis.horizontal,
                  viewportFraction: 1.0,
                ),
                carouselController: buttonCarouselController,
                items: widget.product.imageList.map((image) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ImageProductView(
                                    onlineImage: image,
                                  )));
                    },
                    child: CachedNetworkImage(
                      width: double.infinity,
                      imageUrl: image,
                      fit: BoxFit.fitHeight,
                      placeholder: (context, url) => Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                    ),
                  );
                }).toList(),
              ),
              //TODO: Close Button
              Positioned(
                child: IconButton(
                  color: kColorBlack,
                  iconSize: ConstScreen.setSizeWidth(55),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.arrow_back_ios,
                      size: ConstScreen.setSizeWidth(40)),
                ),
              ),
              //TODO: Wistlist IconButton
              Positioned(
                left: ConstScreen.setSizeWidth(660),
                top: ConstScreen.setSizeHeight(5),
                child: IconButton(
                  onPressed: () {
                    //TODO: Check logging
                    if (_isLogging) {
                      if (!_isLoveCheck) {
                        //TODO: Adding product to Wishlist
                        _controller
                            .addProductToWishlist(product: widget.product)
                            .then((value) {
                          if (value) {
                            setState(() {
                              _isLoveCheck = true;
                            });
                            Scaffold.of(context).showSnackBar(SnackBar(
                              backgroundColor: kColorWhite,
                              content: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.check,
                                    color: kColorGreen,
                                    size: ConstScreen.setSizeWidth(50),
                                  ),
                                  SizedBox(
                                    width: ConstScreen.setSizeWidth(20),
                                  ),
                                  Expanded(
                                    child: Text(
                                      'Product has been add to Wishlist.',
                                      style: kBoldTextStyle.copyWith(
                                          fontSize: FontSize.s28),
                                    ),
                                  )
                                ],
                              ),
                            ));
                          }
                        });
                      }
                    } else {
                      Navigator.pushNamed(context, 'register_screen');
                    }
                  },
                  icon: Icon(
                    _isLoveCheck ? Icons.favorite : Icons.favorite_border,
                    color: _isLoveCheck ? kColorRed : kColorBlack,
                    size: ConstScreen.setSizeHeight(60),
                  ),
                ),
              )
            ],
          ),

// TODO:            Bottom
          Container(
            color: kColorWhite,
            width: ConstScreen.setSizeWidth(750),
            child: Padding(
              padding: EdgeInsets.only(top: 8, bottom: 0, left: 10, right: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //TODO: Product name
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.product.productName,
                          style: TextStyle(
                            fontSize: FontSize.setTextSize(40),
                            fontWeight: FontWeight.w800,
                            color: kColorBlack,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  //TODO: Price
                  Row(
                    children: <Widget>[
                      //TODO: Price
                      Text(
                        r'$ '+ Util.intToMoneyType(int.parse(widget.product.price)),
                        style: TextStyle(
                            fontSize: FontSize.setTextSize(34),
                            color: kColorBlack,
                            decoration: (widget.product.salePrice != '0')
                                ? TextDecoration.lineThrough
                                : TextDecoration.none),
                      ),
                      SizedBox(
                        width: ConstScreen.setSizeHeight(20),
                      ),
                      //TODO: Sale Price
                      Text(
                        (widget.product.salePrice != '0')
                            ?r'$'+ Util.intToMoneyType(
                                    int.parse(widget.product.salePrice))
                            : '',
                        style: TextStyle(
                            fontSize: FontSize.setTextSize(34),
                            color: kColorRed),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: ConstScreen.setSizeHeight(5),
                  ),
                  //TODO: Color and Size Picker
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 4,
                        child: renderColorBar(),
                      ),
                      Expanded(
                        flex: 2,
                        child: StreamBuilder(
                            stream: _controller.sizeStream,
                            builder: (context, snapshot) {
                              return DropdownButton(
                                isExpanded: true,
                                style: TextStyle(fontSize: FontSize.s30),
                                value: sizeValue,
                                hint: (snapshot.hasError)
                                    ? Text(
                                        snapshot.error,
                                        style: kBoldTextStyle.copyWith(
                                            color: kColorRed),
                                      )
                                    : Text('Select size'),
                                onChanged: (value) {
                                  setState(() {
                                    sizeValue = value;
                                  });
                                },
                                items: _sizeList.map((value) {
                                  return DropdownMenuItem(
                                    child: Text(
                                      'Size ' + value,
                                      style: TextStyle(
                                          color: kColorBlack,
                                          fontSize: FontSize.s30),
                                    ),
                                    value: value,
                                  );
                                }).toList(),
                              );
                            }),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ConstScreen.setSizeHeight(50),
                  ),
                  // TODO: Button Add
                  _isSoldOut
                      ? soldOutWidget()
                      : CusRaisedButton(
                          title: 'ADD',
                          backgroundColor: kColorBlack,
                          isDisablePress: _isAddBtnPress,
                          onPress: () async {
                            //TODO: check logging
                            if (_isLogging) {
                              setState(() {
                                _isAddBtnPress = false;
                              });
                              //TODO: Add product
                              await _controller
                                  .addProductToCart(
                                      color: colorValue,
                                      size: sizeValue,
                                      product: widget.product)
                                  .then((isComplete) {
                                if (isComplete != null) {
                                  if (isComplete) {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                      backgroundColor: kColorWhite,
                                      content: Row(
                                        children: <Widget>[
                                          Icon(
                                            Icons.check,
                                            color: kColorGreen,
                                            size: ConstScreen.setSizeWidth(50),
                                          ),
                                          SizedBox(
                                            width: ConstScreen.setSizeWidth(20),
                                          ),
                                          Expanded(
                                            child: Text(
                                              'Product has been add to Your Cart.',
                                              style: kBoldTextStyle.copyWith(
                                                  fontSize: FontSize.s28),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
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
                                              'Added error.',
                                              style: kBoldTextStyle.copyWith(
                                                  fontSize: FontSize.s28),
                                            ),
                                          )
                                        ],
                                      ),
                                    ));
                                  }
                                }
                                setState(() {
                                  _isAddBtnPress = true;
                                });
                              });
                            } else {
                              Navigator.pushNamed(context, 'register_screen');
                            }
                          },
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget soldOutWidget() {
    return CusRaisedButton(
      title: 'SOLD OUT',
      backgroundColor: kColorRed,
      onPress: () {},
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}

class ColorPicker extends StatelessWidget {
  ColorPicker({this.isCheck = false, this.onTap, this.color});
  final bool isCheck;
  final Function onTap;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        height: ConstScreen.setSizeHeight(55),
        width: ConstScreen.setSizeWidth(55),
        decoration: BoxDecoration(
            border: (color == kColorWhite)
                ? Border.all(color: kColorBlack, width: 1)
                : Border.all(color: isCheck ? kColorBlack : color, width: 2),
            borderRadius: BorderRadius.circular(180),
            color: color),
        child: Center(
            child: isCheck
                ? Icon(
                    Icons.check,
                    size: ConstScreen.setSizeWidth(35),
                    color: (color == kColorBlack) ? kColorWhite : kColorBlack,
                  )
                : null),
      ),
    );
  }
}
