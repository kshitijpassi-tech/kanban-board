class TaskEntity {
  final String id;
  final String title;
  final String description;
  final String status;

  TaskEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  });

  TaskEntity copyWith({
    String? id,
    String? title,
    String? description,
    String? status,
  }) {
    return TaskEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      status: status ?? this.status,
    );
  }
}
