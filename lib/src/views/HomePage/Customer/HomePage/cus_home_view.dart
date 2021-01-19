import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/views/HomePage/Customer/HomePage/product_list_view.dart';
import 'package:opakuStore/src/widgets/banner.dart';
import 'package:opakuStore/src/widgets/icon_opaku.dart';

class CustomerHomePageView extends StatefulWidget {
  @override
  _CustomerHomePageViewState createState() => _CustomerHomePageViewState();
}

class _CustomerHomePageViewState extends State<CustomerHomePageView>
    with AutomaticKeepAliveClientMixin {
  int _current = 0;
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        // Banner Slider
        CarouselSlider(
          options: CarouselOptions(
            viewportFraction: 1.0,
            enableInfiniteScroll: false,
            scrollDirection: Axis.vertical,
            initialPage: 0,
          ),
          items: <Widget>[
            CustomBanner(
              title: 'COME ON IN',
              description:
                  'Find the special for the special one',
              image: 'GIF.gif',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductListView(
                              search: '',
                            )));
              },
            ),
            CustomBanner(
              title: 'SALE',
              description:
                  'Find the special for the special one',
              image: 'banner.jpg',
              onPress: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ProductListView(
                              search: 'sale',
                            )));
              },
            ),
          ],
        ),
        // Logo
        Positioned(
          top: 0,
          left: ConstScreen.setSizeWidth(255),
          child: IconOpaku(
            textSize: FontSize.setTextSize(60),
          ),
        ),
      ],
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
