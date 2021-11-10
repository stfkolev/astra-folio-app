import 'package:astrafolioproject/pages/Schedule.dart';
import 'package:astrafolioproject/pages/Settings.dart';
import 'package:floating_bottom_navigation_bar/floating_bottom_navigation_bar.dart';

import 'package:animations/animations.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]).then((_) =>
      runApp(MyApp())
  );

}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  AppState createState() => AppState();

}

class AppState extends State<MyApp> {
  int _index = 0;

  dynamic pages = [
    SchedulePage(),
    SettingsPage()
  ];

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astra Folio',
      theme: ThemeData(
        primarySwatch: Colors.blue
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



