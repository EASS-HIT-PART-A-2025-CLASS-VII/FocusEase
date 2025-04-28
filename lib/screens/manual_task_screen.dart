import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:focusease/utils/notification_service.dart';

class ManualTaskScreen extends StatefulWidget {
  final String token;

  const ManualTaskScreen({super.key, required this.token});

  @override
  State<ManualTaskScreen> createState() => _ManualTaskScreenState();
}

class _ManualTaskScreenState extends State<ManualTaskScreen> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  DateTime? selectedDueDate;
  int reminderMinutesBefore = 0;
  bool isLoading = false;
  String resultMessage = '';

  Future<void> selectDueDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (!mounted) return;

    if (picked != null) {
      setState(() {
        selectedDueDate = picked;
      });
    }
  }

  Future<void> createTask() async {
    final String title = titleController.text.trim();
    final int? duration = int.tryParse(durationController.text.trim());

    if (title.isEmpty ||
        duration == null ||
        duration <= 0 ||
        selectedDueDate == null) {
      setState(() {
        resultMessage = '❗ Please enter a title, duration, and due date.';
      });
      return;
    }

    setState(() {
      isLoading = true;
      resultMessage = '';
    });

    final url = Uri.parse('http://localhost:8000/tasks');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${widget.token}',
        },
        body: jsonEncode({
          'title': title,
          'duration': duration,
          'due_date': selectedDueDate!.toIso8601String(),
        }),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        if (reminderMinutesBefore > 0) {
          final notificationService = NotificationService();
          await notificationService.init();
          final reminderTime = selectedDueDate!
              .subtract(Duration(minutes: reminderMinutesBefore));
          if (reminderTime.isAfter(DateTime.now())) {
            await notificationService.scheduleNotification(
              id: DateTime.now().millisecondsSinceEpoch ~/ 1000,
              title: 'Task Reminder',
              body: 'Time to do: $title',
              scheduledDate: reminderTime,
            );
          }
        }

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Task created & reminder set!")),
        );

        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          Navigator.pushReplacementNamed(context, '/tasks',
              arguments: widget.token);
        });
      } else {
        setState(() {
          resultMessage = '❌ Failed: ${response.body}';
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        resultMessage = '❌ Error: $e';
      });
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Manual Task')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: 'Task Title'),
              ),
              TextField(
                controller: durationController,
                decoration:
                    const InputDecoration(labelText: 'Duration (minutes)'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      selectedDueDate == null
                          ? 'No due date chosen'
                          : 'Due: ${selectedDueDate!.toLocal().toString().split(' ')[0]}',
                    ),
                  ),
                  TextButton(
                    onPressed: selectDueDate,
                    child: const Text('Choose Due Date'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text('Reminder before task:'),
                  const SizedBox(width: 10),
                  DropdownButton<int>(
                    value: reminderMinutesBefore,
                    items: const [
                      DropdownMenuItem(value: 0, child: Text("None")),
                      DropdownMenuItem(value: 5, child: Text("5 min")),
                      DropdownMenuItem(value: 15, child: Text("15 min")),
                      DropdownMenuItem(value: 30, child: Text("30 min")),
                      DropdownMenuItem(value: 60, child: Text("1 hour")),
                      DropdownMenuItem(value: 120, child: Text("2 hours")),
                    ],
                    onChanged: (value) {
                      setState(() {
                        reminderMinutesBefore = value!;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : createTask,
                child: isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Create Task'),
              ),
              const SizedBox(height: 20),
              Text(resultMessage),
            ],
          ),
        ),
      ),
    );
  }
}
