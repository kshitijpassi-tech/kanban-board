import '../../repositories/task_repo.dart';

class DeleteTaskUseCase {
  final TaskRepository _taskRepository;
  DeleteTaskUseCase(this._taskRepository);

  Future<void> call(String userId, String taskId) {
    return _taskRepository.deleteTask(userId, taskId);
  }
}
