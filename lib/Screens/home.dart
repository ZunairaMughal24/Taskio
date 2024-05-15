import 'package:Notein/Screens/CreateTask.dart';
import 'package:Notein/Screens/taskDetail.dart';
import 'package:Notein/Screens/unityClass.dart';
import 'package:Notein/task.dart';
import 'package:Notein/theme.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Color _selectedColor;
  late List<Task> tasks;
  bool _taskOptionsVisible = false; // Add this variable to control the visibility of the task options
  late Box<Task> taskBox;
  @override
  void initState() {
    super.initState();
    _selectedColor = const Color.fromARGB(255, 215, 188, 219);
    _loadTasks();
    taskBox = Hive.box<Task>('tasks');
  }

  Future<void> _loadTasks() async {
    try {
      final taskBox = await Hive.openBox<Task>('tasks');
      setState(() {
        tasks = taskBox.values.toList();
      });
    } catch (e) {
      // ignore: avoid_print
      print('Error loading tasks: $e');
    }
  }

  void _shareTask(Task task) {
    Share.share('Task: ${task.heading}\nDescription: ${task.description}\nEdited: ${task.dateTime.toString()}');
  }

  // Function to toggle between light and dark themes
  void _toggleTheme(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    ThemeType currentTheme = Theme.of(context).brightness == Brightness.light ? ThemeType.light : ThemeType.dark;
    ThemeType newTheme = currentTheme == ThemeType.light ? ThemeType.dark : ThemeType.light;
    themeProvider.setTheme(newTheme);
  }

  void _updateTask(Task task) {
    final taskBox = Hive.box<Task>('tasks');
    taskBox.put(task.key, task);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Taskio'),
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
          IconButton(
            icon: Icon(
              Theme.of(context).brightness == Brightness.light ? Icons.dark_mode : Icons.light_mode,
            ),
            onPressed: () => _toggleTheme(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: Hive.box<Task>('tasks').listenable(),
              builder: (context, Box<Task> box, _) {
                tasks = box.values.toList();
                return _buildTaskList();
              },
            ),
          ),
          if (_taskOptionsVisible) _buildTaskOptionsDialog(), // Show task options if visible
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: const Color.fromARGB(255, 215, 188, 219),
        onTap: (index) {
          // Handle bottom nav bar item tap
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
        backgroundColor: _selectedColor,
        child: const Icon(
          Icons.edit,
          color: Colors.black,
        ),
        onPressed: () {
          setState(() {
            _taskOptionsVisible = !_taskOptionsVisible; // Toggle task options visibility
          });
        },
      ),
    );
  }

  Widget _buildTaskList() {
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) {
        final task = tasks[index];
        return _buildTaskListItem(task);
      },
    );
  }

  void _markTaskAsCompleted(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDarkTheme ? Colors.white : Colors.black;

        return AlertDialog(
          title: Text(
            'Mark Task as Completed',
            style: TextStyle(color: textColor), // Set text color based on theme
          ),
          content: Text(
            'Have you completed this task?',
            style: TextStyle(color: textColor), // Set text color based on theme
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog and return false
              },
              child: Text(
                'No',
                style: TextStyle(color: textColor), // Set text color based on theme
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog and return true
              },
              child: Text(
                'Yes',
                style: TextStyle(color: textColor), // Set text color based on theme
              ),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed != null) {
        // Toggle task completion status based on user input
        if (confirmed) {
          // Mark as completed
          setState(() {
            task.completed = true;
            task.completionDate = DateTime.now();
          });
        } else {
          // Undo completion
          setState(() {
            task.completed = false;
            task.completionDate = null;
          });
        }
        // Update the task in Hive
        _updateTask(task);
      }
    });
  }

// Updated _buildTaskListItem method to display completion status icon
  Widget _buildTaskListItem(Task task) {
    // Define default color
    final isCompleted = task.completed;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: task.color,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TaskDetailScreen(
                    task: task,
                    completionStatus: task.completed,
                  ),
                ),
              );
            },
            onLongPress: () {
              _markTaskAsCompleted(task); // Mark task as completed on long press
            },
            child: Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: Text(
                      task.heading,
                      style: TextStyle(
                        fontSize: 17,
                        color: isCompleted
                            ? Colors.black.withOpacity(0.5)
                            : Colors.black, // Use opacity to indicate completed task
                        decoration:
                            isCompleted ? TextDecoration.lineThrough : null, // Add line-through if task is completed
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          DateTimeHelper.formatDateTime(task.dateTime),
                          style: const TextStyle(
                            fontSize: 12.0,
                            color: Colors.black,
                          ),
                        ),
                        const Divider(
                          color: Colors.black,
                        ),
                        Text(
                          task.description,
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                        ),
                        if (task.completed)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Completed ',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.green, // Use green color for completed tasks
                                ),
                              ),
                              Text(
                                '${DateTimeHelper.formatDateTime(task.completionDate!)}',
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.black, // Use green color for completed tasks
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(
                    Icons.share_rounded,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _shareTask(task);
                  },
                ),
                IconButton(
                  // Add a delete icon
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    _showDeleteConfirmationDialog(task);
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

// Method to show a confirmation dialog before deleting the task
  void _showDeleteConfirmationDialog(Task task) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final isDarkTheme = Theme.of(context).brightness == Brightness.dark;
        final textColor = isDarkTheme ? Colors.white : Colors.black;

        return AlertDialog(
          title: Text(
            'Confirm Delete',
            style: TextStyle(color: textColor), // Set text color based on theme
          ),
          content: Text(
            'Are you sure you want to delete this task?',
            style: TextStyle(color: textColor), // Set text color based on theme
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Close the dialog and return false
              },
              child: Text(
                'No',
                style: TextStyle(color: textColor), // Set text color based on theme
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true); // Close the dialog and return true
              },
              child: Text(
                'Yes',
                style: TextStyle(color: textColor), // Set text color based on theme
              ),
            ),
          ],
        );
      },
    ).then((confirmed) {
      if (confirmed != null && confirmed) {
        _deleteTask(task);
      }
    });
  }

// Method to delete the task from Hive
  void _deleteTask(Task task) {
    final taskBox = Hive.box<Task>('tasks');
    taskBox.delete(task.key); // Assuming task has a unique key
  }

  Widget _buildTaskOptionsDialog() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildTaskOptionButton(
            'Add Text',
            Icons.text_fields,
            _addTextTask,
          ),
          _buildTaskOptionButton('Add Checklist', Icons.check_box, _addChecklistTask),
        ],
      ),
    );
  }

  Widget _buildTaskOptionButton(String label, IconData icon, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.black,
        ),
        label: Text(
          label,
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color.fromARGB(255, 215, 188, 219),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
      ),
    );
  }

  void _addTextTask() {
    setState(() {
      _taskOptionsVisible = false; // Hide task options when navigating to task creation screen
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreateTaskScreen(),
      ),
    );
  }

  void _addChecklistTask() {
    // Add checklist task logic
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
              _colorOption('Office', Colors.blue),
              _colorOption('Work', Colors.green),
              _colorOption('Personal', Colors.pink),
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
}
