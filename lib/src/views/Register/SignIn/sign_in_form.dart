import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:opakuStore/src/helpers/TextStyle.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/views/Register/SignIn/sign_in_controller.dart';
import 'package:opakuStore/src/widgets/button_raised.dart';
import 'package:opakuStore/src/widgets/input_text.dart';

class SignInView extends StatefulWidget {
  @override
  _SignInViewState createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool _isAdmin = false;
  SignInController signInController = new SignInController();
  String _email = '';
  String _password = '';
  get analytics => FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        //TODO: Username
        StreamBuilder(
          stream: signInController.emailStream,
          builder: (context, snapshot) => InputText(
            title: 'Email',
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _email = value;
            },
            icon: null,
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(18),
        ),
        //TODO: Password
        StreamBuilder(
          stream: signInController.passwordStream,
          builder: (context, snapshot) => InputText(
            title: 'Password',
            isPassword: true,
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _password = value;
            },
            icon: null,
          ),
        ),
        //TODO: Button Sign In
        SizedBox(
          height: ConstScreen.setSizeHeight(20),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //TODO: Admin
            Expanded(
              child: MaterialButton(
                height: ConstScreen.setSizeHeight(90),
                color: _isAdmin ? kColorBlack : kColorWhite,
                child: Text(
                  'ADMIN',
                  style: TextStyle(
                      color: _isAdmin ? kColorWhite : kColorBlack,
                      fontSize: FontSize.s30),
                ),
                onPressed: () async{
                  await analytics.logEvent(
                      name:'general_event',
                      parameters: filterOutNulls(<String, dynamic>{
                        "event_category": "Registrasi and Login",
                        "event_action" : "Login",
                        "event_label" : "Login as Admin Button Clicked",
                      }));
                  setState(() {
                    _isAdmin = true;
                  });
                },
              ),
            ),
            //TODO: Customer
            Expanded(
              child: MaterialButton(
                height: ConstScreen.setSizeHeight(90),
                color: _isAdmin ? kColorWhite : kColorBlack,
                child: Text(
                  'CUSTOMER',
                  style: TextStyle(
                      color: _isAdmin ? kColorBlack : kColorWhite,
                      fontSize: FontSize.s30),
                ),
                onPressed: () async{
                  await analytics.logEvent(
                      name:'general_event',
                      parameters: filterOutNulls(<String, dynamic>{
                        "event_category": "Registrasi and Login",
                        "event_action" : "Login",
                        "event_label" : "Login as Customer Button Clicked",
                      }));
                  setState(() {
                    _isAdmin = false;
                  });
                },
              ),
            ),
          ],
        ),

        SizedBox(
          height: ConstScreen.setSizeHeight(25),
        ),
        StreamBuilder(
            stream: signInController.btnLoadingStream,
            builder: (context, snapshot) {
              return CusRaisedButton(
                backgroundColor: kColorBlack,
                title: 'SIGN IN',
                isDisablePress: snapshot.hasData ? snapshot.data : true,
                onPress: () async {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus) {
                    currentFocus.unfocus();
                  }
                  var result = await signInController.onSubmitSignIn(
                      email: _email, password: _password, isAdmin: _isAdmin);
                  print('Screen' + result.toString());

                  if (result != '') {
                    Navigator.pushNamed(context, result);
                    SignInController().dispose();
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
                              'Sign In failed.',
                              style: kBoldTextStyle.copyWith(
                                  fontSize: FontSize.s28),
                            ),
                          )
                        ],
                      ),
                    ));
                  }
                },
              );
            })
      ],
    );
  }
}
