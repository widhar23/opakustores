import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:opakuStore/src/helpers/TextStyle.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/helpers/shared_preferrence.dart';
import 'package:opakuStore/src/views/HomePage/Customer/chat_view.dart';
import 'package:opakuStore/src/views/HomePage/Customer/HomePage/cus_home_view.dart';
import 'package:opakuStore/src/views/HomePage/Customer/ProfilePage/profile_view.dart';
import 'package:opakuStore/src/views/HomePage/Customer/SearchPage/search_view.dart';
import 'package:opakuStore/src/views/HomePage/Customer/WishlistPage/wishlist_view.dart';
import 'package:opakuStore/src/views/HomePage/Customer/WebView/webviewtest.dart';

class CustomerHomeView extends StatefulWidget {
  @override
  _CustomerHomeViewState createState() => _CustomerHomeViewState();
}

class _CustomerHomeViewState extends State<CustomerHomeView> {
  final PageStorageBucket bucket = PageStorageBucket();
  int indexScreen = 0;
  final pageController = PageController();
  final tabsScreen = [
    CustomerHomePageView(),
    SearchView(),
    WishListView(),
    ChatScreen(),
    ProfileView(),
    MyApp(),
  ];

  final tabsTitle = [
    ' ',
    'Search',
    'Wishlist',
    'Chat',
    'Profile',
    'MyWebAppTest'
  ];

  bool _isLogging;

  @override
  initState() {
    // TODO: implement initState

    StorageUtil.getIsLogging().then((bool value) {
      if (value != null) {
        _isLogging = value;
      } else {
        _isLogging = false;
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    return Scaffold(
      appBar: (indexScreen > 1)
          ? AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: kColorWhite,
              iconTheme: IconThemeData.fallback(),
              title: Text(
                tabsTitle[indexScreen],
                style:
                    kBoldTextStyle.copyWith(fontSize: FontSize.setTextSize(32)),
              ),
              centerTitle: true,
              actions: <Widget>[
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.shoppingBag,
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, 'customer_cart_page');
                  },
                ),
              ],
            )
          : null,
      body: SafeArea(
          child: PageStorage(
        bucket: bucket,
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            if (!_isLogging && index > 1) {
              pageController.jumpToPage(--index);
            } else {
              setState(() {
                indexScreen = index;
              });
            }
          },
          children: tabsScreen,
        ),
      )),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey.shade500,
        selectedFontSize: 1,
        unselectedFontSize: 1,
        selectedItemColor: kColorBlack,
        currentIndex: indexScreen,
        onTap: (index) {
          print('onTap ' + _isLogging.toString());
          if (_isLogging == false && index > 1) {
            Navigator.pushNamed(context, 'register_screen');
          } else {
            setState(() {
              pageController.jumpToPage(index);
              indexScreen = index;
            });
          }
        },
        items: [
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                size: ConstScreen.sizeXXL,
              ),
              title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.search,
                size: ConstScreen.sizeXL,
              ),
              title: Text('Search')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                size: ConstScreen.sizeXL,
              ),
              title: Text('Wishlist')),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                size: ConstScreen.sizeXL,
              ),
              title: Text('Chat')),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.userAlt,
                size: ConstScreen.sizeXL,
              ),
              title: Text('Profile')),
          BottomNavigationBarItem(
              icon: Icon(
                FontAwesomeIcons.userAlt,
                size: ConstScreen.sizeXL,
              ),
              title: Text('MyAppWebTest')),
        ],
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
