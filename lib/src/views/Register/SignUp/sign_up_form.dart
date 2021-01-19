import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:opakuStore/src/helpers/TextStyle.dart';
import 'package:opakuStore/src/helpers/colors_constant.dart';
import 'package:opakuStore/src/helpers/screen.dart';
import 'package:opakuStore/src/views/Register/SignUp/sign_up_controller.dart';
import 'package:opakuStore/src/widgets/button_raised.dart';
import 'package:opakuStore/src/widgets/input_text.dart';

class SignUpView extends StatefulWidget {
  SignUpView({this.typeAccount});
  final String typeAccount;
  @override
  _SignUpViewState createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  List<String> gender = ['Male', 'Female'];
  String genderData = 'Choose Gender';

  bool _isRegisterLoading = true;
  SignUpController signUpController = new SignUpController();

  String _fullName = '';
  String _email = '';
  String _phone = '';
  String _password = '';
  String _confirmPwd = '';

  get analytics => FirebaseAnalytics();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        // TODO: Full Name
        StreamBuilder(
          stream: signUpController.fullNameStream,
          builder: (context, snapshot) => InputText(
            title: 'Full Name',
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _fullName = value;
            },
            icon: null,
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(18),
        ),
        //TODO: phone number
        StreamBuilder(
          stream: signUpController.phoneStream,
          builder: (context, snapshot) => InputText(
            title: 'Phone number',
            inputType: TextInputType.number,
            errorText: snapshot.hasError ? snapshot.error : '',
            onValueChange: (value) {
              _phone = value;
            },
            icon: null,
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(18),
        ),
        //TODO: email
        StreamBuilder(
          stream: signUpController.emailStream,
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
          stream: signUpController.passwordStream,
          builder: (context, snapshot) => InputText(
            title: 'Password',
            errorText: snapshot.hasError ? snapshot.error : '',
            isPassword: true,
            onValueChange: (value) {
              _password = value;
            },
            icon: null,
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(18),
        ),
        //TODO: Confirm Password
        StreamBuilder(
          stream: signUpController.confirmPwdSteam,
          builder: (context, snapshot) => InputText(
            title: 'Confirm',
            errorText: snapshot.hasError ? snapshot.error : '',
            isPassword: true,
            onValueChange: (value) {
              _confirmPwd = value;
            },
            icon: null,
          ),
        ),
        SizedBox(
          height: ConstScreen.setSizeHeight(25),
        ),
        StreamBuilder(
            stream: signUpController.btnLoadingStream,
            builder: (context, snapshot) {
              return CusRaisedButton(
                backgroundColor: kColorBlack,
                isDisablePress: snapshot.hasData ? snapshot.data : true,
                title: 'REGISTER',
                onPress: () async {
                  bool result = await signUpController.onSubmitRegister(
                      fullName: _fullName,
                      phone: _phone,
                      email: _email,
                      password: _password,
                      confirmPwd: _confirmPwd,
                      typeAccount: widget.typeAccount);
                  await FirebaseAnalytics().logEvent(
                      name:'general_event',
                      parameters: filterOutNulls(<String, dynamic>{
                        "event_category": "Registration and Login",
                        "event_action" : "Registration",
                        "event_label" : "Register Button Clicked",
                      }));

                  if (result) {
                    if (widget.typeAccount == 'customer') {
                      Navigator.pushNamed(context, 'customer_home_screen');
                    } else {
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
                                'Adding User Complete',
                                style: kBoldTextStyle.copyWith(
                                    fontSize: FontSize.s28),
                              ),
                            )
                          ],
                        ),
                      ));
                    }
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
                              'Sign Up failed.',
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
            }),
      ],
    );
  }
}
