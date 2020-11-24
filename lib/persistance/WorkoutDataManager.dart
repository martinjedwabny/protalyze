import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Protalyze/common/domain/Workout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutDataManager {

  static final String usersKey = 'users';
  static final String workoutsKey = 'workouts';

  static Future<List<Workout>> getSavedWorkouts() async {
    CollectionReference workoutsCollection = await getWorkoutCollection();
    QuerySnapshot query = await workoutsCollection.get();
    return query.docs.map((e) { 
      Workout workout = Workout.fromJson(e.data());
      workout.documentId = e.id;
      return workout;
    }).toList();
  }

  static Future<CollectionReference> getWorkoutCollection() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    DocumentReference userDoc = FirebaseFirestore.instance.collection(usersKey).doc(user.uid);
    CollectionReference workoutsCollection = userDoc.collection(workoutsKey);
    return workoutsCollection;
  }

  static Future<void> addWorkout(Workout workout) async {
    CollectionReference workoutsCollection = await getWorkoutCollection();
    Map<String, dynamic> workoutJson = workout.toJson();
    DocumentReference doc = await workoutsCollection.add(workoutJson);
    workout.documentId = doc.id;
  }

  static Future<void> updateWorkout(Workout workout) async {
    if (workout.documentId == null)
      return;
    CollectionReference workoutsCollection = await getWorkoutCollection();
    Map<String, dynamic> workoutJson = workout.toJson();
    DocumentReference doc = workoutsCollection.doc(workout.documentId);
    doc.update(workoutJson);
  }

  static Future<void> removeWorkout(Workout workout) async {
    if (workout.documentId == null)
      return;
    CollectionReference workoutsCollection = await getWorkoutCollection();
    DocumentReference doc = workoutsCollection.doc(workout.documentId);
    await doc.delete();
  }
}