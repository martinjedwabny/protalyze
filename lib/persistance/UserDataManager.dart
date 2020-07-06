import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDataManager {

  static final String usersKey = 'users';
  static final String workoutsKey = 'workouts';

  static Future<List<Workout>> getSavedWorkouts() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    DocumentReference userDoc = Firestore.instance.collection(usersKey).document(user.uid);
    CollectionReference workoutsCollection = userDoc.collection(workoutsKey);
    List<Workout> ans;
    await workoutsCollection.getDocuments().then((value) {
      // ans = jsonDecode(value.);
      print(value.toString());
    });
    return ans;
  }

  static Future<void> addNewWorkout(Workout workout) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    DocumentReference userDoc = Firestore.instance.collection(usersKey).document(user.uid);
    CollectionReference workoutsCollection = userDoc.collection(workoutsKey);
    Map<String, dynamic> workoutJson = workout.toJson();
    workoutJson.remove('id');
    await workoutsCollection.add(workoutJson).then((doc) => workout.id = doc.documentID);
  }
}