import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('📅 Calendar'),
        actions: [
          IconButton(
            icon: const Icon(Icons.sync),
            tooltip: 'Sync to Google Calendar',
            onPressed: _syncToGoogleCalendar,
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.deepOrange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _selectedDay == null ? null : _createTaskForSelectedDay,
            child: const Text('➕ Add Task to Selected Date'),
          ),
        ],
      ),
    );
  }

  void _createTaskForSelectedDay() {
    if (_selectedDay != null) {
      // 🚀 You can navigate to manual task creation screen with pre-filled date
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Add task for ${_selectedDay!.toLocal().toString().split(' ')[0]}')),
      );
      // Example:
      // Navigator.push(context, MaterialPageRoute(builder: (context) => ManualTaskScreen(selectedDate: _selectedDay!)));
    }
  }

  void _syncToGoogleCalendar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('🛠️ Google Calendar sync not implemented yet!')),
    );
    // 👉 In next step, I will give you real sync code
  }
}
