import '../../entities/task_entity.dart';
import '../../repositories/task_repo.dart';

class AddTaskUseCase {
  final TaskRepository _taskRepository;
  AddTaskUseCase(this._taskRepository);

  Future<void> call(String userId, TaskEntity task) {
    return _taskRepository.addTask(userId, task);
  }
}
