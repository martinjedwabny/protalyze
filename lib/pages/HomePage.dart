import 'package:Surger/config/Themes.dart';
import 'package:Surger/pages/WorkoutSelectionPage.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_run, color: Colors.white,)),
                Tab(icon: Icon(Icons.event_note, color: Colors.white)),
              ],
            ),
            title: Text('Surger', style: TextStyle(fontFamily: 'Lobster', color: Colors.white),),
            centerTitle: true,
          ),
          body: TabBarView(
            children: [
              WorkoutSelectionPage(),
              Icon(Icons.event_note),
            ],
          ),
        ),
      ),
      theme: Themes.normal,
    );
  }
}