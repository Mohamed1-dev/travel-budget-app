import 'package:flutter/material.dart';
import 'package:travel_budget_app/models/trip.dart';
import 'package:travel_budget_app/services/auth_service.dart';
import 'package:travel_budget_app/views/home_view.dart';
import 'package:travel_budget_app/views/new_trips/location_view.dart';
import 'package:travel_budget_app/widgets/provider_widget.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeView(),
    Explore(),
    Past(),
  ];

  @override
  Widget build(BuildContext context) {
    final newTrip = Trip(
      null,
      null,
      null,
      null,
      null,
    );
    return Scaffold(
      appBar: AppBar(
        title: Text('Travel Budget App'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            NewTripLocationView(trip: newTrip)));
              }),
          IconButton(
              icon: Icon(Icons.undo),
              onPressed: () async {
                try {
                  AuthService auth = Provider.of(context).auth;
                  await auth.signOut();
                  print('Signed Out !!!!');
                } catch (e) {
                  print(e);
                } 
              }),
          IconButton(
              icon: Icon(Icons.account_circle),
              onPressed: () async {
               Navigator.of(context).pushNamed('/convertUser');
              }),
        ],
      ),
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home), title: Text('Home')),
            BottomNavigationBarItem(
                icon: Icon(Icons.explore), title: Text('explore')),
            BottomNavigationBarItem(
                icon: Icon(Icons.history), title: Text('Past')),
          ]),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}

class Explore extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
    );
  }
}

class Past extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
    );
  }
}
