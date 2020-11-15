import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/bloc/WorkoutNotifier.dart';
import 'package:Protalyze/pages/PastWorkoutSelectionPage.dart';
import 'package:Protalyze/persistance/Authentication.dart';
import 'package:Protalyze/pages/WorkoutSelectionPage.dart';
import 'package:Protalyze/widgets/SalomonBottomBar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TabsPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  TabsPage(this.auth, this.logoutCallback);
  
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  
  final WorkoutNotifier _workoutNotifier = WorkoutNotifier();
  final PastWorkoutNotifier _pastWorkoutNotifier = PastWorkoutNotifier();
  
  int _currentIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    this._workoutNotifier.getWorkoutsFromStore();
    this._pastWorkoutNotifier.getPastWorkoutsFromStore();
    this._children = [
      MultiProvider(
        providers: [
        ChangeNotifierProvider.value(value: this._workoutNotifier),
        ChangeNotifierProvider.value(value: this._pastWorkoutNotifier),
        ],
        child: WorkoutSelectionPage(this.widget.logoutCallback),
      ),
      MultiProvider(
        providers: [
        ChangeNotifierProvider.value(value: this._workoutNotifier),
        ChangeNotifierProvider.value(value: this._pastWorkoutNotifier),
        ],
        child: PastWorkoutSelectionPage(this.widget.logoutCallback),
      ),
    ];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        children: _children,
        index: _currentIndex,
      ),
      bottomNavigationBar: SalomonBottomBar(
        // alignment: ,
        margin: EdgeInsets.all(16),
        onTap: (index) => setState(() => _currentIndex = index), // new
        currentIndex: _currentIndex, // new
        items: [
          new SalomonBottomBarItem(
            icon: Icon(Icons.timer),
            title: Text('Workouts'),
          ),
          new SalomonBottomBarItem(
            icon: Icon(Icons.event_available_outlined),
            title: Text('Log', ),
          ),
        ],
      ),
    );
  }
}