import '../../entities/task_entity.dart';
import '../../repositories/task_repo.dart';

class UpdateTask {
  final TaskRepository _taskRepository;
  UpdateTask(this._taskRepository);

  Future<void> call(String userId, TaskEntity task) {
    return _taskRepository.updateTask(userId, task);
  }
}
