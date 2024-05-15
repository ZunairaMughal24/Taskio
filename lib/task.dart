import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String heading;

  @HiveField(1)
  late String description;

  @HiveField(2)
  late DateTime dateTime;

  @HiveField(3)
  late Color color;

  @HiveField(4)
  bool completed;

  @HiveField(5)
  DateTime? completionDate;

  Task({
    required this.heading,
    required this.description,
    required this.dateTime,
    required this.color,
    this.completed = false,
    this.completionDate,
  });
}
