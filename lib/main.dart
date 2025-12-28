import 'package:flutter/material.dart';
import 'package:hisstoriapp/home.dart';
import 'package:hisstoriapp/profile.dart';
import 'package:hisstoriapp/saved.dart';
import 'package:hisstoriapp/map.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    home(),
    map(),
    Saved(),
    profile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedItemColor: Colors.deepOrange[900],
        unselectedItemColor: Colors.black,
        currentIndex: _currentIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_filled, size: 30,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined, size: 30,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bookmark, size:30,),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, size:30),
            label: '',
          ),

        ],
      ),
    );
  }
}


