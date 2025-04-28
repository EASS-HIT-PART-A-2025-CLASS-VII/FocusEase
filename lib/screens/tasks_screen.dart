import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:focusease/screens/analytics_screen.dart';

class TasksScreen extends StatefulWidget {
  final String token;

  const TasksScreen({super.key, required this.token});

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<dynamic> tasks = [];
  Set<int> completedTaskIds = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTasks();
  }

  Future<void> fetchTasks() async {
    final url = Uri.parse('http://localhost:8000/tasks');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer ${widget.token}',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final fetchedTasks = jsonDecode(response.body);
      setState(() {
        tasks = sortTasksSmartly(fetchedTasks);
        isLoading = false;
      });
    } else {
      setState(() => isLoading = false);
      print('Failed to fetch tasks: ${response.body}');
    }
  }

  List<dynamic> sortTasksSmartly(List<dynamic> tasks) {
    tasks.sort((a, b) {
      DateTime? dueA =
          a['due_date'] != null ? DateTime.parse(a['due_date']) : null;
      DateTime? dueB =
          b['due_date'] != null ? DateTime.parse(b['due_date']) : null;

      if (dueA == null && dueB == null) {
        return a['duration'].compareTo(b['duration']);
      } else if (dueA == null) {
        return 1;
      } else if (dueB == null) {
        return -1;
      } else {
        int dateCompare = dueA.compareTo(dueB);
        return dateCompare != 0
            ? dateCompare
            : a['duration'].compareTo(b['duration']);
      }
    });

    return tasks;
  }

  void toggleTaskComplete(int taskId) {
    setState(() {
      if (completedTaskIds.contains(taskId)) {
        completedTaskIds.remove(taskId);
      } else {
        completedTaskIds.add(taskId);
      }
    });
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('jwt_token');
    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    final totalMinutes =
        tasks.fold<int>(0, (sum, task) => sum + (task['duration'] as int));
    final completedTasks = completedTaskIds.length;
    final totalTasks = tasks.length;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Tasks (Smartly Sorted)'),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics),
            tooltip: 'Analytics',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AnalyticsScreen(
                    totalTasks: totalTasks,
                    completedTasks: completedTasks,
                    totalMinutes: totalMinutes,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: logout,
            tooltip: 'Logout',
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton(
            heroTag: 'manualTask',
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/manual',
                arguments: widget.token,
              );
            },
            tooltip: 'Add Manual Task',
            child: const Icon(Icons.edit_note),
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'uploadImage',
            onPressed: () {
              Navigator.pushReplacementNamed(
                context,
                '/media',
                arguments: widget.token,
              );
            },
            tooltip: 'Add via Screenshot',
            child: const Icon(Icons.image),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : tasks.isEmpty
              ? const Center(child: Text('No tasks found.'))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Text(
                        "🧠 Total Focus Time: $totalMinutes min",
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Expanded(
                        child: ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            final taskId = task['id'];
                            final isCompleted =
                                completedTaskIds.contains(taskId);

                            return AnimatedOpacity(
                              duration: const Duration(milliseconds: 300),
                              opacity: isCompleted ? 0.5 : 1.0,
                              child: CheckboxListTile(
                                value: isCompleted,
                                onChanged: (_) => toggleTaskComplete(taskId),
                                title: Text(
                                  task['title'],
                                  style: TextStyle(
                                    decoration: isCompleted
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: isCompleted
                                        ? Colors.grey
                                        : Colors.black,
                                  ),
                                ),
                                subtitle: Text(
                                  'Due: ${task['due_date'] != null ? task['due_date'].toString().split('T')[0] : "No date"} | Duration: ${task['duration']} min',
                                  style: TextStyle(
                                    color: isCompleted
                                        ? Colors.grey
                                        : Colors.black87,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
