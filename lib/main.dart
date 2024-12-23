import 'package:flutter/material.dart';

/// Entry point of the application
void main() {
  runApp(const MyApp());
}

/// The main application widget that sets up the app structure and theme
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Manager', // Application title
      theme: ThemeData(primarySwatch: Colors.blue), // Define the app's theme
      home: const MainPage(), // Set the MainPage as the home screen
    );
  }
}

/// Model class to represent a Task
/// Contains:
/// - title (String): the name of the task
/// - date (String): the date of the task
class Task {
  String title;
  String date;

  Task({required this.title, required this.date});
}

/// The main page widget where tasks are managed
class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

/// The state for the MainPage widget
class _MainPageState extends State<MainPage> {
  final List<Task> tasks = []; // List to store all tasks
  final List<Task> canceledTasks = []; // List to store canceled tasks

  /// Function to add a new task
  void _addTask() {
    final titleController = TextEditingController(); // Controller for task title
    final dateController = TextEditingController(); // Controller for task date

    // Show dialog to add a task
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Task'), // Dialog title
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text field for task title
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              // Text field for task date
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Task Date'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            // Cancel button to dismiss dialog
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            // Add button to save the task
            TextButton(
              onPressed: () {
                setState(() {
                  // Add the new task to the task list
                  tasks.add(Task(
                    title: titleController.text,
                    date: dateController.text,
                  ));
                });
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Add Task'),
            ),
          ],
        );
      },
    );
  }

  /// Function to edit an existing task
  void _editTask(Task task) {
    final titleController = TextEditingController(text: task.title); // Pre-fill title
    final dateController = TextEditingController(text: task.date); // Pre-fill date

    // Show dialog to edit the task
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Task'), // Dialog title
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Text field for task title
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              // Text field for task date
              TextField(
                controller: dateController,
                decoration: const InputDecoration(labelText: 'Task Date'),
                keyboardType: TextInputType.datetime,
              ),
            ],
          ),
          actions: [
            // Cancel button to dismiss dialog
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            // Save button to update the task
            TextButton(
              onPressed: () {
                setState(() {
                  // Update task properties
                  task.title = titleController.text;
                  task.date = dateController.text;
                });
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Edit Task'),
            ),
          ],
        );
      },
    );
  }

  /// Function to cancel (remove) a task
  void _cancelTask(Task task) {
    setState(() {
      tasks.remove(task); // Remove the task from the active list
      canceledTasks.add(task); // Add the task to the canceled list
    });
  }

  /// Function to navigate to the page displaying canceled tasks
  void _showCanceledTasks() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CanceledTasksPage(canceledTasks: canceledTasks),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tasks')), // AppBar with title
      body: Column(
        children: [
          // List of tasks
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length, // Number of tasks
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title), // Task title
                  subtitle: Text(task.date), // Task date
                  leading: IconButton(
                    icon: const Icon(Icons.edit), // Edit icon
                    onPressed: () => _editTask(task), // Edit functionality
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.cancel), // Cancel icon
                    onPressed: () => _cancelTask(task), // Cancel functionality
                  ),
                );
              },
            ),
          ),
          // Buttons for adding and viewing canceled tasks
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: _addTask, // Add task functionality
                  child: const Text('Add Task'),
                ),
                ElevatedButton(
                  onPressed: _showCanceledTasks, // Show canceled tasks page
                  child: const Text('Show Canceled Tasks'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Page to display canceled tasks
class CanceledTasksPage extends StatelessWidget {
  final List<Task> canceledTasks; // List of canceled tasks

  const CanceledTasksPage({super.key, required this.canceledTasks});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Canceled Tasks')), // AppBar with title
      body: ListView.builder(
        itemCount: canceledTasks.length, // Number of canceled tasks
        itemBuilder: (context, index) {
          final task = canceledTasks[index];
          return ListTile(
            title: Text(task.title), // Canceled task title
            subtitle: Text(task.date), // Canceled task date
          );
        },
      ),
    );
  }
}
