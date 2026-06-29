import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/TaskModel.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;
  CollectionReference get _tasksCollection =>
      _firestore.collection('Tasks');

  Stream<List<TaskModel>> watchUserTasks() {
    final uid = _uid;

  if (uid == null) {
    return const Stream.empty();
  }

    return _tasksCollection
        .where('owner_uid', isEqualTo: uid)
        .orderBy('due_date')
        .snapshots()
        .map((snap) =>
            snap.docs.map((doc) => TaskModel.fromFirestore(doc)).toList());
  }

  Future<void> createTask(TaskModel task) async {
    final docRef = _tasksCollection.doc();
    final newTask = task.copyWith(
      taskId: docRef.id,
      ownerUid: _uid,
      createdAt: DateTime.now(),
    );
    await docRef.set(newTask.toFirestore());
  }

  Future<void> toggleTaskStatus(TaskModel task) async {
    final newStatus = task.status == 'done' ? 'todo' : 'done';
    await _tasksCollection.doc(task.taskId).update({'status': newStatus});
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksCollection.doc(taskId).delete();
  }

  Future<void> updateTask(TaskModel task) async {
    await _tasksCollection.doc(task.taskId).update(task.toFirestore());
  }
}