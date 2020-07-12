import 'package:Protalyze/bloc/PastWorkoutNotifier.dart';
import 'package:Protalyze/bloc/WorkoutNotifier.dart';
import 'package:Protalyze/config/Themes.dart';
import 'package:Protalyze/pages/PastWorkoutSelectionPage.dart';
import 'package:Protalyze/persistance/Authentication.dart';
import 'package:Protalyze/pages/WorkoutSelectionPage.dart';
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
  @override
  Widget build(BuildContext context) {
    WorkoutNotifier workoutNotifier = WorkoutNotifier();
    workoutNotifier.getWorkoutsFromStore();
    PastWorkoutNotifier pastWorkoutNotifier = PastWorkoutNotifier();
    pastWorkoutNotifier.getPastWorkoutsFromStore();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            indicatorColor: Color.fromRGBO(255, 255, 255, 0.6),
            indicatorPadding: EdgeInsets.only(left:40.0, right:40.0),
            tabs: [
              Tab(text: 'WORKOUT',),
              Tab(text: 'LOG',),
            ],
          ),
          title: Text('Protalyze', style: Themes.normal.appBarTheme.textTheme.headline6,),
          centerTitle: true,
          actions: <Widget>[
            PopupMenuButton<String>(
              icon: Icon(Icons.more_vert, color: Colors.white,),
              onSelected: (String value){
                switch (value) {
                  case 'Logout':
                    handleLogout();
                    break;
                  // case 'Settings':
                  //   break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Logout'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ],
        ),
        body: TabBarView(
          children: [
            MultiProvider(
              providers: [
              ChangeNotifierProvider.value(value: workoutNotifier),
              ChangeNotifierProvider.value(value: pastWorkoutNotifier),
              ],
              child: WorkoutSelectionPage(),
            ),
            MultiProvider(
              providers: [
              ChangeNotifierProvider.value(value: workoutNotifier),
              ChangeNotifierProvider.value(value: pastWorkoutNotifier),
              ],
              child: PastWorkoutSelectionPage(),
            ),
          ],
        ),
      ),
    );
  }

  void handleLogout() {
    this.widget.logoutCallback();
  }
}