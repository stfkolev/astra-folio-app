import 'package:calendar_timeline/calendar_timeline.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'dart:developer' as developer;

import 'models/Event.dart';
import 'widgets/EventItemView.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astra Folio Scheduler',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _index = 0;
  late DateTime _selectedDate;
  List<EventItem> _selectedEvents = [];

  List<EventItem> eventItems = [];

  dynamic events = [
    new Event('Audi S4', 'Живко Чукундура', DateTime.now().add(Duration(days: 3))),
    new Event('BMW X6', 'На Гошо бангията', DateTime.now().add(Duration(hours: 3))),
    new Event('Ferrari 599 GTB', 'За фолиране на предните джамове, щото не иска пагони да го виждат', DateTime.now().add(Duration(minutes: 48))),
    new Event('Каручката на бат Милчо', 'За тъпотии само', DateTime.now().add(Duration(days: 1, hours: 1, minutes: 12))),
  ];

  @override
  void initState() {
    super.initState();
    _resetSelectedDate();

    events.forEach(
        (element) => eventItems.add(EventItem(event: element))
    );

    eventItems.forEach((element) {
      developer.log('Element: ${element.event.timestamp.day} -- Selected Date: $_selectedDate');

      if(element.event.timestamp.day == _selectedDate.day) {
        _selectedEvents.add(element);
      }

      _selectedEvents.sort((left, right) => left.event.timestamp.compareTo(right.event.timestamp));
    });
  }

  void _resetSelectedDate() {
    _selectedDate = DateTime.now();
  }

  @override
  Widget build(BuildContext context) {

    initializeDateFormatting();

    return Scaffold(
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

                _selectedEvents = [];

                eventItems.forEach((element) {
                  developer.log('Element: ${element.event.timestamp.day} -- Date: $date}');
                  if(element.event.timestamp.day == date.day) {
                    _selectedEvents.add(element);
                  }
                });

                _selectedEvents.sort((left, right) => left.event.timestamp.compareTo(right.event.timestamp));
              },
              leftMargin: 20,
              monthColor: Colors.black87,
              dayColor: Colors.black87,
              dayNameColor: Colors.white,
              activeDayColor: Colors.white,
              activeBackgroundDayColor: Color(0xFF135BFF),
              dotsColor: Colors.white,
              locale: 'en',
            ),
            Expanded(
              child:
              _selectedEvents.length == 0 ?
                Text('No events for this day')
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
        onPressed: () => '',
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
      bottomNavigationBar: FloatingNavbar(
        backgroundColor: Colors.white70.withOpacity(0.5),
        borderRadius: 500,
        itemBorderRadius: 500,
        unselectedItemColor: Colors.black87,
        selectedItemColor: Colors.white,
        selectedBackgroundColor: Color(0xFF135BFF),
        onTap: (int val) => setState(() => _index = val),
        currentIndex: _index,
        items: [
          FloatingNavbarItem(icon: Icons.calendar_today, title: 'Schedule'),
          FloatingNavbarItem(icon: Icons.settings, title: 'Settings'),
        ]
      ),
    );
  }
}
