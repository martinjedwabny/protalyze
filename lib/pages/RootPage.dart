import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:protalyze/persistance/Authentication.dart';
import 'package:protalyze/pages/login/LoginSignupPage.dart';
import 'package:protalyze/pages/TabsPage.dart';

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  RootPage({this.auth});
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  String userId = "";

  @override
  void initState() {
    super.initState();
      User user = widget.auth.getCurrentUser();
      setState(() {
        if (user != null) {
          userId = user?.uid;
        }
        authStatus = user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
        });
    }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitingScreen();
        break;
      case AuthStatus.NOT_LOGGED_IN:
        return new LoginSignupPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      case AuthStatus.LOGGED_IN:
        if (userId.length > 0 && userId != null) {
          return TabsPage(widget.auth, logoutCallback);
        } else
          return buildWaitingScreen();
        break;
      default:
        return buildWaitingScreen();
    }
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  void loginCallback() {
    User user = widget.auth.getCurrentUser();
    setState(() {
      userId = user.uid.toString();
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      widget.auth.signOut();
      authStatus = AuthStatus.NOT_LOGGED_IN;
      userId = "";
    });
  }
}