import 'package:flutter/material.dart';
import 'feed_screen.dart'; // Assuming this file contains the FeedScreen class
import 'portfolio_page.dart'; // Assuming this file contains the PortfolioScreen class

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    FeedScreen(),
    PortfolioScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          toolbarHeight: 90,
          backgroundColor: Colors.white,
          title: Padding(
            padding: const EdgeInsets.all(55.0),
            child: Image.asset(
              'assets/images/header.png',
              fit: BoxFit.cover,
            ),
          )),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Feed'),
          BottomNavigationBarItem(
              icon: Icon(Icons.business), label: 'Portfolio'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
