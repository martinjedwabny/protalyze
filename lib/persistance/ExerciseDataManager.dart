import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:protalyze/common/domain/ExerciseBlock.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ExerciseDataManager {
  static final String usersKey = 'users';
  static final String exercisesKey = 'exercises';

  static Future<List<ExerciseBlock>> getSavedExerciseBlocks() async {
    CollectionReference exercisesCollection =
        await getExerciseBlockCollection();
    QuerySnapshot query = await exercisesCollection.get();
    return query.docs.map((e) {
      ExerciseBlock exercise = ExerciseBlock.fromJson(e.data());
      exercise.documentId = e.id;
      return exercise;
    }).toList();
  }

  static Future<CollectionReference> getExerciseBlockCollection() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    User user = auth.currentUser;
    DocumentReference userDoc =
        FirebaseFirestore.instance.collection(usersKey).doc(user.uid);
    CollectionReference exercisesCollection = userDoc.collection(exercisesKey);
    return exercisesCollection;
  }

  static Future<void> addExerciseBlock(ExerciseBlock exercise) async {
    CollectionReference exercisesCollection =
        await getExerciseBlockCollection();
    Map<String, dynamic> exerciseJson = exercise.toJson();
    DocumentReference doc = await exercisesCollection.add(exerciseJson);
    exercise.documentId = doc.id;
  }

  static Future<void> updateExerciseBlock(ExerciseBlock exercise) async {
    if (exercise.documentId == null) return;
    CollectionReference exercisesCollection =
        await getExerciseBlockCollection();
    Map<String, dynamic> exerciseJson = exercise.toJson();
    DocumentReference doc = exercisesCollection.doc(exercise.documentId);
    doc.update(exerciseJson);
  }

  static Future<void> removeExerciseBlock(ExerciseBlock exercise) async {
    if (exercise.documentId == null) return;
    CollectionReference exercisesCollection =
        await getExerciseBlockCollection();
    DocumentReference doc = exercisesCollection.doc(exercise.documentId);
    await doc.delete();
  }
}
