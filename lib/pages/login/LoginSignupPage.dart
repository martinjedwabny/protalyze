import 'package:firebase_auth/firebase_auth.dart';
import 'package:protalyze/config/Themes.dart';
import 'package:protalyze/pages/login/PrivacyTermsConditionsCheckbox.dart';
import 'package:protalyze/pages/login/PrivacyTermsConditionsText.dart';
import 'package:protalyze/persistance/Authentication.dart';
import 'package:protalyze/common/widget/SingleMessageAlertDialog.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;

  LoginSignupPage({this.auth, this.loginCallback});

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage> {
  bool isLoading = false;
  bool isLoginForm = true;
  bool isCreateAccountEnabled = false;
  String email = '';
  String password = '';
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: Stack(
      children: <Widget>[
        showForm(),
        showProgressIndicator(),
      ],
    ));
  }

  Widget showForm() {
    return new Container(
        padding: EdgeInsets.all(16.0),
        child: new Form(
          key: formKey,
          child: new ListView(
            shrinkWrap: true,
            children: <Widget>[
              showTitle(),
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrivacyTermsConditions(),
              showPrimaryButton(),
              showSecondaryButton(),
            ],
          ),
        ));
  }

  Widget showTitle() {
    return Center(
        child: Text(
      'Login or create an account',
      style: TextStyle(
          color: Themes.normal.primaryColor,
          fontSize: 40,
          fontWeight: FontWeight.w700),
    ));
  }

  Widget showProgressIndicator() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 0.0,
      width: 0.0,
    );
  }

  Widget showLogo() {
    return new Hero(
      tag: 'hero',
      child: Padding(
        padding: EdgeInsets.fromLTRB(0.0, 50.0, 0.0, 0.0),
        child: CircleAvatar(
          backgroundColor: Colors.transparent,
          radius: 48.0,
          child: Image.asset('assets/app_icon.png'),
        ),
      ),
    );
  }

  Widget showEmailInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 80.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        keyboardType: TextInputType.emailAddress,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Email',
            icon: new Icon(
              Icons.mail,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Email can\'t be empty' : null,
        onSaved: (value) => email = value.trim(),
      ),
    );
  }

  Widget showPasswordInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 0.0),
      child: new TextFormField(
        maxLines: 1,
        obscureText: true,
        autofocus: false,
        decoration: new InputDecoration(
            hintText: 'Password',
            icon: new Icon(
              Icons.lock,
              color: Colors.grey,
            )),
        validator: (value) => value.isEmpty ? 'Password can\'t be empty' : null,
        onSaved: (value) => password = value.trim(),
      ),
    );
  }

  Widget showPrimaryButton() {
    return new Padding(
        padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              elevation: 5.0,
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
            ),
            child: new Text(isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: isLoginForm || isCreateAccountEnabled
                ? () {
                    validateAndSubmit();
                  }
                : null,
          ),
        ));
  }

  Widget showSecondaryButton() {
    return new TextButton(
        child: new Text(
            isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  Widget showPrivacyTermsConditions() {
    return isLoginForm
        ? PrivacyTermsConditionsText('By continuing, you agree to our ')
        : PrivacyTermsConditionsCheckbox((tosAndPpAgreed) {
            setState(() {
              this.isCreateAccountEnabled = tosAndPpAgreed;
            });
          });
  }

  void toggleFormMode() {
    setState(() {
      isLoginForm = !isLoginForm;
    });
  }

  void resetForm() {
    formKey.currentState.reset();
  }

  void showErrorDialog(String title, message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return SingleMessageAlertDialog(title, message);
      },
    );
  }

  void validateAndSubmit() async {
    setState(() {
      isLoading = true;
    });
    if (validateAndSave()) {
      String userId = "";
      try {
        if (isLoginForm) {
          userId = await widget.auth.signIn(email, password);
          bool verified = widget.auth.emailVerified();
          if (userId.length > 0 && userId != null && verified) {
            widget.loginCallback();
          } else {
            widget.auth.sendEmailVerification();
            showErrorDialog(
                'Verify your email', 'Waiting for email verification');
          }
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(email, password);
          widget.auth.sendEmailVerification();
          isLoginForm = true;
          showErrorDialog(
              'Verify your email', 'Waiting for email verification');
          print('Signed up user: $userId');
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
          if (e is FirebaseAuthException && e.code == 'wrong-password')
            showWrongPasswordDialog('Error', e.message);
          else
            showErrorDialog('Error', e.message);
        });
      }
    } else {
      isLoading = false;
      showErrorDialog('Error', 'There was a problem, please retry.');
    }
  }

  void showWrongPasswordDialog(String title, String text) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(text),
                  SizedBox(
                    width: 1,
                    height: 20,
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 5.0,
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                    ),
                    child: new Text('Reset password',
                        style:
                            new TextStyle(fontSize: 20.0, color: Colors.white)),
                    onPressed: () {
                      resetPassword();
                      Navigator.of(context).pop();
                      showDialog(
                          context: context,
                          builder: (context) => SingleMessageAlertDialog(
                              'Reset password',
                              'An email has been sent. Please access your mailbox to reset your password.'));
                    },
                  ),
                ],
              ),
              actions: [
                TextButton(
                  child: Text("Ok"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
  }

  void resetPassword() {
    this.widget.auth.resetPassword(email);
  }

  bool validateAndSave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}
