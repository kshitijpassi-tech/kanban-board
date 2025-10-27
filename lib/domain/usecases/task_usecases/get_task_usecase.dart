import '../../entities/task_entity.dart';
import '../../repositories/task_repo.dart';

class GetTaskUseCase {
  final TaskRepository _taskRepository;
  GetTaskUseCase(this._taskRepository);

  Stream<List<TaskEntity>> call(String userId) {
    return _taskRepository.getTasks(userId);
  }
}
