import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:VBlackBox/guides_page.dart';
import 'package:VBlackBox/stats_page.dart';

import 'news_page.dart';

void main() {
  HttpOverrides.global = MyHttpOverrides();
  runApp(MainApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }

  @override
  noSuchMethod(Invocation invocation) {
    // your implementation here
  }
}

class MainApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'VBlackBox',
      theme: ThemeData(
          fontFamily: 'DINNext',
          primaryColor: Colors.white,
          primaryColorDark: Colors.white70,
          accentColor: Color(0xffff4655),
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0x0))),
      darkTheme: ThemeData(
          fontFamily: 'DINNext',
          brightness: Brightness.dark,
          accentColor: Color(0xffff4655),
          bottomSheetTheme: BottomSheetThemeData(backgroundColor: Color(0x0))),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  HomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  int _currentIndex = 0;
  BuildContext _appContext;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _appContext = context;
    _setSystemTheme();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: <Widget>[
          // NewsPage(),
          StatsPage(), GuidesPage()
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onTabTapped,
        currentIndex: _currentIndex,
        items: [
          // BottomNavigationBarItem(
          //   icon: new Icon(Icons.home),
          //   label: "Home",
          // ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.account_circle),
            label: "Stats",
          ),
          BottomNavigationBarItem(
            icon: new Icon(Icons.library_books),
            label: "Guides",
          )
        ],
        selectedItemColor: Theme.of(context).accentColor,
        //backgroundColor: Theme.of(context).cardColor,
      ),
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _setSystemTheme();
    }
  }

  void _setSystemTheme() {
    if (MediaQuery.of(_appContext).platformBrightness == Brightness.dark) {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Color(0),
          systemNavigationBarColor: Colors.black,
          systemNavigationBarIconBrightness: Brightness.light));
    } else {
      SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
          statusBarColor: Color(0),
          systemNavigationBarColor: Colors.grey[200],
          systemNavigationBarIconBrightness: Brightness.dark));
    }
  }
}
