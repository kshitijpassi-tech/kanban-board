import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../domain/entities/task_entity.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel extends TaskEntity {
  @HiveField(0)
  @override
  final String id;

  @HiveField(1)
  @override
  final String title;

  @HiveField(2)
  @override
  final String description;

  @HiveField(3)
  @override
  final String status;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
  }) : super(id: id, title: title, description: description, status: status);

  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      status: data['status'] ?? 'todo',
    );
  }

  Map<String, dynamic> toFirestore() => {
    'title': title,
    'description': description,
    'status': status,
  };

  factory TaskModel.fromEntity(TaskEntity entity) => TaskModel(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    status: entity.status,
  );

  TaskEntity toEntity() => TaskEntity(
    id: id,
    title: title,
    description: description,
    status: status,
  );
}
