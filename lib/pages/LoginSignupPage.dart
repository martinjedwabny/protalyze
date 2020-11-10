import 'package:Protalyze/persistance/Authentication.dart';
import 'package:flutter/material.dart';

class LoginSignupPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback loginCallback;

  LoginSignupPage({this.auth, this.loginCallback});

  @override
  State<StatefulWidget> createState() => new _LoginSignupPageState();
}

class _LoginSignupPageState extends State<LoginSignupPage>{
  
  bool isLoading = false;
  bool isLoginForm = true;
  String email = '';
  String password = '';
  String infoMessage = '';
  bool infoMessageIsError = true;
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Login or create an account'),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            showForm(),
            showCircularProgress(),
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
              showLogo(),
              showEmailInput(),
              showPasswordInput(),
              showPrimaryButton(),
              showSecondaryButton(),
              showInfoMessage(),
            ],
          ),
        ));
  }

  Widget showCircularProgress() {
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
        padding: EdgeInsets.fromLTRB(0.0, 45.0, 0.0, 0.0),
        child: SizedBox(
          height: 40.0,
          child: new RaisedButton(
            elevation: 5.0,
            shape: new RoundedRectangleBorder(
                borderRadius: new BorderRadius.circular(30.0)),
            child: new Text(isLoginForm ? 'Login' : 'Create account',
                style: new TextStyle(fontSize: 20.0, color: Colors.white)),
            onPressed: (){
              validateAndSubmit();
            },
          ),
        ));
  }

  Widget showSecondaryButton() {
    return new FlatButton(
        child: new Text(
            isLoginForm ? 'Create an account' : 'Have an account? Sign in',
            style: new TextStyle(fontSize: 18.0, fontWeight: FontWeight.w300)),
        onPressed: toggleFormMode);
  }

  void toggleFormMode() {
    setState(() {
      isLoginForm = !isLoginForm;
    });
  }

  void resetForm() {
    formKey.currentState.reset();
    infoMessage = "";
  }


Widget showInfoMessage() {
    if (infoMessage.length > 0 && infoMessage != null) {
      return new Text(
        infoMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 16.0,
            color: infoMessageIsError ? Colors.red : Colors.green,
            height: 1.0,
            fontWeight: FontWeight.w300),
      );
    } else {
      return new Container(
        height: 0.0,
      );
    }
  }

void validateAndSubmit() async {
    setState(() {
      infoMessage = "";
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
            infoMessage = 'Waiting for email verification';
            infoMessageIsError = false;
          }
          print('Signed in: $userId');
        } else {
          userId = await widget.auth.signUp(email, password);
          widget.auth.sendEmailVerification();
          isLoginForm = true;
          infoMessage = 'Waiting for email verification';
          infoMessageIsError = false;
          print('Signed up user: $userId');
        }
        setState(() {
          isLoading = false;
        });
      } catch (e) {
        print('Error: $e');
        setState(() {
          isLoading = false;
          infoMessage = e.message;
          infoMessageIsError = true;
        });
      }
    } else {
      isLoading = false;
      infoMessage = 'There was a problem, please retry.';
      infoMessageIsError = true;
    }
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