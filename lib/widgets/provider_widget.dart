
import 'package:flutter/material.dart';
import 'package:travel_budget_app/services/auth_service.dart';

class Provider extends InheritedWidget{
  final AuthService auth;
  Provider({Key key , Widget child , this.auth}) : super (key:key , child:child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    // TODO: implement updateShouldNotify
    return true;
  }

  static Provider of(BuildContext context) => (context.inheritFromWidgetOfExactType(Provider) as Provider);
}