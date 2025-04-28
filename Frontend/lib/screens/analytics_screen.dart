import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AnalyticsScreen extends StatelessWidget {
  final int totalTasks;
  final int completedTasks;
  final int totalMinutes;

  const AnalyticsScreen({
    super.key,
    required this.totalTasks,
    required this.completedTasks,
    required this.totalMinutes,
  });

  @override
  Widget build(BuildContext context) {
    final incompleteTasks = totalTasks - completedTasks;

    return Scaffold(
      appBar: AppBar(title: const Text('Productivity Analytics')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Task Completion Rate',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: [
                    PieChartSectionData(
                      value: completedTasks.toDouble(),
                      title: 'Completed ($completedTasks)',
                      color: Colors.green,
                      radius: 60,
                    ),
                    PieChartSectionData(
                      value: incompleteTasks.toDouble(),
                      title: 'Incomplete ($incompleteTasks)',
                      color: Colors.redAccent,
                      radius: 60,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Text(
                      '📌 Total Tasks: $totalTasks',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '✅ Completed: $completedTasks',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      '🕒 Total Focus Time: $totalMinutes mins',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
