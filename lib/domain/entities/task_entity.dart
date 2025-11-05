import 'package:equatable/equatable.dart';

class TaskEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String status;

  const TaskEntity({
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

  @override
  List<Object?> get props => [id, title, description, status];

  // Optional: Add these for better debugging
  @override
  String toString() {
    return 'TaskEntity(id: $id, title: $title, status: $status)';
  }
}
