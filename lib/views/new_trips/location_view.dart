import 'package:flutter/material.dart';
import 'package:travel_budget_app/models/trip.dart';
import 'package:travel_budget_app/views/new_trips/date_view.dart';

class NewTripLocationView extends StatelessWidget {
  
  final Trip trip;
  NewTripLocationView({@required this.trip});
  
  TextEditingController _titleController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    _titleController.text = trip.title;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip - Location'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Enter A Location'),
            Padding(padding: EdgeInsets.all(30.0) , child: TextField(
              controller: _titleController,
              autofocus: true,
            ),),
            RaisedButton(
                child: Text('Continue'),
                onPressed: (){
                  trip.title = _titleController.text;
                  Navigator.push(context, MaterialPageRoute(builder: (context) => NewTripDateView(trip: trip)));
            })
          ],
        ),
      ),
    );
  }
}
