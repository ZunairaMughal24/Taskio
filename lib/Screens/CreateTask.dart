import 'package:Notein/Screens/unityClass.dart';
import 'package:Notein/task.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class CreateTaskScreen extends StatefulWidget {
  final Color? color;

  const CreateTaskScreen({super.key, this.color});

  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  late Color _selectedColor;
  late TextEditingController _headingController;
  late TextEditingController _descriptionController;
  late DateTime _dateTime;
  late Task task;

  // Define a default color for tasks
  final Color _defaultTaskColor = Colors.grey;

  // get backgroundClr => Theme.of(context).scaffoldBackgroundColor;
// You can change this to any default color you prefer

  @override
  void initState() {
    super.initState();
    _headingController = TextEditingController();
    _descriptionController = TextEditingController();
    _dateTime = DateTime.now();
    // Use the default color if no color is provided
    task = Task(
      color: widget.color ?? _defaultTaskColor, // Added default color handling here
      heading: '',
      description: '',
      dateTime: _dateTime,
    );
    // Set the initial selected color to the default color
    _selectedColor = task.color;
  }

  @override
  void dispose() {
    _headingController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Access theme data here
    _selectedColor = const Color.fromARGB(255, 215, 188, 219);
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Pick a color'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _colorOption('Office', const Color.fromARGB(255, 187, 221, 248)),
              _colorOption('Work', const Color.fromARGB(255, 213, 247, 214)),
              _colorOption('Personal', const Color.fromARGB(255, 233, 216, 238)),
              // Add more color options as needed
            ],
          ),
        );
      },
    );
  }

  Widget _colorOption(String label, Color color) {
    return ListTile(
      onTap: () {
        setState(() {
          _selectedColor = color;
          task.color = color;
        });
        Navigator.pop(context); // Close the color picker dialog
      },
      title: Text(label),
      trailing: CircleAvatar(
        backgroundColor: color,
        radius: 12,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Task'),
        actions: [
          IconButton(
            icon: const Icon(Icons.color_lens),
            onPressed: _showColorPicker,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Implement settings functionality
            },
          ),
          IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () {
              // Implement notifications functionality
            },
          ),
        ],
      ),
      backgroundColor: _selectedColor,
      // Background color changes here
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          padding: const EdgeInsets.all(0.0),
          children: [
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color.fromARGB(255, 59, 59, 59)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 7),
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: _headingController,
                  decoration: const InputDecoration(
                    labelText: 'Heading',
                    labelStyle: TextStyle(
                      color: Colors.black, // Set the color of the label text
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              DateTimeHelper.formatDateTime(task.dateTime),
              style: const TextStyle(
                fontSize: 16.0,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16.0),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color.fromARGB(255, 59, 59, 59)),
              ),
              height: 430,
              child: Padding(
                padding: const EdgeInsets.only(left: 7),
                child: TextField(
                  controller: _descriptionController,
                  maxLines: null,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    labelStyle: TextStyle(
                      color: Colors.black, // Set the color of the label text
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                task = Task(
                  color: _selectedColor,
                  heading: _headingController.text,
                  description: _descriptionController.text,
                  dateTime: _dateTime,
                );

                final taskBox = Hive.box<Task>('tasks');
                taskBox.add(task);

                Navigator.pop(context); // Navigate back to previous screen
              },
              child: const Text('Save Task'),
            ),
          ],
        ),
      ),
    );
  }
}
