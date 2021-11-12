import 'package:astrafolioproject/pages/Schedule.dart';
import 'package:astrafolioproject/pages/ScheduleFirestore.dart';
import 'package:astrafolioproject/pages/Settings.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

import 'package:animations/animations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();

}

class AppState extends State<MyApp> {
  int _index = 0;

  dynamic pages = [
    ScheduleFirestorePage(),
    SettingsPage()
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astra Folio',
      theme: ThemeData(
        primarySwatch: MaterialColor(0xFF135BFF, {
          50: Color.fromRGBO(19, 91, 255, .1),
          100: Color.fromRGBO(19, 91, 255, .2),
          200: Color.fromRGBO(19, 91, 255, .3),
          300: Color.fromRGBO(19, 91, 255, .4),
          400: Color.fromRGBO(19, 91, 255, .5),
          500: Color.fromRGBO(19, 91, 255, .6),
          600: Color.fromRGBO(19, 91, 255, .7),
          700: Color.fromRGBO(19, 91, 255, .8),
          800: Color.fromRGBO(19, 91, 255, .9),
          900: Color.fromRGBO(19, 91, 255, 1),
        })
      ),
      home: Scaffold(
        body: PageTransitionSwitcher(
          transitionBuilder: (
            child,
            primaryAnimation,
            secondaryAnimation
          ) => FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            // transitionType: SharedAxisTransitionType.horizontal,
            child: child,
          ),
          child: pages[_index],
        ),
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
            FloatingNavbarItem(icon: Icons.calendar_today, title: 'График'),
            FloatingNavbarItem(icon: Icons.settings, title: 'Настройки'),
          ]
        ),
      ),
    );
  }
}



