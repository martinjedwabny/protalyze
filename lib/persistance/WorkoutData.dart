import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Protalyze/domain/Workout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class WorkoutDataManager {

  static final String usersKey = 'users';
  static final String workoutsKey = 'users';

  static List<Workout> getSavedWorkouts(){
    
  }

  static void setSavedWorkouts(List<Workout> workouts) async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    final Firestore firestore = Firestore.instance;
    FirebaseUser user = await auth.currentUser();
    Firestore.instance.collection(usersKey).document(user.uid).setData({
      workoutsKey : workouts.toString(),
    });
    print(workouts.toString());
  }
}