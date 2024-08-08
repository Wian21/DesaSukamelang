import 'package:flutter/material.dart';
import 'package:untitled3/homepage.dart';
import 'package:untitled3/screens/isi_data.dart';
import 'package:untitled3/screens/profil.dart';

class BottomNavBar extends StatefulWidget {
  BottomNavBar({Key? key}) : super(key: key);

  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    Homepage(),
    IsiDataPage(),
    ProfileScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Widget _buildIcon(IconData icon, int index) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Icon(icon, color: _selectedIndex == index ? Color.fromARGB(255, 84, 41, 255) : Colors.black),
        if (_selectedIndex == index)
          Container(
            height: 2,
            width: 24,
            color: Color.fromARGB(255, 84, 41, 255),
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        
        index: _selectedIndex,
        children: _screens,
        
      ),
       bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 245, 255, 250),
        showSelectedLabels: false,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.home, 0),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.add_circle_rounded, 1),
            label: '',
          ),
          // BottomNavigationBarItem(
          //   icon: _buildIcon(Icons.search, 2),
          //   label: '',
          // ),
          // BottomNavigationBarItem(
          //   icon: _buildIcon(Icons.list_alt, 3),
          //   label: '',
          // ),
          BottomNavigationBarItem(
            icon: _buildIcon(Icons.person, 2),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromARGB(255, 84, 41, 255),
        unselectedItemColor: Colors.black,
        onTap: _onItemTapped,
      ),
    );
  }
}
