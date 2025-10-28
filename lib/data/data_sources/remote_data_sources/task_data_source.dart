import '../../../core/helpers/firebase_helper.dart';
import '../../models/task_model.dart';

class TaskRemoteDataSource {
  final FirebaseHelper _firebaseHelper;
  TaskRemoteDataSource(this._firebaseHelper);

  Stream<List<TaskModel>> getTasks(String userId) {
    return _firebaseHelper.firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .orderBy('title')
        .snapshots()
        .map((snap) => snap.docs.map(TaskModel.fromFirestore).toList());
  }

  Future<void> addTask(String userId, TaskModel task) async {
    await _firebaseHelper.firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .add(task.toFirestore());
  }

  Future<void> updateTask(String userId, TaskModel task) async {
    await _firebaseHelper.firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(task.id)
        .update(task.toFirestore());
  }

  Future<void> deleteTask(String userId, String taskId) async {
    await _firebaseHelper.firestore
        .collection('users')
        .doc(userId)
        .collection('tasks')
        .doc(taskId)
        .delete();
  }
}
