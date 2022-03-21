import 'package:protalyze/pages/exercise_repository/ExerciseRepositoryPage.dart';
import 'package:protalyze/pages/timer_select/TimerSelectPage.dart';
import 'package:protalyze/provider/ExerciseNotifier.dart';
import 'package:protalyze/provider/PastWorkoutNotifier.dart';
import 'package:protalyze/provider/WorkoutNotifier.dart';
import 'package:protalyze/pages/past_workouts/PastWorkoutSelectionPage.dart';
import 'package:protalyze/persistance/Authentication.dart';
import 'package:protalyze/pages/workout_selection/WorkoutSelectionPage.dart';
import 'package:protalyze/common/widget/SalomonBottomBar.dart';
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
  final ExerciseNotifier _exerciseNotifier = ExerciseNotifier();
  final PastWorkoutNotifier _pastWorkoutNotifier = PastWorkoutNotifier();
  
  int _currentIndex = 0;
  List<Widget> _children = [];

  @override
  void initState() {
    this._workoutNotifier.getWorkoutsFromStore();
    this._pastWorkoutNotifier.getPastWorkoutsFromStore();
    this._exerciseNotifier.getExerciseBlocksFromStore();
    this._children = [
      MultiProvider(
        providers: [
        ChangeNotifierProvider.value(value: this._workoutNotifier),
        ChangeNotifierProvider.value(value: this._pastWorkoutNotifier),
        ],
        child: PastWorkoutSelectionPage(this.widget.logoutCallback),
      ),
      MultiProvider(
        providers: [
        ChangeNotifierProvider.value(value: this._workoutNotifier),
        ChangeNotifierProvider.value(value: this._exerciseNotifier),
        ChangeNotifierProvider.value(value: this._pastWorkoutNotifier),
        ],
        child: WorkoutSelectionPage(this.widget.logoutCallback),
      ),
      MultiProvider(
        providers: [
        ChangeNotifierProvider.value(value: this._exerciseNotifier),
        ],
        child: ExerciseRepositoryPage(this.widget.logoutCallback),
      ),
      MultiProvider(
        providers: [
        ChangeNotifierProvider.value(value: this._workoutNotifier),
        ChangeNotifierProvider.value(value: this._pastWorkoutNotifier),
        ],
        child: TimerSelectPage(),
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
        margin: EdgeInsets.only(left: 16, right: 16, bottom: 16),
        onTap: (index) => setState(() => _currentIndex = index), // new
        currentIndex: _currentIndex, // new
        items: [
          new SalomonBottomBarItem(
            icon: Icon(Icons.event_available_outlined),
            title: Text('Dashboard', ),
          ),
          new SalomonBottomBarItem(
            icon: Icon(Icons.list_alt_rounded),
            title: Text('Workouts'),
          ),
          new SalomonBottomBarItem(
            icon: Icon(Icons.fitness_center_outlined),
            title: Text('Exercises'),
          ),
          new SalomonBottomBarItem(
            icon: Icon(Icons.timer_outlined),
            title: Text('Timer'),
          ),
        ],
      ),
    );
  }
}