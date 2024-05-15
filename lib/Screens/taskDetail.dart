import 'package:Notein/Screens/CreateTask.dart';
import 'package:Notein/Screens/taskEdit.dart';
import 'package:Notein/Screens/unityClass.dart';
import 'package:Notein/task.dart';
import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final Task task;
  final bool completionStatus;

  const TaskDetailScreen({super.key, required this.task, required this.completionStatus});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Task Detail'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              if (completionStatus) {
                // Show dialog to prompt user to create a new task
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Create New Task'),
                      content: const Text('This task is already completed. Do you want to create a new one?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context); // Close the dialog
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to the create task screen or perform any other action
                            Navigator.pop(context); // Close the dialog
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const CreateTaskScreen(),
                              ),
                            );
                          },
                          child: const Text('Create'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                // Navigate to the edit task screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditTaskScreen(task: task),
                  ),
                );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              task.heading,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Date: ${DateTimeHelper.formatDateTime(task.dateTime)}',
              style: const TextStyle(fontSize: 12),
            ),
            const Divider(
              color: Colors.black,
            ),
            Text(
              task.description,
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Text(
                  'Status: ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
                Text(
                  completionStatus ? 'Completed' : 'Not Completed',
                  style: TextStyle(
                    fontSize: 15,
                    color: completionStatus ? Colors.green : Colors.red,
                  ),
                ),
              ],
            ),
            if (completionStatus && task.completionDate != null) // Show completion date if task is completed
              Row(
                children: [
                  const Text(
                    'Date: ',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${DateTimeHelper.formatDateTime(task.completionDate!)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
