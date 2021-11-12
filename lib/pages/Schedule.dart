import 'package:astrafolioproject/dialogs/AddEventDialog.dart';
import 'package:astrafolioproject/models/Event.dart';
import 'package:astrafolioproject/widgets/EventItemView.dart';

import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';


class SchedulePage extends StatefulWidget {
  SchedulePage({Key? key}) : super(key: key);

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  late DateTime _selectedDate;
  List<EventItem> _selectedEvents = [];

  List<EventItem> eventItems = [];

  dynamic events = [
    new Event(1, 'Audi S4', 'Живко Чукундура', DateTime.now().add(Duration(days: 3))),
    new Event(2, 'BMW X6', 'На Гошо бангията', DateTime.now().add(Duration(hours: 3))),
    new Event(3, 'Ferrari 599 GTB', 'За фолиране на предните джамове, щото не иска пагони да го виждат', DateTime.now().add(Duration(minutes: 48))),
    new Event(4, 'Каручката на бат Милчо', 'За тъпотии само', DateTime.now().add(Duration(days: 1, hours: 1, minutes: 12))),
  ];

  void onEventItemEdited(ev) {
    List<EventItem> _eventItems = eventItems;

    _eventItems.removeAt(_eventItems.indexWhere((element) => element.event.id == ev.id));
    _eventItems.add(EventItem(event: ev, onEventItemEdited: onEventItemEdited, onEventItemDeleted: onEventItemDeleted,));

    setState(() {
      eventItems = _eventItems;
    });

    updateEventItems();
  }

  void onEventItemDeleted(ev) {
    List<EventItem> _eventItems = eventItems;

    _eventItems.removeAt(_eventItems.indexWhere((element) => element.event.id == ev.id));

    setState(() {
      eventItems = _eventItems;
    });

    updateEventItems();
  }

  @override
  void initState() {
    super.initState();

    _resetSelectedDate();

    events.forEach(
        (element) => eventItems.add(EventItem(event: element, onEventItemEdited: onEventItemEdited, onEventItemDeleted: onEventItemDeleted,))
    );

    updateEventItems();
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  void updateEventItems() {
    _selectedEvents = [];

    eventItems.forEach((element) {
      if(element.event.timestamp.day == _selectedDate.day) {
        _selectedEvents.add(element);
      }
    });

    _selectedEvents.sort((left, right) => left.event.timestamp.compareTo(right.event.timestamp));

    setState(() {
      _selectedEvents = _selectedEvents;
    });
  }

  @override
  Widget build(BuildContext context) {
    String? swipeDirection = '';
    initializeDateFormatting();

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

          updateEventItems();
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

                    updateEventItems();
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
                  _selectedEvents.length == 0 ?
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
                    children: _selectedEvents,
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
                            child: AddEventDialog(onFormSubmit: (event) {
                              dynamic _eventItems = eventItems;
                              _eventItems.add(EventItem(event: event, onEventItemEdited: onEventItemEdited, onEventItemDeleted: onEventItemDeleted,));

                              setState(() {
                                eventItems = _eventItems;
                              });

                              updateEventItems();
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
  }
}