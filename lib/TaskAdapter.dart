import 'package:Notein/task.dart';
import 'package:hive/hive.dart';
import 'package:flutter/material.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final heading = reader.readString();
    final description = reader.readString();
    final timestamp = DateTime.parse(reader.readString()); // Read as String and parse as DateTime
    final colorValue = reader.readInt32();
    final color = Color(colorValue);
    final completed = reader.readBool();
    final completionDate = reader.readBool()
        ? DateTime.parse(reader.readString())
        : null; // Read as String and parse as DateTime, handle nullability
    return Task(
      heading: heading,
      description: description,
      dateTime: timestamp,
      color: color,
      completed: completed,
      completionDate: completionDate,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeString(obj.heading);
    writer.writeString(obj.description);
    writer.writeString(obj.dateTime.toIso8601String()); // Write as String
    writer.writeInt32(obj.color.value);
    writer.writeBool(obj.completed ?? false);
    if (obj.completionDate != null) {
      writer.writeBool(true); // Indicate that completionDate is not null
      writer.writeString(obj.completionDate!.toIso8601String()); // Write as String
    } else {
      writer.writeBool(false); // Indicate that completionDate is null
    }
  }
}
