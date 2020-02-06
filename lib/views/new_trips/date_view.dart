
import 'package:flutter/material.dart';
import 'package:travel_budget_app/models/trip.dart';
import 'package:travel_budget_app/views/new_trips/budget_view.dart';
import 'package:date_range_picker/date_range_picker.dart' as DateRangePicker;
import 'dart:async';
import 'package:intl/intl.dart';
class NewTripDateView extends StatefulWidget {
  final Trip trip;

  NewTripDateView({@required this.trip});

  @override
  _NewTripDateViewState createState() => _NewTripDateViewState();
}

class _NewTripDateViewState extends State<NewTripDateView> {
  DateTime _startDate = DateTime.now();
  DateTime _endDate = DateTime.now().add(Duration(days: 7));

  Future displayDateRangePicker(BuildContext context) async {
    final List<DateTime> picked = await DateRangePicker.showDatePicker(
        context: context,
        initialFirstDate: _startDate,
        initialLastDate: _endDate,
        firstDate: DateTime(DateTime.now().year -50),
        lastDate: DateTime(DateTime.now().year +50),);
    if (picked != null && picked.length == 2) {
      print(picked);
      setState(() {
        _startDate = picked[0];
        _endDate = picked[1];
      });

    }
  }

  @override
  Widget build(BuildContext context) {
//    _titleController.text = trip.title;

    return Scaffold(
      appBar: AppBar(
        title: Text('Create Trip - Date'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Location ${widget.trip.title} '),
            RaisedButton(
                child: Text('Select Dates'),
                onPressed: ()async{
              displayDateRangePicker(context);
            }),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Start Date ${DateFormat('MM/dd/yyyy').format(_startDate).toString()}'),
                Text('End Date ${DateFormat('MM/dd/yyyy').format(_endDate).toString()}'),
              ],
            ),
            RaisedButton(
                child: Text('Continue'),
                onPressed: () {
                  widget.trip.startDate = _startDate;
                  widget.trip.endDate = _endDate;

//                  trip.title = _titleController.text;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              NewTripBudgetView(trip: widget.trip)));
                })
          ],
        ),
      ),
    );
  }
}
