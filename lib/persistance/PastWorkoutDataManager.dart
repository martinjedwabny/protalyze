import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:Protalyze/domain/PastWorkout.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PastWorkoutDataManager {

  static final String usersKey = 'users';
  static final String pastWorkoutsKey = 'pastWorkouts';

  static Future<List<PastWorkout>> getSavedPastWorkouts() async {
    CollectionReference collection = await getPastWorkoutCollection();
    QuerySnapshot query = await collection.getDocuments();
    return query.documents.map((e) { 
      PastWorkout item = PastWorkout.fromJson(e.data);
      item.documentId = e.documentID;
      return item;
    }).toList();
  }

  static Future<CollectionReference> getPastWorkoutCollection() async{
    final FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseUser user = await auth.currentUser();
    DocumentReference userDoc = Firestore.instance.collection(usersKey).document(user.uid);
    CollectionReference collection = userDoc.collection(pastWorkoutsKey);
    return collection;
  }

  static Future<void> addPastWorkout(PastWorkout item) async {
    CollectionReference collection = await getPastWorkoutCollection();
    Map<String, dynamic> itemJson = item.toJson();
    DocumentReference doc = await collection.add(itemJson);
    item.documentId = doc.documentID;
  }

  static Future<void> updatePastWorkout(PastWorkout item) async {
    if (item.documentId == null)
      return;
    CollectionReference collection = await getPastWorkoutCollection();
    Map<String, dynamic> itemJson = item.toJson();
    DocumentReference doc = collection.document(item.documentId);
    doc.updateData(itemJson);
  }

  static Future<void> removePastWorkout(PastWorkout item) async {
    if (item.documentId == null)
      return;
    CollectionReference collection = await getPastWorkoutCollection();
    DocumentReference doc = collection.document(item.documentId);
    await doc.delete();
  }
}