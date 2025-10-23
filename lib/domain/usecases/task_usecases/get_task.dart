import '../../entities/task_entity.dart';
import '../../repositories/task_repo.dart';

class GetTask {
  final TaskRepository _taskRepository;
  GetTask(this._taskRepository);

  Stream<List<TaskEntity>> call(String userId) {
    return _taskRepository.getTasks(userId);
  }
}
