import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:travel_budget_app/widgets/provider_widget.dart';
import '../services/auth_service.dart';
import 'package:auto_size_text/auto_size_text.dart';

final primaryColor = const Color(0xFF75A2EA);
enum AuthFormType { signIn, signUp, reset, anonymous, convert }

class SignUpView extends StatefulWidget {
  final AuthFormType authFormType;

  const SignUpView({Key key, @required this.authFormType}) : super(key: key);
  @override
  _SignUpViewState createState() =>
      _SignUpViewState(authFormType: this.authFormType);
}

class _SignUpViewState extends State<SignUpView> {
  AuthFormType authFormType;
  _SignUpViewState({this.authFormType});

  final formKey = GlobalKey<FormState>();
  String _email, _password, _name, _warning;

  void switchFormState(String state) {
    formKey.currentState.reset();
    if (state == 'signUp') {
      setState(() {
        authFormType = AuthFormType.signUp;
      });
    } else if (state == 'home') {
      Navigator.of(context).pop();
    } else {
      setState(() {
        authFormType = AuthFormType.signIn;
      });
    }
  }

  bool validate() {
    final form = formKey.currentState;
    if (authFormType == AuthFormType.anonymous) {
      return true;
    }
    form.save();
    if (form.validate()) {
      form.save();
      return true;
    } else {
      return false;
    }
  }

