
import 'package:flutter/material.dart';
import 'package:travel_budget_app/models/trip.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:travel_budget_app/widgets/provider_widget.dart';

class NewTripBudgetView extends StatelessWidget {
final db = Firestore.instance;

  final Trip trip;
  NewTripBudgetView({@required this.trip});

//  TextEditingController _titleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
//    _titleController.text = trip.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create - Budget'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Finish '),
            Text('Location ${trip.title} '),
            Text('Start Date ${trip.startDate} '),
            Text('End Date ${trip.endDate} '),


            RaisedButton(
                child: Text('Continue'),
                onPressed: ()async{
//                  save data to fiebase
            final uid= await Provider.of(context).auth.getCurrentUID();
                await db..collection('userData').document(uid).collection('trips').add(trip.toJson());
                  Navigator.of(context).popUntil((route) => route.isFirst);
                })
          ],
        ),
      ),
    );
  }
}
