import 'package:Protalyze/pages/PastWorkoutSelectionPage.dart';
import 'package:Protalyze/persistance/Authentication.dart';
import 'package:Protalyze/pages/WorkoutSelectionPage.dart';
import 'package:flutter/material.dart';

class TabsPage extends StatefulWidget {
  final String userId;
  final BaseAuth auth;
  final VoidCallback logoutCallback;

  TabsPage(this.userId, this.auth, this.logoutCallback);
  
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.fitness_center, color: Colors.white,)),
              Tab(icon: Icon(Icons.event_note, color: Colors.white)),
            ],
          ),
          title: Text('Protalyze', style: TextStyle(fontFamily: 'Lobster', color: Colors.white),),
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
            WorkoutSelectionPage(auth: widget.auth,),
            PastWorkoutSelectionPage(),
          ],
        ),
      ),
    );
  }

  void handleLogout() {
    this.widget.logoutCallback();
  }
}