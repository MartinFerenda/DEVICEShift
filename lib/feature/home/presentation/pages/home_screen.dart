import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:device_shift/common/widgets/custom_app_bar.dart';
import 'package:device_shift/feature/home/presentation/pages/home_screen_details.dart';
import 'package:device_shift/feature/measurement_results/presentation/pages/results_screen.dart';
import 'package:device_shift/feature/vibration_measurement/presentation/pages/measurement_screen.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.title});

  final String title;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;

  final screens = [
    HomeScreenDetails(),
    MeasurementScreen(),
    ResultsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(currentScreen: index),
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        animationDuration: Duration(milliseconds: 400),
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.greenAccent,
        color: Colors.greenAccent,
        height: 60,
        index: index,
        items: [
          Icon(Icons.home_rounded),
          GestureDetector(
            onLongPress: () {
              //TODO: open simulation
              print('Long press!');
              setState(() {
                index = 1;
              });
            },
            child: Icon(Icons.line_axis_rounded),
          ),
          Icon(Icons.list_alt_rounded),
        ],
        onTap: (index){
          setState(() {
            this.index = index;
          });
        },
      ),
    );
  }
}