import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:travel_budget_app/widgets/provider_widget.dart';

 

class HomeView extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Container(
      child: StreamBuilder(
        stream: getUserTripsStreamsnapshot(context),
        builder: (context, snapshot) {
          if(!snapshot.hasData) return const Text('Loading...');
          return ListView.builder(
              itemCount:  snapshot.data.documents.length,
              itemBuilder: (BuildContext context, int index) =>
                  buildTripCard(context, snapshot.data.documents[index]));
        }
      ),
    );
  }

Stream<QuerySnapshot> getUserTripsStreamsnapshot(BuildContext context)async*{
  final uid = await Provider.of(context).auth.getCurrentUID();
  yield* Firestore.instance.collection('userData').document(uid).collection('trips').snapshots();
}
  Widget buildTripCard(BuildContext context, DocumentSnapshot trip) {
     return Container(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 8.0 , bottom: 4.0),
                child: Row(
                  children: <Widget>[
                    Text(trip['title'] , style: TextStyle(fontSize: 30.0),),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top:4.0 , bottom: 80.0),
                child: Row(
                  children: <Widget>[
                    Text(
                        '${DateFormat('dd/MM/yyyy').format(trip['startDate'].toDate()).toString()}  -  ${DateFormat('dd/MM/yyyy').format(trip['endDate'].toDate()).toString()}'),
                    Spacer(),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0 , bottom: 8.0),
                child: Row(
                  children: <Widget>[
                    Text('${(trip['budget'] == null) ? "n/a": trip['budget'].toStringAsFixed(2)}', style: TextStyle(fontSize: 35.0),),
                    Spacer(),
                    Icon(Icons.directions_car)
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
