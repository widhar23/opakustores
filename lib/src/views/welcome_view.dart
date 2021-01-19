import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/services/stripe_payment.dart';
import 'package:opakuStore/src/widgets/button_tap.dart';
import 'package:opakuStore/src/widgets/icon_opaku.dart';

import '../../link.dart';

class WelcomeScreen extends StatelessWidget {
  get analytics => FirebaseAnalytics();
  @override
  Widget build(BuildContext context) {
    ConstScreen.setScreen(context);
    analytics.setCurrentScreen(
      screenName: "Welcome Screen",
    );
    return MaterialApp(
      home: Scaffold(
        body: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(KImageAddress + 'Splash_Background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                colors: [
                  Colors.yellow.withOpacity(.3),
                  Colors.yellow.withOpacity(.1),
                ],
              ),
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                  ConstScreen.setSizeHeight(20),
                  ConstScreen.setSizeHeight(20),
                  ConstScreen.setSizeHeight(20),
                  ConstScreen.setSizeHeight(90)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(
                    flex: 8,
                    child: IconOpaku(
                      textSize: FontSize.setTextSize(80),
                    ),
                  ),
                  SizedBox(
                    height: ConstScreen.setSizeHeight(100),
                  ),
                  new ButtonTap(
                    text: 'Sign Up / Sign In',
                    isSelected: true,
                    function: () {
                      Navigator.pushNamed(context, 'register_screen');
                    },
                  ),
                  SizedBox(
                    height: ConstScreen.setSizeHeight(25),
                  ),
                  new ButtonTap(
                    text: "Start Browsing",
                    isSelected: false,
                    function: () {
                      Navigator.pushNamed(context, 'customer_home_screen');
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
