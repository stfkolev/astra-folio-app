import 'package:astrafolioproject/dialogs/AddEventDialog.dart';
import 'package:astrafolioproject/models/Event.dart';
import 'package:astrafolioproject/widgets/EventItemView.dart';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';


class ScheduleFirestorePage extends StatefulWidget {
  ScheduleFirestorePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<ScheduleFirestorePage> {
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();

    _resetSelectedDate();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    String? swipeDirection = '';
    initializeDateFormatting();

    return StreamBuilder(
      stream: FirebaseFirestore
          .instance
          .collection('astrafolio')
          .orderBy('timestamp', descending: false)
          .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if(!snapshot.hasData) return Text('Loading');

          return GestureDetector(
              onPanUpdate: (details) {
                if(details.delta.dx > 0) {
                  swipeDirection = 'left';
                } else if(details.delta.dx < 0) {
                  swipeDirection = 'right';
                }
              },
              onPanEnd: (details) {
                if(swipeDirection == null) {
                  return;
                } else if(swipeDirection == 'left') {
                  setState(() => {
                    _selectedDate = _selectedDate.subtract(Duration(days: 1))
                  });
                } else if(swipeDirection == 'right') {
                  setState(() => {
                    _selectedDate = _selectedDate.add(Duration(days: 1))
                  });
                }

                // updateEventItems();
              },
              child: Scaffold(
                body: Padding(
                  padding: EdgeInsets.only(top: 64.0, left: 16.0, right: 16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      CalendarTimeline(
                        showYears: true,
                        initialDate: _selectedDate,
                        firstDate: DateTime.now().subtract(Duration(days: 365)),
                        lastDate: DateTime.now().add(Duration(days: 365)),
                        onDateSelected: (date) {
                          setState(() {
                            _selectedDate = date;
                          });

                          // updateEventItems();
                        },
                        leftMargin: 20,
                        monthColor: Colors.black87,
                        dayColor: Colors.black87,
                        dayNameColor: Colors.white,
                        activeDayColor: Colors.white,
                        activeBackgroundDayColor: Color(0xFF135BFF),
                        dotsColor: Colors.white,
                        locale: 'bg',
                      ),
                      Expanded(
                        child:
                        snapshot.data!.docs.where((element) {
                          Map<String, dynamic> data = element.data()! as Map<String, dynamic>;

                          return (data['timestamp'] as Timestamp).toDate().day == _selectedDate.day;
                        }).isEmpty ?
                        Padding(
                            padding: EdgeInsets.only(top: 32.0),
                            child: Text(
                                'Няма събития за деня',
                                softWrap: true,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500,
                                )
                            )
                        )
                            :
                        ListView(
                          children: snapshot.data!.docs.where((element) {
                            Map<String, dynamic> data = element.data()! as Map<String, dynamic>;

                            return (data['timestamp'] as Timestamp).toDate().day == _selectedDate.day;
                          }).map((DocumentSnapshot document) {
                            Map<String, dynamic> data = document.data()! as Map<String, dynamic>;
                            return EventItem(event: Event(
                              data['id'],
                              data['name'],
                              data['description'],
                              (data['timestamp'] as Timestamp).toDate(),
                            ), onEventItemEdited: (event) async => await FirebaseFirestore
                                  .instance
                                  .collection('astrafolio')
                                  .doc(document.reference.id)
                                  .update(event.toJson()),
                                onEventItemDeleted: (event) async => await FirebaseFirestore
                                    .instance
                                .collection('astrafolio')
                                .doc(document.reference.id)
                                .delete()
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                floatingActionButton: FloatingActionButton(
                  backgroundColor: Color(0xFF135BFF),
                  onPressed: () => showDialog(
                      useSafeArea: true,
                      context: context,
                      builder: (BuildContext buildContext) {
                        return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(10.0)),
                            ),
                            title: Text('Добавяне на събитие', textAlign: TextAlign.center,),
                            content: Builder(
                                builder: (context) {
                                  var height = MediaQuery.of(context).size.height;
                                  var width = MediaQuery.of(context).size.width;

                                  return Container(
                                    height: height - 400,
                                    width: width + 400,
                                    child: Center(
                                      child: AddEventDialog(onFormSubmit: (event) async {
                                        await FirebaseFirestore
                                            .instance
                                            .collection('astrafolio')
                                            .add(event.toJson());

                                        Navigator.of(
                                            context, rootNavigator: true).pop();
                                      }),
                                    ),
                                  );
                                }
                            )
                        );
                      }
                  ),

                  tooltip: 'Добави събитие',
                  child: Icon(Icons.add),
                ), // This trailing comma makes auto-formatting nicer for build methods.
              )
          );
    });
  }
}