import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:opakuStore/src/helpers/shared_preferrence.dart';
import 'package:opakuStore/src/helpers/utils.dart';
import 'package:opakuStore/src/helpers/validator.dart';
import 'package:opakuStore/src/model/user.dart';

class SignInController {
  StreamController _isEmail = new StreamController();
  StreamController _isPassword = new StreamController();
  StreamController _isBtnLoading = new StreamController();

  Stream get emailStream => _isEmail.stream;
  Stream get passwordStream => _isPassword.stream;
  Stream get btnLoadingStream => _isBtnLoading.stream;

  Validators validators = new Validators();
  get analytics => FirebaseAnalytics();


  Future<String> onSubmitSignIn({
    @required String email,
    @required String password,
    @required bool isAdmin,
  }) async {
    int countError = 0;
    String result = '';
    _isEmail.sink.add('Ok');
    _isPassword.sink.add('Ok');

    if (!validators.isValidEmail(email)) {
      _isEmail.sink.addError('Invalid email address.');
      countError++;
    }

    if (!validators.isPassword(password)) {
      _isPassword.addError('Invaid password.');
      countError++;
    }

    //TODO: Sign in function
    if (countError == 0) {
      try {
        _isBtnLoading.sink.add(false);
        FirebaseAuth auth = FirebaseAuth.instance;
        FirebaseUser firebaseUser = (await auth.signInWithEmailAndPassword(
                email: email, password: password))
            .user;
        String uid = firebaseUser.uid;
        await Firestore.instance
            .collection('Users')
            .document(uid)
            .get()
            .then((DocumentSnapshot snapshot) async {
          User user = new User(
              snapshot.data['fullname'],
              snapshot.data['username'],
              snapshot.data['password'],
              snapshot.data['gender'],
              snapshot.data['birthday'],
              snapshot.data['phone'],
              snapshot.data['address'],
              snapshot.data['create_at'],
              snapshot.data['id_scripe'],
              snapshot.data['type']);
          print(user.toJson());
          await FirebaseAnalytics().logEvent(
              name:'general_event',
              parameters: filterOutNulls(<String, dynamic>{
                "event_category": "Registrasi and Login",
                "event_action" : "Login",
                "event_label" : "Successful Login",
                "userID" : uid,
              }));

          //TODO: Navigator
          if (isAdmin) {
            //TODO: Admin Sign In
            if (snapshot.data['type'] == 'admin') {
              result = 'admin_home_screen';
              //TODO: Add data to shared preference
              StorageUtil.setUid(uid);
              StorageUtil.setFullName(snapshot.data['fullname']);
              StorageUtil.setIsLogging(true);
              StorageUtil.setUserInfo(user);
              StorageUtil.setAccountType('admin');
              StorageUtil.setPassword(password);
            }
          } else {
            //TODO: Customer Sign In
            if (snapshot.data['type'] == 'customer') {
              result = 'customer_home_screen';
              //TODO: Add data to shared preference
              StorageUtil.setUid(uid);
              StorageUtil.setFullName(snapshot.data['fullname']);
              StorageUtil.setIsLogging(true);
              StorageUtil.setUserInfo(user);
              StorageUtil.setAccountType('customer');
              StorageUtil.setPassword(Util.encodePassword(password));
            }
          }
        });
      } catch (e) {
        _isBtnLoading.sink.add(true);
      }
      _isBtnLoading.sink.add(true);
      return result;
    }
  }

  void dispose() {
    _isEmail.close();
    _isPassword.close();
    _isBtnLoading.close();
  }
}
