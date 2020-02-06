
import 'package:flutter/material.dart';
import 'package:travel_budget_app/services/auth_service.dart';
import 'package:travel_budget_app/views/home_view.dart';
import 'package:travel_budget_app/views/new_trips/first_view.dart';
import 'package:travel_budget_app/views/signup_view.dart';
import 'package:travel_budget_app/views/navigation_view.dart';
import 'package:travel_budget_app/widgets/provider_widget.dart';

void main() => runApp(MyApp());


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Provider(
      auth: AuthService(),
          child: MaterialApp(
        theme: ThemeData(primarySwatch: Colors.green),
        title: 'budget Travel App',
//      home: HomeWidget(),
      home: FirstView(),
        routes: <String , WidgetBuilder>{
          '/home': (BuildContext context) => HomeController(),
          '/singUp': (BuildContext context) => SignUpView(authFormType: AuthFormType.signUp,),
          '/signIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.signIn,),
          '/anonymousSignIn': (BuildContext context) => SignUpView(authFormType: AuthFormType.anonymous,),
          '/convertUser': (BuildContext context) => SignUpView(authFormType: AuthFormType.convert,),

        },
      ),
    );
  }
}


class HomeController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final AuthService auth = Provider.of(context).auth;

    return StreamBuilder(
      stream: auth.onAuthStateChanged,
      builder: (context , AsyncSnapshot<String> snapshot){
        if(snapshot.connectionState == ConnectionState.active){
          final bool signedIn = snapshot.hasData;
          return signedIn ? Home() : FirstView();
        }
        return CircularProgressIndicator();
      },
    );
  }
}

