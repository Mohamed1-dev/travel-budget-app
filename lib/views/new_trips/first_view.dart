import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:travel_budget_app/widgets/custom_dialog.dart';

class FirstView extends StatelessWidget {
  final primaryColor = const Color(0xFF75A2EA);

  @override
  Widget build(BuildContext context) {
    final _width = MediaQuery.of(context).size.width;
    final _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        width: _width,
        height: _height,
        color: primaryColor,
        child: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              SizedBox(
                height: _height * 0.10,
              ),
              Text(
                'Welome',
                style: TextStyle(fontSize: 44, color: Colors.white),
              ),
              SizedBox(
                height: _height * 0.10,
              ),
              AutoSizeText(
                "Let's Start Planning Your Next Trip",
                maxLines: 2,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 40, color: Colors.white),
              ),
              SizedBox(
                height: _height * 0.15,
              ),
              RaisedButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0)),
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 15.0, horizontal: 30.0),
                    child: Text(
                      'Get Started',
                      style: TextStyle(
                          color: primaryColor,
                          fontSize: 28.0,
                          fontWeight: FontWeight.w300),
                    ),
                  ),
                  onPressed: () {
                    showDialog(context: context , builder: (context) => CustomDialog(
                      title: 'Would you like to create a free Account !',
                      description: 'With an account your data will be securly saved , allowing you to access our content .',
                      primaryButtonText: 'Create My Account',
                      primaryButtonRoute: '/singUp',
                      secondaryButtonText: 'Maybe Later',
                      secondaryButtonRoute: '/anonymousSignIn',
                    ));
                  }),
              SizedBox(
                height: _height * 0.05,
              ),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed('/signIn');
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                    ),
                  ))
            ],
          ),
        )),
      ),
    );
  }
}