  void submit() async {
    if (validate()) {
      try {
        final auth = Provider.of(context).auth;

        switch (authFormType) {
          case AuthFormType.signIn:
            await auth.signInWithEmailAndPassword(_email, _password);
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.signUp:
            await auth.createUserWithEmailAndPassword(_email, _password, _name);
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.reset:
            await auth.sendPasswordREsetEmail(_email);
            _warning = 'A password reset link has been sent to $_email';
            setState(() {
              authFormType = AuthFormType.signIn;
            });
            break;
          case AuthFormType.anonymous:
            await auth.signInAnonymously();
            Navigator.of(context).pushReplacementNamed('/home');
            break;
          case AuthFormType.convert:
            await auth.convertUserWithEmail(_email, _password, _name);
            Navigator.of(context).pop();
            break;
        }
      } catch (e) {
        print(e);
        setState(() {
          _warning = e.message;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final _height = MediaQuery.of(context).size.height;
    final _width = MediaQuery.of(context).size.width;

    if (authFormType == AuthFormType.anonymous) {
      submit();
      return Scaffold(
        backgroundColor: primaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SpinKitDoubleBounce(
              color: Colors.white,
            ),
            Text(
              'Loading',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      );
    } else {
      return Scaffold(
        body: SingleChildScrollView(
          child: Container(
            color: primaryColor,
            height: _height,
            width: _width,
            child: SafeArea(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: _height * 0.025,
                  ),
                  showAlert(),
                  SizedBox(
                    height: _height * 0.025,
                  ),
                  buildHeaderText(),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: buildInputs() + buildButtons(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget showAlert() {
    if (_warning != null) {
      return Container(
        color: Colors.amberAccent,
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.error_outline),
            ),
            Expanded(
              child: AutoSizeText(
                _warning,
                maxLines: 3,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    _warning = null;
                  });
                },
              ),
            )
          ],
        ),
      );
    }
    return SizedBox(height: 0);
  }

  AutoSizeText buildHeaderText() {
    String _headerText;
    if (authFormType == AuthFormType.signUp) {
      _headerText = 'Sign In';
    } else if (authFormType == AuthFormType.reset) {
      _headerText = 'Reset Password';
    } else {
      _headerText = 'Create New Account';
    }
    return AutoSizeText(
      _headerText,
      maxLines: 1,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 35,
        color: Colors.white,
      ),
    );
  }

  List<Widget> buildInputs() {
    List<Widget> textField = [];

    if (authFormType == AuthFormType.reset) {
      textField.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration('Email'),
          onSaved: (value) => _email = value,
        ),
      );
      textField.add(SizedBox(
        height: 20.0,
      ));
      return textField;
    }

    // if were in the sign up  state add name
    if ([AuthFormType.signUp, AuthFormType.convert].contains(authFormType)) {
      textField.add(
        TextFormField(
          validator: NameValidator.validate,
          style: TextStyle(fontSize: 22.0),
          decoration: buildSignUpInputDecoration('name'),
          onSaved: (value) => _name = value,
        ),
      );
      textField.add(SizedBox(
        height: 20.0,
      ));
    }
    // add email $ password
    textField.add(
      TextFormField(
        validator: EmailValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration('Email'),
        onSaved: (value) => _email = value,
      ),
    );
    textField.add(SizedBox(
      height: 20.0,
    ));
    textField.add(
      TextFormField(
        validator: PasswordValidator.validate,
        style: TextStyle(fontSize: 22.0),
        decoration: buildSignUpInputDecoration('password'),
        obscureText: true,
        onSaved: (value) => _password = value,
      ),
    );
    textField.add(SizedBox(
      height: 20.0,
    ));
    return textField;
  }

  InputDecoration buildSignUpInputDecoration(String hint) {
    return InputDecoration(
        hintText: hint,
        filled: true,
        focusColor: Colors.white,
        fillColor: Colors.white,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.0),
        ),
        contentPadding:
            const EdgeInsets.only(left: 14.0, bottom: 10.0, top: 10.0));
  }

  List<Widget> buildButtons() {
    String _switchButtonsText, _newFormState, _submitButtonsText;
    bool _showForgotPassword = false;
    bool _showSocial = true;

    if (authFormType == AuthFormType.signIn) {
      _switchButtonsText = 'Create New Account';
      _newFormState = 'signUp';
      _submitButtonsText = 'Sign In';
      _showForgotPassword = true;
    } else if (authFormType == AuthFormType.reset) {
      _switchButtonsText = 'Return to Sign In';
      _newFormState = 'signIp';
      _submitButtonsText = 'Submit';
      _showSocial = false;
    } else if (authFormType == AuthFormType.convert) {
      _switchButtonsText = 'Cancel';
      _newFormState = 'home';
      _submitButtonsText = 'Sign Up';
    } else {
      _switchButtonsText = 'Have An Account? Sign In';
      _newFormState = 'signIn';
      _submitButtonsText = 'Sign Up';
    }

    return [
      Container(
        width: MediaQuery.of(context).size.width * 0.7,
        child: RaisedButton(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          color: Colors.white,
          textColor: primaryColor,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              _submitButtonsText,
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w300),
            ),
          ),
          onPressed: submit,
        ),
      ),
      showForgetPassword(_showForgotPassword),
      FlatButton(
        child: Text(
          _switchButtonsText,
          style: TextStyle(color: Colors.white),
        ),
        onPressed: () {
          switchFormState(_newFormState);
        },
      ),
      buildSocialIcons(_showSocial),
    ];
  }

  Widget showForgetPassword(bool visible) {
    return Visibility(
      visible: visible,
      child: FlatButton(
        child: Text('Forget Password ?', style: TextStyle(color: Colors.white)),
        onPressed: () {
          setState(() {
            authFormType = AuthFormType.reset;
          });
        },
      ),
    );
  }

  Widget buildSocialIcons(bool visible) {
    final _auth = Provider.of(context).auth;
    return Visibility(
      child: Column(
        children: <Widget>[
          Divider(
            color: Colors.white,
          ),
          SizedBox(
            height: 10,
          ),
          GoogleSignInButton(
            onPressed: () async {
              try {
                if (authFormType == AuthFormType.convert) {
                  await _auth.convertWithGoogle();
                  Navigator.of(context).pop();
                } else {
                  await _auth.signInWithGoogle();
                  Navigator.of(context).pushReplacementNamed('/home');
                }
              } catch (e) {
                setState(() {
                  _warning = e.message;
                });
              }
            },
          ),
        ],
      ),
      visible: visible,
    );
  }
}
