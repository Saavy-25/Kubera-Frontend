import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_kubera/src/models/user.dart';

// reference: https://pmatatias.medium.com/how-to-handle-and-share-login-state-with-provider-in-flutter-app-5c97c00500a4
class AuthState with ChangeNotifier {
 User? _user;
 bool _isAuthorized = false;

 List<Cookie> userSession(){
  if(_user != null){
    return _user!.headerCookies;}
    else{
      return [];
    }
 }

 bool get isAuthorized => _isAuthorized;

 String username(){
    return _user?.username ?? "guest";
 }

 void login(User user) {
    _user = user;
    _isAuthorized = true;
    notifyListeners();
  }

 void logout(){
   _user = null;
   _isAuthorized = false;
   notifyListeners();
 }

}