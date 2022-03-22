import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protalyze/common/domain/PastWorkout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastWorkoutDataManager {
  static final String usersKey = 'users';
  static final String pastWorkoutsKey = 'pastWorkouts';

  static Future<List<PastWorkout>> getSavedPastWorkouts() async {
    CollectionReference collection = await getPastWorkoutCollection();
    QuerySnapshot query = await collection.get();
    return query.docs.map((QueryDocumentSnapshot e) {
      PastWorkout item = PastWorkout.fromJson(e.data());
      item.documentId = e.id;
      return item;
    }).toList();
  }

  static Future<CollectionReference> getPastWorkoutCollection() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection(usersKey).doc(user.uid);
    CollectionReference collection = userDoc.collection(pastWorkoutsKey);
    return collection;
  }

  static Future<void> addPastWorkout(PastWorkout item) async {
    CollectionReference collection = await getPastWorkoutCollection();
    Map<String, dynamic> itemJson = item.toJson();
    DocumentReference doc = await collection.add(itemJson);
    item.documentId = doc.id;
  }

  static Future<void> updatePastWorkout(PastWorkout item) async {
    if (item.documentId == null) return;
    CollectionReference collection = await getPastWorkoutCollection();
    Map<String, dynamic> itemJson = item.toJson();
    DocumentReference doc = collection.doc(item.documentId);
    doc.update(itemJson);
  }

  static Future<void> removePastWorkout(PastWorkout item) async {
    if (item.documentId == null) return;
    CollectionReference collection = await getPastWorkoutCollection();
    DocumentReference doc = collection.doc(item.documentId);
    await doc.delete();
  }
}
