import 'package:flutter/material.dart';
import 'package:my_movie/pages/home_page.dart';
import 'package:my_movie/pages/search_page.dart';
import 'package:my_movie/pages/list_page.dart';
import 'package:my_movie/pages/about_page.dart';
import 'package:my_movie/pages/ai_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainPage> {
  int _selectedIndex = 0;
  
  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    ListPage(),
    AboutPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 22, 22, 22),

      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(10),
          child: Image.asset(
            'assets/images/splash.png',  // Make sure your logo is in assets folder and declared in pubspec.yaml
            fit: BoxFit.contain,
            height: 30,
            width: 30,
          ),
        ),
        title: Transform.translate(
          offset: Offset(-15, 0), // Move text 8 pixels to the left
          child: const Text(
            'MOVIES',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Color(0xFFff8a65),
              fontFamily: 'Anton', // or any custom font
            ),
          ),
        ),
        centerTitle: false,
        backgroundColor: const Color.fromARGB(255, 22, 22, 22),
        elevation: 0, // optional: remove shadow if you want a flat look
        actions: [
          IconButton(
            icon: const Icon(
              Icons.smart_toy_sharp, 
              color: Color(0xFFff8a65),
              size: 38,
            ),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                backgroundColor: Colors.deepOrange[200],
                builder: (context) {
                    return AiPage();
                }
              );
            },
          )
        ],
      ),

      
      body: _pages[_selectedIndex],

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromARGB(255, 22, 22, 22),
        elevation: 0,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.deepOrange[300],
        unselectedItemColor: Color(0xFFFAEBD7),
        selectedFontSize: 14,      // same font size
        unselectedFontSize: 14,    // no scaling animation
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.collections_bookmark_sharp),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'About',
          ),
        ],
      ),
    );
  }
}
