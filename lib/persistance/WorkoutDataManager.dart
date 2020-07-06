import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutDataManager {

  static final String usersKey = 'users';
  static final String workoutsKey = 'workouts';

  static Future<List<Workout>> getSavedWorkouts() async {
    CollectionReference workoutsCollection = await getWorkoutCollection();
    QuerySnapshot query = await workoutsCollection.getDocuments();
    return query.documents.map((e) { 
      Workout workout = Workout.fromJson(e.data);
      workout.documentId = e.documentID;
      return workout;
    }).toList();
  }

  static Future<CollectionReference> getWorkoutCollection() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    DocumentReference userDoc = Firestore.instance.collection(usersKey).document(user.uid);
    CollectionReference workoutsCollection = userDoc.collection(workoutsKey);
    return workoutsCollection;
  }

  static Future<void> addWorkout(Workout workout) async {
    CollectionReference workoutsCollection = await getWorkoutCollection();
    Map<String, dynamic> workoutJson = workout.toJson();
    DocumentReference doc = await workoutsCollection.add(workoutJson);
    workout.documentId = doc.documentID;
  }

  static Future<void> updateWorkout(Workout workout) async {
    if (workout.documentId == null)
      return;
    CollectionReference workoutsCollection = await getWorkoutCollection();
    Map<String, dynamic> workoutJson = workout.toJson();
    DocumentReference doc = workoutsCollection.document(workout.documentId);
    doc.updateData(workoutJson);
  }

  static Future<void> removeWorkout(Workout workout) async {
    if (workout.documentId == null)
      return;
    CollectionReference workoutsCollection = await getWorkoutCollection();
    DocumentReference doc = workoutsCollection.document(workout.documentId);
    await doc.delete();
  }
}