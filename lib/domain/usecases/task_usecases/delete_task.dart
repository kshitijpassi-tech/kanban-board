import '../../repositories/task_repo.dart';

class DeleteTask {
  final TaskRepository _taskRepository;
  DeleteTask(this._taskRepository);

  Future<void> call(String userId, String taskId) {
    return _taskRepository.deleteTask(userId, taskId);
  }
}
