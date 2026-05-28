import 'package:flutter/material.dart';
import 'package:moneytracker/screens/chart_screen.dart';
import 'package:moneytracker/screens/entry_screen.dart';
import 'package:moneytracker/screens/history_screen.dart';
import 'package:moneytracker/screens/home_screen.dart';
import 'package:moneytracker/screens/profile_screen.dart';

class ScreenManager extends StatefulWidget {
  const ScreenManager({super.key});

  @override
  State<ScreenManager> createState() => _ScreenManagerState();
}

class _ScreenManagerState extends State<ScreenManager> {
  int selectedIndex = 0;

  final screens = [
    const HomeScreen(),

    const EntryScreen(),

    const HistoryScreen(),

    const ChartScreen(),

    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Money Tracker",
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        backgroundColor: Colors.lightGreenAccent,
      ),

      body: screens[selectedIndex],

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),

        child: ClipRRect(
          borderRadius: BorderRadius.circular(30),

          child: NavigationBar(
            height: 70,
            elevation: 10,

            backgroundColor: const Color.fromARGB(134, 221, 228, 221),

            indicatorColor: const Color.fromARGB(255, 83, 218, 87).withValues(alpha: 0.25),

            selectedIndex: selectedIndex,

            onDestinationSelected: (index) {
              setState(() {
                selectedIndex = index;
              });
            },

            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),

                selectedIcon: Icon(Icons.home),

                label: "Home",
              ),

              NavigationDestination(
                icon: Icon(Icons.add_circle_outline),

                selectedIcon: Icon(Icons.add_circle),

                label: "Entry",
              ),

              NavigationDestination(
                icon: Icon(Icons.history_outlined),

                selectedIcon: Icon(Icons.history),

                label: "History",
              ),

              NavigationDestination(
                icon: Icon(Icons.bar_chart), 
                label: "Charts"),

              NavigationDestination(
                icon: Icon(Icons.person_outline),

                selectedIcon: Icon(Icons.person),

                label: "Profile",
              ),
            ],
          ),
        ),
      ),
    );
  }
}
