import '../../entities/task_entity.dart';
import '../../repositories/task_repo.dart';

class UpdateTaskUseCase {
  final TaskRepository _taskRepository;
  UpdateTaskUseCase(this._taskRepository);

  Future<void> call(String userId, TaskEntity task) {
    return _taskRepository.updateTask(userId, task);
  }
}
